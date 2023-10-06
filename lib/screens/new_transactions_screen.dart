import 'dart:math';


import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:my_flutter_app/constant.dart';
import 'package:my_flutter_app/main.dart';
import 'package:my_flutter_app/models/money.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

class NewTransactionsScreen extends StatefulWidget {
  NewTransactionsScreen({Key? key}) : super(key: key);
  static int groupId = 0;
  static TextEditingController descriptionController = TextEditingController();
  static TextEditingController priceController = TextEditingController();
  static bool isEditing = false;
  static int id = 0;
  static String date = '';

  @override
  State<NewTransactionsScreen> createState() => _NewTransactionsScreenState();
}
class _NewTransactionsScreenState extends State<NewTransactionsScreen> {
  Box<Money> hiveBox = Hive.box<Money>('moneyBox');
  final _formKey = GlobalKey<FormState>();
  final _datekey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: _formKey,
        child: Scaffold(
          key: _datekey,
          backgroundColor: Colors.white,
          body: Container(
            width: double.infinity,
            margin: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  NewTransactionsScreen.isEditing
                      ? "ویرایش تراکنش"
                      : "تراکنش جدید",
                  style: TextStyle(fontSize: 18),
                ),
                MyTextfield(
                    hintText: "توضیحات",
                    controller: NewTransactionsScreen.descriptionController),
                MyTextfield(
                    hintText: "مبلغ",
                    type: TextInputType.number,
                    controller: NewTransactionsScreen.priceController),
                TypeAndDateWidget(),
                MyButton(
                  text: NewTransactionsScreen.isEditing
                      ? 'ویرایش کردن'
                      : 'اضافه کردن',
                  onPressed: () {
                    final valdate = _formKey.currentState!.validate();
                    final isvalidForm = _formKey.currentState!.validate();
                    if (isvalidForm) {
                        //
                       Money item = Money(
                         id: Random().nextInt(99999999),
                         title: NewTransactionsScreen.descriptionController.text,
                         price: NewTransactionsScreen.priceController.text,
                         date: NewTransactionsScreen.date,
                         isReceived:
                         NewTransactionsScreen.groupId == 1 ? true : false,
                       );
                       //
                       if (NewTransactionsScreen.isEditing) {
                         int index = 0;
                         Myapp.getDate();
                         for (int i = 0; i < hiveBox.values.length; i++) {
                           if (hiveBox.values.elementAt(i).id ==
                               NewTransactionsScreen.id) {
                             index = i;
                           }
                         }
                         hiveBox.putAt(index, item);
                       } else {
                         hiveBox.add(item);
                         //HomeScreen.moneys.add(item);
                       }
                       Navigator.pop(context);
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

}

class MyTextfield extends StatelessWidget {
  final String hintText;
  final TextInputType type;
  final TextEditingController controller;

  const MyTextfield(
      {Key? key,
      required this.hintText,
      this.type = TextInputType.text,
      required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'لطفا اطلاعات خواسته شده پر کنید !';
        } else {
          return null;
        }
      },
      controller: controller,
      keyboardType: type,
      cursorColor: Colors.grey,
      decoration: InputDecoration(
          hintText: hintText,
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          )),
    );
  }
}

class MyRadioButton extends StatelessWidget {
  final int value;
  final int groupValue;
  final Function(int?) onChanged;
  final String text;

  const MyRadioButton(
      {Key? key,
      required this.value,
      required this.groupValue,
      required this.onChanged,
      required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Radio(
          value: value,
          groupValue: groupValue,
          onChanged: onChanged,
          activeColor: kPurpleColor,
        ),
        Text(text),
      ],
    );
  }
}

class TypeAndDateWidget extends StatefulWidget {
  @override
  State<TypeAndDateWidget> createState() => _TypeAndDateWidgetState();
}

class _TypeAndDateWidgetState extends State<TypeAndDateWidget> {



  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        MyRadioButton(
            value: 1,
            groupValue: NewTransactionsScreen.groupId,
            onChanged: (value) {
              setState(() {
                NewTransactionsScreen.groupId = value!;
              });
            },
            text: "پرداختی"),
        MyRadioButton(
          value: 2,
          groupValue: NewTransactionsScreen.groupId,
          onChanged: (value) {
            setState(() {
              NewTransactionsScreen.groupId = value!;
            });
          },
          text: "دریافتی",
        ),
        TextButton(
            onPressed: () {},
            child: OutlinedButton(
              onPressed: () async {
                var pickedDate = await showPersianDatePicker(
                    context: context,
                    initialDate: Jalali.now(),
                    firstDate: Jalali(1401),
                    lastDate: Jalali(1500));
                if (pickedDate == null) return;
                setState(() {
                  String year = pickedDate!.year.toString();
                  String month = pickedDate.month.toString().length == 1
                      ? '0${pickedDate.month.toString()}'
                      : pickedDate.month.toString();
                  String day = pickedDate.day.toString().length == 1
                      ? '0${pickedDate.day.toString()}'
                      : pickedDate.day.toString();
                  NewTransactionsScreen.date = year + '/' + month + '/' + day;

                });
              },
              child: Text(
                NewTransactionsScreen.date,
                style: TextStyle(color: kPurpleColor),
              ),
            )),
      ],
    );
  }

}

class MyButton extends StatelessWidget {
  final String text;
  final Function() onPressed;

  const MyButton({Key? key, required this.text, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
          onPressed: onPressed,
          style:
              TextButton.styleFrom(backgroundColor: kPurpleColor, elevation: 0),
          child: Text(text)),
    );
  }
}
