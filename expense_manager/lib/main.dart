import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:expense_manager/models/transaction.dart';
import 'package:expense_manager/widgets/chart.dart';
import 'package:expense_manager/widgets/new_transaction.dart';
import './widgets/transaction_list.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static const typeTheme = Typography.whiteMountainView;

  TextTheme textTheme = Typography.whiteMountainView.
  copyWith(
    bodyText1: typeTheme.bodyText1?.copyWith(fontSize: 16),
    bodyText2: typeTheme.bodyText2?.copyWith(fontSize: 14),
    headline1: typeTheme.headline1?.copyWith(fontSize: 32),
    headline2: typeTheme.headline2?.copyWith(fontSize: 28),
    headline3: typeTheme.headline3?.copyWith(fontSize: 24),
    headline4: typeTheme.headline4?.copyWith(fontSize: 21),
    headline5: typeTheme.headline5?.copyWith(fontSize: 18),
    headline6: typeTheme.headline6?.copyWith(fontSize: 16),
    subtitle1: typeTheme.subtitle1?.copyWith(fontSize: 24),
    subtitle2: typeTheme.subtitle2?.copyWith(fontSize: 21),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Manager',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        fontFamily: 'Quicksand',
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
            titleMedium: const TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with 
WidgetsBindingObserver {
  final List<Transaction> _userTransactions = [

  ];
  bool _showChart = false;

  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransaction(String txTitle, double txAmount,
  DateTime choosenDate) {
    final newTx = Transaction(
     id: DateTime.now().toString(),
     title: txTitle,
     amount: txAmount, 
     date: choosenDate,
     );

     setState(() {
       _userTransactions.add(newTx);
     });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewTransaction(_addNewTransaction),
          behavior: HitTestBehavior.opaque,
          );
      },
      );
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  List<Widget> _buildLandscapeContent(
    MediaQueryData mediaQuery,
    AppBar appBar,
    Widget txListWidget,
  ) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Show Chart',
          style: Theme.of(context).textTheme.titleMedium,
          ),
          Switch.adaptive(
            activeColor: Theme.of(context).accentColor,
            value: _showChart, 
            onChanged: (val) {
              setState(() {
                _showChart = val;
              });
            },
            ),
        ],
      ),
      _showChart
      ? Container(
        height: (mediaQuery.size.height - 
        appBar.preferredSize.height - 
        mediaQuery.padding.top) * 0.7,
        child: Chart(_recentTransactions),
      )
      : txListWidget
    ];
  }

  List<Widget> _buildPortraitContent(
    MediaQueryData mediaQuery,
    AppBar appBar,
    Widget txListWidget,
  ) {
    return [
      Container(
        height: (mediaQuery.size.height - 
        appBar.preferredSize.height - 
        mediaQuery.padding.top) * 0.3,
        child: Chart(_recentTransactions),
      ),
      txListWidget
    ];
  }

  Widget _buildAppBar() {
    return Platform.isIOS
    ? CupertinoNavigationBar(
      middle: Text('Expense Manager',),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          GestureDetector(
            child: Icon(CupertinoIcons.add),
            onTap: () => _startAddNewTransaction(context),
          ),
        ],
      ),
    )
    : AppBar(
      title: Text('Expense Manager',),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => _startAddNewTransaction(context),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    print('build() MyHomePageState');
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == 
    Orientation.landscape;
    final dynamic appBar = _buildAppBar();

    final txListWidget = Container(
      height: (mediaQuery.size.height - 
      appBar.preferredSize.height - 
      mediaQuery.padding.top) * 0.7,
      child: TransactionList(_userTransactions,_deleteTransaction),
    );

    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (isLandscape)
            ..._buildLandscapeContent(mediaQuery,
             appBar, 
             txListWidget,
             ),
             if(!isLandscape)
             ..._buildLandscapeContent(mediaQuery,
              appBar,
              txListWidget,
              ),
          ],
        ),
    ),
    );
    return Platform.isIOS
    ? CupertinoPageScaffold(
      child: pageBody,
      navigationBar: appBar,
      )
      : Scaffold(
        appBar: appBar,
        body: pageBody,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Platform.isIOS
        ? Container()
        : FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => _startAddNewTransaction(context),
        ),
      );
  }
}
