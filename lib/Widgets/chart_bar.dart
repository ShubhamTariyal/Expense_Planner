import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final double spendAmount;
  final double spendTotalPrcnt;

  ChartBar(this.label, this.spendAmount, this.spendTotalPrcnt);

  @override
  Widget build(BuildContext context) {
    print('==========${MediaQuery.of(context).size.width}XXXXXXXXXXXXXXXXXX');
    print('==========${MediaQuery.of(context).size.height}XXXXXXXXXXXXXXXXX');
    return LayoutBuilder(builder: (ctx, constraints) {
      final height = constraints.maxHeight;
      return Column(
        children: [
          Container(
            height: height * 0.15,
            child: FittedBox(
              child: Text('\u{20B9}${spendAmount.toStringAsFixed(0)}'),
            ),
          ),
          Container(
            height: height * 0.6,
            width: 15, //dimension.width * 0.04,
            margin: EdgeInsets.symmetric(vertical: height * 0.05),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                    color: Color.fromRGBO(220, 220, 220, 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                FractionallySizedBox(
                  heightFactor: spendTotalPrcnt,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.blueAccent,
                        width: 1.0,
                      ),
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: height * 0.15,
            child: Text(MediaQuery.of(context).size.width > 400
                ? '$label'
                : '${label[0]}', style: TextStyle(fontSize: 17,),),
          ),
        ],
      );
    });
  }
}
