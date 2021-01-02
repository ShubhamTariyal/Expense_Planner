import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils/toast.dart';
import 'adaptiveButton.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;

  NewTransaction(this.addTx);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate;
  final FocusNode amountNode = FocusNode();

  void _submitdata() {
    final String title = _titleController.text;
    final double amount = double.tryParse(_amountController.text);

    if (widget.addTx(title, amount, _selectedDate)) {
      Navigator.of(context).pop();
    } else {
      toast('Fill data properly!');
    }
  }

  void _datePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate != null)
        setState(() {
          _selectedDate = pickedDate;
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        padding: EdgeInsets.fromLTRB(
            10, 10, 10, MediaQuery.of(context).viewInsets.bottom + 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              autofocus: true,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                hintText: "transaction title",
                helperText: 'helper text',
                labelText: "Title",
              ),
              controller: _titleController,
              onSubmitted: (_) =>
                  FocusScope.of(context).requestFocus(amountNode),
            ),
            TextField(
              focusNode: amountNode,
              decoration: InputDecoration(
                labelText: "Amount",
                prefixText: "\u{20B9}",
              ),
              keyboardType: TextInputType.number,
              controller: _amountController,
              onSubmitted: (_) => _submitdata(),
            ),
            Container(
              height: 70,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedDate == null
                          ? 'No Date Choosen'
                          : "Date: ${DateFormat.yMMMd().format(_selectedDate)}",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  AdaptiveButton('Choose Date', _datePicker),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RaisedButton(
                  child: Text('Cancel'),
                  color: Theme.of(context).primaryColor,
                  textColor: Theme.of(context).textTheme.button.color,
                  onPressed: () => Navigator.pop(context),
                ),
                RaisedButton(
                  child: Text('Add Transaction'),
                  color: Theme.of(context).primaryColor,
                  textColor: Theme.of(context).textTheme.button.color,
                  onPressed: _submitdata,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
