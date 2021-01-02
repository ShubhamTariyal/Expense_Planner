import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Widgets/chart_bar.dart';
import '../models/transaction.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  List<Map<String, Object>> get groupedTranscation {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      var totalSum = 0.0;
      for (var i = 0; i < recentTransactions.length; ++i) {
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.day == weekDay.day) {
          totalSum += recentTransactions[i].amount;
        }
      }

      return {
        'day': DateFormat.E().format(weekDay),
        'amount': totalSum,
      };
    });
  }

  double get totalSpending {
    return groupedTranscation.fold(0.0, (sum, ele) {
      return sum + ele['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    print(groupedTranscation);
    return Card(
      // color: Colors.white,
      elevation: 6,
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTranscation.map((data) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                data['day'],
                data['amount'],
                totalSpending == 0
                    ? 0.0
                    : (data['amount'] as double) / totalSpending,
              ),
            );
          }).toList().reversed.toList(),
        ),
      ),
    );
  }
}
