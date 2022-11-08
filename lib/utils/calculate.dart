import 'package:financial_management/models/money.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

//
Box<Money> hiveBox = Hive.box<Money>('moneyBox');
//
String year = Jalali.now().year.toString();
String month = Jalali.now().month.toString().length == 1
    ? '0${Jalali.now().month}'
    : Jalali.now().month.toString();
String day = Jalali.now().day.toString().length == 1
    ? '0${Jalali.now().day}'
    : Jalali.now().day.toString();
//

class Calculate {
  static String today() {
    return year + '/' + month + '/' + day;
  }

  static double pToday() {
    double result = 0;
    for (var value in hiveBox.values) {
      if (value.date == today() && value.isReceived == false) {
        result += double.parse(value.price);
      }
    }
    return result;
  }

  static double dToday() {
    double result = 0;
    for (var value in hiveBox.values) {
      if (value.date == today() && value.isReceived == true) {
        result += double.parse(value.price);
      }
    }
    return result;
  }

  static double pMonth() {
    double result = 0;
    for (var value in hiveBox.values) {
      if (value.date.substring(5,7) == month && value.isReceived == false) {
        result += double.parse(value.price);
      }///1401/01/01
    }
    return result;
  }

  static double dMonth() {
    double result = 0;
    for (var value in hiveBox.values) {
      if (value.date.substring(5,7) == month && value.isReceived == true) {
        result += double.parse(value.price);
      }
    }
    return result;
  }

  static double pYear() {
    double result = 0;
    for (var value in hiveBox.values) {
      if (value.date.substring(0, 4) == year && value.isReceived == false) {
        result += double.parse(value.price);
      }
    }
    return result;
  }

  static double dYear() {
    double result = 0;
    for (var value in hiveBox.values) {
      if (value.date.substring(0, 4) == year && value.isReceived == true) {
        result += double.parse(value.price);
      }
    }
    return result;
  }
}
