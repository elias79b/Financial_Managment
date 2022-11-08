import 'package:financial_management/constant.dart';
import 'package:financial_management/main.dart';
import 'package:financial_management/models/money.dart';
import 'package:financial_management/screens/new_transactions_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:searchbar_animation/searchbar_animation.dart';

class HomeScreen extends StatefulWidget {
  static List<Money> moneys = [];

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  final TextEditingController searchController = TextEditingController();
  Box<Money> hiveBox = Hive.box<Money>('moneyBox');

  void initState() {
    Myapp.getDate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: fabWidget(),
        body: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              headerWidget(),
              // MyListTileWidget()
              // Expanded(child: EmptyWidget())

              Expanded(
                child: HomeScreen.moneys.isEmpty
                    ? EmptyWidget()
                    : ListView.builder(
                        itemCount: HomeScreen.moneys.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                              /////edite
                              onTap: () {
                                NewTransactionsScreen.date =
                                    HomeScreen.moneys[index].date;
                                NewTransactionsScreen.descriptionController
                                    .text = HomeScreen.moneys[index].title;
                                NewTransactionsScreen.priceController.text =
                                    HomeScreen.moneys[index].price;
                                NewTransactionsScreen.groupId =
                                    HomeScreen.moneys[index].isReceived ? 1 : 2;
                                NewTransactionsScreen.isEditing = true;
                                NewTransactionsScreen.id =
                                    HomeScreen.moneys[index].id;
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          NewTransactionsScreen(),
                                    )).then((value) {
                                  Myapp.getDate();
                                  setState(() {});
                                });
                              },

                              //// delete
                              onLongPress: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    actionsAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    title: Text(
                                        "آیا از حذف این آیتم مطمئن هستید؟"),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            hiveBox.deleteAt(index);

                                            setState(() {
                                              // HomeScreen.moneys.removeAt(index);
                                              Myapp.getDate();
                                            });
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            "بله",
                                            style:
                                                TextStyle(color: kGreenColor),
                                          )),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text("خیر",
                                              style:
                                                  TextStyle(color: kRedColor)))
                                    ],
                                  ),
                                );
                              },
                              child: MyListTileWidget(
                                index: index,
                              ));
                        }),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget headerWidget() {
    return Padding(
      padding: const EdgeInsets.only(right: 20, top: 20, left: 5),
      child: Row(
        children: [
          Expanded(
            child: SearchBarAnimation(
              textEditingController: searchController,
              isOriginalAnimation: false,
              hintText: "جستجو کنید....",
              buttonElevation: 0,
              buttonShadowColour: Colors.black26,
              buttonBorderColour: Colors.black26,
              onCollapseComplete: () {
                Myapp.getDate();
                searchController.text = "";
                setState(() {});
              },
              onFieldSubmitted: (String text) {
                List<Money> result = hiveBox.values
                    .where((value) =>
                        value.title.contains(text) || value.date.contains(text))
                    .toList();
                HomeScreen.moneys.clear();
                setState(() {
                  for (var value in result) {
                    HomeScreen.moneys.add(value);
                  }
                });

                // print(result[0].title);
              },
              trailingWidget: const Icon(
                Icons.search,
                size: 20,
                color: Colors.black,
              ),
              secondaryButtonWidget: const Icon(
                Icons.add,
                size: 20,
                color: Colors.black,
              ),
              buttonWidget: const Icon(
                Icons.search,
                size: 20,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Text("تراکنش ها"),
        ],
      ),
    );
  }

  Widget fabWidget() {
    return FloatingActionButton(
      backgroundColor: kPurpleColor,
      elevation: 0,
      onPressed: () {
        /////////////برای خلی نگهداشتن بعد از اضفه کرده
        NewTransactionsScreen.date = 'تاریخ';
        NewTransactionsScreen.descriptionController.text = "";
        NewTransactionsScreen.priceController.text = "";
        NewTransactionsScreen.groupId = 0;
        NewTransactionsScreen.isEditing = false;
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewTransactionsScreen(),
            )).then((value) {
          Myapp.getDate();
          setState(() {});
        });
      },
      child: const Icon(Icons.add),
    );
  }
}

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        const Spacer(),
        SvgPicture.asset('assets/images/bu.svg', height: 150, width: 150),
        SizedBox(
          height: 10,
        ),
        const Text("!تراکنشی موجو نیست "),
        const Spacer(),
      ],
    ));
  }
}

class MyListTileWidget extends StatelessWidget {
  final int index;

  MyListTileWidget({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 2,
      color: Colors.white70,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  color: HomeScreen.moneys[index].isReceived
                      ? kRedColor
                      : kGreenColor,
                  borderRadius: BorderRadius.circular(15)),
              child: Center(
                child: Icon(
                    HomeScreen.moneys[index].isReceived
                        ? Icons.remove
                        : Icons.add,
                    color: Colors.white,
                    size: 30),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 15,
              ),
              child: Text(HomeScreen.moneys[index].title),
            ),
            Spacer(),
            Column(
              children: [
                Row(
                  children: [
                    Text("تومان",
                        style: TextStyle(
                            fontSize: 20,
                            color: HomeScreen.moneys[index].isReceived
                                ? kRedColor
                                : kGreenColor)),
                    Text(HomeScreen.moneys[index].price,
                        style: TextStyle(
                            fontSize: 20,
                            color: HomeScreen.moneys[index].isReceived
                                ? kRedColor
                                : kGreenColor))
                  ],
                ),
                Text(HomeScreen.moneys[index].date)
              ],
            )
          ],
        ),
      ),
    );
  }
}
