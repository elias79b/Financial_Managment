import 'package:hive/hive.dart';


part 'money.g.dart';

@HiveType(typeId: 0)
class Money{
  @HiveField(1)
  int id;
  @HiveField(2)
  String title;
  @HiveField(3)
  String price;
  @HiveField(4)
  String date;
  @HiveField(5)
  bool isReceived;

  Money({
 required this.id,
 required this.title,
 required this.price,
 required this.date,
 required this.isReceived
});}