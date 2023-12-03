// import 'package:flutter/foundation.dart';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  // "?" -> optional คืออาจจะมีค่า หรือไม่มีค่าในตัวแปรก็ได้
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;

  void _presentDatePicker() async {
    final now = DateTime.now();
    final fisrtDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: fisrtDate,
      lastDate: now,
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _showDialog() {
    if (Platform.isIOS) {
      showCupertinoDialog(
          context: context,
          builder: (ctx) => CupertinoAlertDialog(
                title: const Text('Invalid input'),
                content: const Text(
                    'Please make sure a valid title, amount, date and category was entered.'),
                // actions อย่าง ผู้ใช้กด Okay ออกจาก Alert
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                    },
                    child: const Text('Okay'),
                  ),
                ],
              ));
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid input'),
          content: const Text(
              'Please make sure a valid title, amount, date and category was entered.'),
          // actions อย่าง ผู้ใช้กด Okay ออกจาก Alert
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );
    }
  }

  void _submitExpenseData() {
    // tryParse('Hello') -> null, tryParse('1.12') -> 1.12
    // แปลง ตัวเลขที่เป็น String ให้เป็น double
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;

    // if (ถ้าไม่ได้กรอกข้อมูล || amount ไม่ได้กรอกเข้ามา,ไม่ได้กรอกตัวเลขแต่กรอก alphabet, มา น้อยกว่าหรือเท่ากับ 0 || ไม่ได้เลือกวันที่)
    // _titleController.text.trim().isEmpty -> .text = ดึงข้อความจากคอนโทรลเลอร์, .text = ลบช่องว่างที่อยู่ด้านหน้าหรือด้านหลังของข้อความ, .isEmpty = ข้อความที่ได้ว่างเปล่าหรือไม่
    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      _showDialog();
      return;
    }

    widget.onAddExpense(
      Expense(
          title: _titleController.text,
          amount: enteredAmount,
          date: _selectedDate!,
          category: _selectedCategory),
    );
    Navigator.pop(context);
  }

  @override
  void dispose() {
    // ขั้นตอนการกำจัด input text ของเรา เมื่อเราพิมพ์เข้ามา จะได้ไม่ทำให้เพิ่ม memory เก็บค่าที่เราพิมพ์เข้ามาทุกครั้ง
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  // ตัวแปรที่เก็บค่า text ว่างเปล่า
  // var _enteredTitle = '';

  // void _saveTitleInput(String inputValue) {
  //   _enteredTitle = inputValue;
  // }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(builder: (ctx, constraints) {
      final width = constraints.maxWidth;
      return SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            // EdgeInsets.fromLTRB(16, 48, 16, 16) ยิ่งเลขเยอะยิ่งห่าง
            padding: EdgeInsets.fromLTRB(16, 48, 16, keyboardSpace + 16),
            child: Column(
              children: [
                // width >= 600 คือแนวนอน
                if (width >= 600)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Row 1
                      // title
                      Expanded(
                        child: TextField(
                          // onChanged: _saveTitleInput,
                          controller: _titleController,
                          maxLength: 50,
                          decoration: const InputDecoration(
                            label: Text('Title'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      // Row 2
                      // amount
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            prefixText: '\$ ',
                            label: Text('Amount'),
                          ),
                        ),
                      ),
                    ],
                  )
                // แนวตั้ง
                else
                  // column 1
                  // title
                  TextField(
                    // onChanged: _saveTitleInput,
                    controller: _titleController,
                    maxLength: 50,
                    decoration: const InputDecoration(
                      label: Text('Title'),
                    ),
                  ),

                // width >= 600 คือแนวนอน
                if (width >= 600)
                  Row(
                    children: [
                      // Column 2 Row 1
                      DropdownButton(
                        value: _selectedCategory,
                        items: Category.values
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(
                                  e.name.toUpperCase(),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }
                          setState(
                            () {
                              _selectedCategory = value;
                            },
                          );
                        },
                      ),
                      const SizedBox(width: 24),
                      // Column 2 Row 2
                      Expanded(
                        child: Row(
                          // ผลักไปทางขวาสุด
                          mainAxisAlignment: MainAxisAlignment.end,
                          // ตรงกลางใน row
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // "!" -> เป็นการบอกบังคับว่า _selectedDate จะไม่เป็นค่าว่าง
                            Text(
                              _selectedDate == null
                                  ? 'No date selected'
                                  : formatter.format(_selectedDate!),
                            ),
                            IconButton(
                              onPressed: _presentDatePicker,
                              icon: const Icon(Icons.calendar_month),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                // แนวตั้ง
                else
                  // column 2
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            prefixText: '\$ ',
                            label: Text('Amount'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Row(
                          // ผลักไปทางขวาสุด
                          mainAxisAlignment: MainAxisAlignment.end,
                          // ตรงกลางใน row
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // "!" -> เป็นการบอกบังคับว่า _selectedDate จะไม่เป็นค่าว่าง
                            Text(
                              _selectedDate == null
                                  ? 'No date selected'
                                  : formatter.format(_selectedDate!),
                            ),
                            IconButton(
                              onPressed: _presentDatePicker,
                              icon: const Icon(Icons.calendar_month),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 16),

                // width >= 600 คือแนวนอน
                if (width >= 600)
                  Row(
                    children: [
                      // Column 3 Row 1
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancle'),
                      ),
                      ElevatedButton(
                        onPressed: _submitExpenseData,
                        child: const Text('Save expense'),
                      ),
                    ],
                  )
                // แนวตั้ง
                else
                  // column 3
                  Row(
                    children: [
                      DropdownButton(
                        value: _selectedCategory,
                        items: Category.values
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(
                                  e.name.toUpperCase(),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }
                          setState(
                            () {
                              _selectedCategory = value;
                            },
                          );
                        },
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancle'),
                      ),
                      ElevatedButton(
                        onPressed: _submitExpenseData,
                        child: const Text('Save expense'),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
