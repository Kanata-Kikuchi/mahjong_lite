import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahjong_lite/debug/debug_provider.dart';
import 'package:mahjong_lite/layout/button/back_btn.dart';
import 'package:mahjong_lite/page/score_share_page.dart/delete_room/content/delete_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

final double bottomBtnPadding = 5;

class DeleteRoom extends ConsumerStatefulWidget {
  const DeleteRoom({
    required this.socketRemoveSend,
    super.key
  });

  final void Function() socketRemoveSend;

  @override
  ConsumerState<DeleteRoom> createState() => _DeleteRoomState();
}

class _DeleteRoomState extends ConsumerState<DeleteRoom> {
  Future<bool?> deletePopup(BuildContext context) {
    return showCupertinoDialog(
      context: context,
      builder: (context) {
        return DeleteDialog();
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: bottomBtnPadding),
      child: BackBtn(
        label: 'ルーム消去',
        bold: true,
        onTap: () async {
          final result = await deletePopup(context);

          if (result == true) {
            
            final pref = await SharedPreferences.getInstance();
            await pref.remove('playerId');
            await pref.remove('roomId');
            
            widget.socketRemoveSend();
            if (ref.read(debugProvider)) {
              if (!mounted) return;
              Navigator.pushNamedAndRemoveUntil(context, '/room', (route) => false);
            }
          }
        }
      )
    );
  }
}