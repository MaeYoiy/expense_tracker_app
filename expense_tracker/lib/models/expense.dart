import 'package:uuid/uuid.dart';

const uuid = Uuid();

// enum = เป็น keyword ที่ช่วยให้เราสร้างประเภทที่กำหนดเองได้
enum Category { food, travel, leisure, work }

// แบบจำลองหรือพิมพ์เขียวสำหรับ Data
class Expense {
  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  }) : id = uuid.v4();

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;
}
