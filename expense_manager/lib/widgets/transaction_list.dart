import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../widgets/transaction_item.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTx;

  TransactionList(this.transactions, this.deleteTx);

  @override
  Widget build(BuildContext context) {
    print('build() TransactionList');

    return transactions.isEmpty ? 
    LayoutBuilder(builder: (ctx, constraints) {
      return Column(
        children: <Widget>[
          Text(
            'No transactions added yet!',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: constraints.maxHeight * 0.6,
            child: Image.asset(
              'assets/images/waiting.png',
              fit:BoxFit.cover,
            ),
          ),
        ],
      );
    })
    :
    ListView(
      children: transactions.map((tx) => TransactionItem(
        key: ValueKey(tx.id),
        transaction : tx,
        deleteTx: deleteTx,
      )).toList(),
    );
  }
}