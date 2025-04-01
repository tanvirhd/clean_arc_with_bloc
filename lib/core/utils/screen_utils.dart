import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
//import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ScreenUtils {
  static final ScreenUtils _instance = ScreenUtils._internal();

  ScreenUtils._internal();

  factory ScreenUtils() {
    return _instance;
  }

  double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  Size getScreenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  /*AppLocalizations getLocale(BuildContext context) {
    return AppLocalizations.of(context)!;
  }*/

  hideKeyboard(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  unFocusKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  EdgeInsets padding(
      {double? top, double? bottom, double? right, double? left}) {
    return EdgeInsets.only(
        top: top ?? 0.0,
        bottom: bottom ?? 0.0,
        right: right ?? 0.0,
        left: left ?? 0.0);
  }

  EdgeInsets paddingAll({double? value}) {
    return EdgeInsets.all(value ?? 0.0);
  }

  EdgeInsets paddingSymmetric({double? horizontal, double? vertical}) {
    return EdgeInsets.symmetric(
        horizontal: horizontal ?? 0.0, vertical: vertical ?? 0.0);
  }

  EdgeInsets margin(
      {double? top, double? bottom, double? right, double? left}) {
    return EdgeInsets.only(
        top: top ?? 0.0,
        bottom: bottom ?? 0.0,
        right: right ?? 0.0,
        left: left ?? 0.0);
  }

  EdgeInsets marginAll({double? value}) {
    return EdgeInsets.all(value ?? 0.0);
  }

  EdgeInsets marginSymmetric({double? horizontal, double? vertical}) {
    return EdgeInsets.symmetric(
        horizontal: horizontal ?? 0.0, vertical: vertical ?? 0.0);
  }

  double getWidth({required BuildContext context, required double ratio}) {
    double calculatedWidth = ratio * MediaQuery.of(context).size.width * .01;
    return calculatedWidth;
  }

  postFrameCallback(Function call) {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      call();
    });
  }
}
