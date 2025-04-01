//import 'package:intl/intl.dart';

class StringUtils {
  StringUtils._();

  final bengaliDigits = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];

  String convertToBengaliNumber(num? number, {bool addTakaSign = false}) {
    if (number == null) return "০";

    String result = number.toString();
    for (int i = 0; i < 10; i++) {
      result = result.replaceAll(i.toString(), bengaliDigits[i]);
    }

    // Remove the fraction part if it is zero
    if (result.contains('.')) {
      List<String> parts = result.split('.');
      if (parts.length == 2 && parts[1] == '০') {
        result = parts[0];
      }
    }

    return addTakaSign ? "৳$result" : result;
  }

  /*static String addCommasToNumber(num number) {
    final formatter = NumberFormat('#,###');
    return formatter.format(number);
  }*/
}
