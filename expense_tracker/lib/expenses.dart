import 'package:flutter/material.dart';

// Widget stateful ต้องมี 2 class เสมอ คือ Expenses และ _ExpensesState
class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    // ต้องมีการส่งคืนค่า Instance ใหม่ของ State _ExpensesState ที่เราสร้างขึ้น
    return _ExpensesState();
  }
}

// State<Expenses> State เชื่อมต่อกับ Expenses
class _ExpensesState extends State<Expenses> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          Text('The chart'),
          Text('Expense List...'),
        ],
      ),
    );
  }
}
