import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../models/transaction.dart';
import 'transaction_list_Item.dart';

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
          ? LayoutBuilder(builder: (ctx, constraints) {
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
              );
            })
          : ListView.builder(
              itemCount: transactionsBox.length,
              itemBuilder: (cntxt, index) {
                final transaction = transactionsBox.getAt(index) as Transaction;
                print('=======Printing element $index==========');
                return TransactionItem(
                    transaction: transaction, deleteTx: deleteTx, index: index);
              },
            ),
    );
  }
}
