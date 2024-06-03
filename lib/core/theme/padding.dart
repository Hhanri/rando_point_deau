import 'package:flutter/widgets.dart';

abstract final class AppPadding {
  static const all8 = EdgeInsets.all(8);
  static const all12 = EdgeInsets.all(12);
  static const all16 = EdgeInsets.all(16);
  static const all24 = EdgeInsets.all(24);
  static const all32 = EdgeInsets.all(32);

  static const h8 = EdgeInsets.symmetric(horizontal: 8);
  static const h12 = EdgeInsets.symmetric(horizontal: 12);
  static const h16 = EdgeInsets.symmetric(horizontal: 16);
  static const h24 = EdgeInsets.symmetric(horizontal: 24);
  static const h32 = EdgeInsets.symmetric(horizontal: 32);

  static const v8 = EdgeInsets.symmetric(vertical: 8);
  static const v12 = EdgeInsets.symmetric(vertical: 12);
  static const v16 = EdgeInsets.symmetric(vertical: 16);
  static const v24 = EdgeInsets.symmetric(vertical: 24);
  static const v32 = EdgeInsets.symmetric(vertical: 32);
}
