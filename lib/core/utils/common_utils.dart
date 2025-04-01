import 'dart:developer';


class CommonUtils {
  static final CommonUtils _instance = CommonUtils._internal();

  CommonUtils._internal();

  factory CommonUtils() {
    return _instance;
  }

  bool isLatestVersion(String version, String latest) {
    int? installedVersion = int.tryParse(version.replaceAll(".", ""));
    int? latestVersion = int.tryParse(latest.replaceAll(".", ""));
    return (installedVersion ?? 0) >= (latestVersion ?? 0);
  }

  int? countDigitsAfterDecimal(String input) {
    if (input.isEmpty) return null;
    if (input.contains(".")) {
      String decimalPart = input.split('.')[1];
      return decimalPart.length;
    } else
      return null;
  }

  bool isNumeric(String input) {
    // Use a regular expression to match only digits and the dot symbol
    RegExp regex = RegExp(r'^[0-9.]+$');
    log("regex = $regex");
    return regex.hasMatch(input);
  }

  double formatDouble(String input) {
    double number = double.tryParse(input) ?? 0;
    if (number % 1 != 0 && number.toString().split('.')[1].length == 1) {
      return double.parse(number.toStringAsFixed(2));
    }
    return number;
  }

  bool isPhoneNumberValid(String phone) {
    if (phone.startsWith("019") ||
        phone.startsWith("013") ||
        phone.startsWith("015") ||
        phone.startsWith("011") ||
        phone.startsWith("014") ||
        phone.startsWith("016") ||
        phone.startsWith("017") ||
        phone.startsWith("018")) {
      if (phone.length == 11) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

}
