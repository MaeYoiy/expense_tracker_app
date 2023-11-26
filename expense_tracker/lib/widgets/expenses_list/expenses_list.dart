import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_item.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList({super.key, required this.expenses});

  final List<Expense> expenses;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: expenses.length,
        // function itemBuilder จะถูกเรียกตามจำนวน itemCount
        // => คือ return ทันที
        itemBuilder: (ctx, index) => ExpensesItem(expenses[index]));
  }
}
