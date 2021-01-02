import 'package:expense_planner/utils/alertDialog.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final Function deleteTx;

  TransactionList(this.deleteTx);

  @override
  Widget build(BuildContext context) {
    final transactionsBox = Hive.box('transactions');
    final border = transactionsBox.length > 0
        ? Border.all(
            color: Color.fromRGBO(200, 200, 200, 0.5),
            width: 2,
          )
        : null;
    return Container(
      decoration: BoxDecoration(
        border: border,
      ),
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: transactionsBox.length == 0
          ? LayoutBuilder(
              builder: (ctx, constraints) {
                print('=======No element to Print ==========');
                return Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'No transactions added yet!',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    height: constraints.maxHeight * 0.75,
                    child: Image.asset(
                      'assets/images/waiting.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              );}
            )
          : ListView.builder(
              itemCount: transactionsBox.length,
              itemBuilder: (cntxt, index) {
                final transaction = transactionsBox.getAt(index) as Transaction;
                print('=======Printing element $index==========');
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 5,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: Padding(
                        padding: EdgeInsets.all(3),
                        child: FittedBox(
                          child: Text(
                            '\u{20B9}${transaction.amount}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      '${transaction.title}',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    subtitle: Text(
                      '${DateFormat.yMMMd().format(transaction.date)}',
                    ),
                    trailing: MediaQuery.of(context).size.width > 300
                        ? FlatButton.icon(
                            label: Text(
                              'Delete',
                              // style: Theme.of(context).textTheme.headline6,
                            ),
                            icon: Icon(Icons.delete),
                            textColor: Theme.of(context).errorColor,
                            onPressed: () => showAlertDialog(
                              context: context,
                              content: 'Delete Item: ${transaction.title}?',
                              buttonList: [
                                FlatButton(
                                  onPressed: () {
                                    deleteTx(index);
                                    Navigator.pop(context);
                                  },
                                  child: Text('Delete'),
                                )
                              ],
                            ),
                          )
                        : IconButton(
                            icon: Icon(Icons.delete),
                            color: Theme.of(context).errorColor,
                            onPressed: () => showAlertDialog(
                              context: context,
                              content: 'Delete Item: ${transaction.title}?',
                              buttonList: [
                                FlatButton(
                                  onPressed: () {
                                    deleteTx(transaction.id);
                                    Navigator.pop(context);
                                  },
                                  child: Text('Delete'),
                                )
                              ],
                            ),
                          ),
                    onTap: () {},
                  ),
                );
              },
            ),
    );
  }
}
