// import 'dart:math';

import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
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
  final List<Expense> _registeredExpenses = [
    Expense(
      title: 'Flutter Course',
      amount: 19.99,
      date: DateTime.now(),
      category: Category.work,
    ),
    Expense(
      title: 'Cinema',
      amount: 15.69,
      date: DateTime.now(),
      category: Category.leisure,
    ),
  ];

  void _openAddExpenseOverlay() {
    // showModalBottomSheet(context: context, builder: (ctx) {}) == showModalBottomSheet(context: context, builder: (ctx) => )
    showModalBottomSheet(
      // เพื่อให้ Modal นี้ไม่ชนกับกล้องด้านบนของหน้าจอ
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(
        onAddExpense: _addExpense,
      ),
    );
  }

  // เพิ่มค่าใช้จ่าย
  void _addExpense(Expense expense) {
    setState(() {});
    _registeredExpenses.add(expense);
  }

  // ลบค่าใช้จ่าย
  void _removeExpense(Expense expense) {
    // Index
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });

    // ลบข้อมูลเก่าทันที โดยที่ไม่ต้องรอ snackbar 3 วิ
    ScaffoldMessenger.of(context).clearSnackBars();

    // ปุ่มเลิกทำ
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Expense deleted.'),
        action: SnackBarAction(
          label: 'Undo',
          //  กดปุ่ม Undo เพื่อนำรายการกลับมา
          onPressed: () {
            setState(
              () {
                _registeredExpenses.insert(expenseIndex, expense);
              },
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // check width and height screen of my device
    // print(MediaQuery.of(context).size.width);
    // print(MediaQuery.of(context).size.height);

    final width = MediaQuery.of(context).size.width;

    Widget mainContent = const Center(
      child: Text('No expense found!, start adding some'),
    );

    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredExpenses,
        onRemoveExpense: _removeExpense,
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Flutter ExpenseTracker'),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      // ถ้าความกว้าง < 600 คือแนวตั้ง แต่ถ้าไม่จริงคือแนวนอน
      body: width < 600
          ? Column(
              children: [
                // Toolbar with the Ad button => Row()
                Chart(expenses: _registeredExpenses),
                Expanded(child: mainContent),
              ],
            )
          : Row(
              children: [
                // Toolbar with the Ad button => Row()
                Expanded(
                  child: Chart(expenses: _registeredExpenses),
                ),
                Expanded(child: mainContent),
              ],
            ),
    );
  }
}
