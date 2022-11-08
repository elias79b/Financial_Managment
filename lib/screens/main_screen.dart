import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:financial_management/models/money.dart';
import 'package:financial_management/screens/info_Screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'home_screen.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0 ;
  Widget body = HomeScreen();
  Box<Money> hiveBox = Hive.box<Money>('moneyBox');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: AnimatedBottomNavigationBar(
            inactiveColor: Colors.black54,
            icons: const[Icons.home,Icons.info],
            activeIndex: currentIndex,
            gapLocation: GapLocation.center,
            notchSmoothness: NotchSmoothness.smoothEdge,
            onTap: (index){
              if(index == 0 ){ body = HomeScreen(); }
              else{ body = InfoScreen();}
              setState(() {
                currentIndex = index;
              });
            }),
        body: body,
      ),
    );
  }
}
