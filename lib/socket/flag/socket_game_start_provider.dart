import 'package:flutter_riverpod/legacy.dart';

// ブロードキャストされるゲーム開始のフラグを管理.
final socketGameStartProvider = StateProvider<bool>((ref) => false);