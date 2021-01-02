import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils/alertDialog.dart';
import '../models/transaction.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({
    Key key,
    @required this.transaction,
    @required this.deleteTx,
    @required this.index,
  }) : super(key: key);

  final Transaction transaction;
  final Function deleteTx;
  final int index;

  @override
  Widget build(BuildContext context) {
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
  }
}