import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_item.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList(
      {super.key, required this.expenses, required this.onRemoveExpense});

  final List<Expense> expenses;
  final void Function(Expense expense) onRemoveExpense;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenses.length,
      // function itemBuilder จะถูกเรียกตามจำนวน itemCount
      // => คือ return ทันที
      // Dismissible() คือการปัดหน้าเพื่อลบข้อมูล ณ ที่ Index ของ Expense
      itemBuilder: (ctx, index) => Dismissible(
        key: ValueKey(
          ExpensesItem(expenses[index]),
        ),
        // direction = ปัดหน้าจอโดยไม่สนทิศทาง
        onDismissed: (direction) {
          onRemoveExpense(expenses[index]);
        },
        child: ExpensesItem(
          expenses[index],
        ),
      ),
    );
  }
}
