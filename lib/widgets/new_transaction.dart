import 'dart:ffi';
import 'dart:io';

import 'package:expense_planner/widgets/adaptive_flat_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function? addTxHandler;

  const NewTransaction({Key? key, required this.addTxHandler})
      : super(key: key);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  var _titleController = TextEditingController();
  var _amountController = TextEditingController();
  var _date = DateTime.now();

  void _SubmitData() {
    if (_amountController.text.isEmpty) {
      return;
    }
    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0 || _date == null) {
      return;
    }

    widget.addTxHandler!(enteredTitle, enteredAmount, _date);

    Navigator.of(context).pop();
  }

  void _presentDatePiker() {
    showDatePicker(
            context: context,
            initialDate: _date == null ? DateTime.now() : _date,
            firstDate: DateTime(2000, 1, 1),
            lastDate: DateTime.now())
        .then((value) {
      if (value != null) {
        setState(() {
          _date = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context);
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
            padding: EdgeInsets.only(
                top: 10,
                left: 10,
                right: 10,
                bottom: mediaQuery.viewInsets.bottom + 10),
            // ignore: prefer_const_literals_to_create_immutables
            child: Column(crossAxisAlignment: CrossAxisAlignment.end,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(labelText: 'Enter Title'),
                    onSubmitted: (_) => _SubmitData(),
                  ),
                  TextField(
                    controller: _amountController,
                    decoration: InputDecoration(labelText: 'Amount'),
                    keyboardType: TextInputType.number,
                    onSubmitted: (_) => _SubmitData(),
                  ),
                  Container(
                    height: 70,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(_date == null
                              ? 'No Date Chosen'
                              : DateFormat.yMd().format(_date)),
                        ),
                        AdaptiveFlatButton(
                            text: 'Chose Date', handler: _presentDatePiker)
                      ],
                    ),
                  ),
                  RaisedButton(
                    child: Text('Add Transaction'),
                    color: theme.primaryColor,
                    textColor: theme.textTheme.button?.color,
                    onPressed: _SubmitData,
                  )
                ])),
      ),
    );
  }
}
