import 'package:financial_management/models/money.dart';
import 'package:financial_management/screens/home_screen.dart';
import 'package:financial_management/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async{
  await Hive.initFlutter();
  Hive.registerAdapter(MoneyAdapter());
  await Hive.openBox<Money>("moneyBox");
  runApp( Myapp());
}

class Myapp extends StatelessWidget {
  const Myapp({Key? key}) : super(key: key);

  static void getDate(){
    HomeScreen.moneys.clear();
    Box<Money> hiveBox = Hive.box<Money>('moneyBox');
    for(var value in hiveBox.values){
      HomeScreen.moneys.add(value);
    }

  }
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      theme: ThemeData(fontFamily: "iransans"),
      debugShowCheckedModeBanner: false,
      title: "اپیکیشین مدیریت مالی",
      home: MainScreen(),
    );
  }
}

