import 'package:flutter_riverpod/legacy.dart';

// 入力の主導権を管理、ゲーム開始時に親だった人.
final initiativeProvider = StateProvider<bool>((ref) => true); // debug用、本当は初期値flase.