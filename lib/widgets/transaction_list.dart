import 'package:expense_planner/widgets/transaction_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTx;

  const TransactionList({
    super.key,
    required this.transactions,
    required this.deleteTx,
  });

  @override
  Widget build(BuildContext context) {
    print('Build from tx list');
    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context);
    return transactions.isEmpty
        ? LayoutBuilder(builder: ((context, constraints) {
            return Column(
              children: [
                const Text('No transactions added yet!'),
                const SizedBox(
                  height: 20,
                ),
                Container(
                    height: constraints.maxHeight * 0.6,
                    child: Image.asset('assets/images/waiting.png', fit: BoxFit.cover))
              ],
            );
          }))
        : ListView(
            children: transactions
                .map((tx) => TransactionItem(
                    key: ValueKey(tx.id), transaction: tx, theme: theme, mediaQuery: mediaQuery, deleteTx: deleteTx))
                .toList(),
          );
  }
}
