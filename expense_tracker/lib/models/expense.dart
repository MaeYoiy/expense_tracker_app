import 'package:uuid/uuid.dart';

const uuid = Uuid();

// แบบจำลองหรือพิมพ์เขียวสำหรับ Data
class Expense {
  Expense({
    required this.title,
    required this.amount,
    required this.date,
  }) : id = uuid.v4();

  final String id;
  final String title;
  final double amount;
  final DateTime date;
}
