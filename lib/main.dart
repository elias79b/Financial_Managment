
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_flutter_app/models/money.dart';
import 'package:my_flutter_app/screens/home_screen.dart';
import 'package:my_flutter_app/screens/main_screen.dart';

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

