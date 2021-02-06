import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

import '../Widgets/new_transaction.dart';
import '../Widgets/transaction_list.dart';
import '../Widgets/chart.dart';
import '../models/transaction.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    final transactions = Hive.box('transactions');
    List<Transaction> recentTxn = [];
    for (int i = 0; i < transactions.length; ++i) {
      final txn = transactions.getAt(i) as Transaction;
      if (txn.date.isAfter(DateTime.now().subtract(Duration(days: 7))))
        recentTxn.add(txn);
    }
    return recentTxn;
  }

  bool _addTransaction(String title, double amount, DateTime date) {
    if (title.isEmpty || amount == null || amount <= 0 || date == null) {
      print('================returned False=============');
      return false;
    } else {
      setState(() {
        Hive.box('transactions').add(
          Transaction(
            amount: amount,
            id: DateTime.now().toString(),
            title: title,
            date: date,
          ),
        );
      });
      print(
          '================Length: ${Hive.box('transactions').length}=============');
    }
    print('================returned True=============');
    return true;
  }

  void _startAddNewTransaction(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return NewTransaction(_addTransaction);
      },
    );
  }

  void _deleteTransaction(int index) {
    setState(() {
      Hive.box('transactions').deleteAt(index);
    });
    print(
        '================Length: ${Hive.box('transactions').length}=============');
  }

  // TODO: Implement Edit Transaction Option
  // void _editTransacion(int index, String title, double amount, DateTime date) {
  //   setState(() {
  //     Hive.box('transactions').putAt(
  //       index,
  //       Transaction(
  //         amount: amount,
  //         id: DateTime.now().toString(),
  //         title: title,
  //         date: date,
  //       ),
  //     );
  //   });
  // }

  List<Widget> _buildLandscapeContent(MediaQueryData screen,
      PreferredSizeWidget appBar, BuildContext context, Widget txListWidget) {
    return [
      Container(
        height: (screen.size.height -
                appBar.preferredSize.height -
                screen.padding.top) *
            0.1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Show Chart',
              style: Theme.of(context).textTheme.headline6,
            ),
            //Switch.adaptive adapts the switch as per android or IOS
            Switch.adaptive(
                value: _showChart,
                onChanged: (val) {
                  setState(() {
                    _showChart = val;
                  });
                })
          ],
        ),
      ),
      _showChart
          ? Container(
              height: (screen.size.height -
                      appBar.preferredSize.height -
                      screen.padding.top) *
                  0.75,
              child: Chart(_recentTransactions),
            )
          : txListWidget
    ];
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context);
    final isIOS = Platform.isIOS;
    final isLandscape = screen.orientation == Orientation.landscape;
    final PreferredSizeWidget appBar = isIOS
        ? CupertinoNavigationBar(
            middle: Text(
              'Expense Planner',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  child: Icon(CupertinoIcons.add),
                  onTap: () => _startAddNewTransaction(context),
                )
              ],
            ),
          )
        : AppBar(
            title: Text(
              'Expense Planner',
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => _startAddNewTransaction(context),
              ),
            ],
          );
    final txList = Container(
      height: (screen.size.height -
              appBar.preferredSize.height -
              screen.padding.top) *
          0.7,
      child: TransactionList(_deleteTransaction),
    );
    //SafeArea adjusts child respecting area taken by notch, appdrawaer icon
    // or other Widgets that are not part of our App. Without it App bar
    //would be hidden by deivce notch(if there)
    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          //Weekly Expense measure bar container
          children: [
            if (!isLandscape) ..._buildPortraitContent(screen, appBar, txList),
            if (isLandscape)
              ..._buildLandscapeContent(screen, appBar, context, txList),
          ],
        ),
      ),
    );

    return isIOS
        ? CupertinoPageScaffold(navigationBar: appBar, child: null)
        : Scaffold(
            appBar: appBar,
            //App layout
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            //Checking for OS
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _startAddNewTransaction(context),
                  ),
          );
  }

  List<Widget> _buildPortraitContent(
      MediaQueryData screen, PreferredSizeWidget appBar, Widget txListWidget) {
    return [
      Container(
        height: (screen.size.height -
                appBar.preferredSize.height -
                screen.padding.top) *
            0.3,
        child: Chart(_recentTransactions),
      ),
      txListWidget
    ];
  }

  @override
  void dispose() {
    Hive.box('transactions')
        .compact(); //to compact transactions Box(optional as Hive can do it automatically)
    Hive.box('transactions').close(); //or Hive.close() to close all boxes
    super.dispose();
  }
}
