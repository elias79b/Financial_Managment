
import 'package:flutter/material.dart';
import 'package:my_flutter_app/utils/calculate.dart';
import 'package:my_flutter_app/widget/chart_widget.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({Key? key}) : super(key: key);

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SizedBox(
          child: Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding:  EdgeInsets.only(right: 20, top: 20, left: 5),
                  child: Text("مدیریت تراکنش ها "),
                ),
                MoneyInfoWidget(
                  ///
                    firstText: ":پرداختی امروز",
                    secondText: ":دریافتی امروز ",
                    firsPrice: Calculate.dToday().toString(),
                    secondPrice: Calculate.pToday().toString(),
                ),
                MoneyInfoWidget(
                    firstText: ":پرداختی ماه",
                    secondText: ":دریافتی  ماه ",
                    firsPrice: Calculate.dMonth().toString(),
                    secondPrice: Calculate.pMonth().toString()),
                MoneyInfoWidget(
                    firstText: ":پرداختی  سال ",
                    secondText: ":دریافتی سال ",
                    firsPrice: Calculate.dYear().toString(),
                    secondPrice: Calculate.pYear().toString()),
                const SizedBox(height: 20),
                Calculate.dYear() == 0 && Calculate.pYear() == 0
                    ? Container()
                    : Container(
                  padding: const EdgeInsets.all(20.0),
                  height: 200,
                  child: BarChartWidget(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MoneyInfoWidget extends StatelessWidget {
  final String firstText;
  final String secondText;
  final String firsPrice;
  final String secondPrice;

  const MoneyInfoWidget(
      {Key? key,
      required this.firstText,
      required this.secondText,
      required this.firsPrice,
      required this.secondPrice})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
              child: Text(
            secondPrice,
            textAlign: TextAlign.right,

          )),
          Text(secondText),
          Expanded(
              child: Text(
            firsPrice,
            textAlign: TextAlign.right,
          )),
          Text(firstText),
        ],
      ),
    );
  }
}
