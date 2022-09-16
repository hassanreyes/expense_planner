import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final double spendingAmount;
  final double spendingPctOfTotal;

  const ChartBar({Key? key, required this.label, required this.spendingAmount, required this.spendingPctOfTotal})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Build from chart bar');
    return LayoutBuilder(
        builder: ((context, constraints) => Column(
              children: [
                Container(
                    height: constraints.maxHeight * 0.15,
                    child: FittedBox(child: Text('\$${spendingAmount.toStringAsFixed(0)}'))),
                SizedBox(
                  height: constraints.maxHeight * 0.05,
                ),
                Container(
                  height: constraints.maxHeight * 0.6,
                  width: 10,
                  child: SizedBox(
                    height: 4,
                    child: Stack(children: [
                      Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1.0),
                              color: const Color.fromRGBO(220, 220, 220, 1),
                              borderRadius: BorderRadius.circular(10))),
                      FractionallySizedBox(
                        heightFactor: spendingPctOfTotal,
                        widthFactor: 1,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ]),
                  ),
                ),
                SizedBox(
                  height: constraints.maxHeight * 0.05,
                ),
                Container(height: constraints.maxHeight * 0.15, child: FittedBox(child: Text(label)))
              ],
            )));
  }
}
