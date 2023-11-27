import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

const uuid = Uuid();

const categoryIcon = {
  Category.food: Icons.lunch_dining,
  Category.travel: Icons.flight_takeoff,
  Category.leisure: Icons.movie,
  Category.work: Icons.work,
};

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

  String get formattedDate {
    return formatter.format(date);
  }
}

class ExpenseBucket {
  const ExpenseBucket({
    required this.category,
    required this.expenses,
  });

  //เราต้องการที่จะ filter category ให้เป็นหมวดหมู่เดียวกัน เอาไว้ใช้ในแท่กราฟ
  /// The `ExpenseBucket.forCategory` constructor is used to create an `ExpenseBucket` object for a
  /// specific category. It takes in a list of all expenses (`allExpenses`) and a category
  /// (`this.category`) as parameters.
  ExpenseBucket.forCategory(List<Expense> allExpenses, this.category)
      : expenses = allExpenses
            .where((expense) => expense.category == category)
            .toList();

  final Category category;
  final List<Expense> expenses;

  // Function สำหรับการรวมค่าใช้จ่าย
  double get totalExpenses {
    double sum = 0;

    for (final expense in expenses) {
      sum += expense.amount;
    }

    return sum;
  }
}
