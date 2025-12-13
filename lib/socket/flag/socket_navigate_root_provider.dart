import 'package:flutter_riverpod/legacy.dart';

// 親がルーム削除したとき、子が退出したときのページ遷移をフラグで管理.
final socketNavigateRootProvider = StateProvider<int>((ref) => 0);