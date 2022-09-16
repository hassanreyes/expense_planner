import 'dart:io';
// ignore_for_file: prefer_const_constructors, deprecated_member_use
import 'package:expense_planner/widgets/chart.dart';
import 'package:expense_planner/widgets/new_transaction.dart';
import 'package:expense_planner/widgets/transaction_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.amberAccent,
        fontFamily: "OpenSans",
        textTheme: ThemeData.light().textTheme.copyWith(
            headline1: TextStyle(fontFamily: 'OpenSans', fontWeight: FontWeight.w600, fontSize: 18),
            headline2: TextStyle(fontFamily: 'OpenSans', fontWeight: FontWeight.w600, fontSize: 14),
            button: TextStyle(color: Colors.white)),
        appBarTheme: AppBarTheme(
            textTheme:
                ThemeData.light().textTheme.copyWith(headline1: TextStyle(fontFamily: 'OpenSans', fontSize: 20))),
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final List<Transaction> _transactions = [
    Transaction(id: 't1', title: 'New Shoses', amount: 99.99, date: DateTime.now()),
    Transaction(id: 't2', title: 'Pencil', amount: 12.81, date: DateTime.now()),
  ];

  bool _showChart = true;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print(state);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _deleteTransaction(String id) {
    setState(() {
      _transactions.removeWhere((element) => element.id == id);
    });
  }

  void _addNewTransaction(String title, double amount, DateTime date) {
    final newTx = Transaction(id: DateTime.now().toString(), title: title, amount: amount, date: date);

    setState(() {
      _transactions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            child: NewTransaction(addTxHandler: _addNewTransaction),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  List<Transaction> get _recentTransactions {
    return _transactions.where((element) => element.date.isAfter(DateTime.now().subtract(Duration(days: 7)))).toList();
  }

  List<Widget> _buildLandscapeContent(
      MediaQueryData mediaQuery, ObstructingPreferredSizeWidget appBar, Widget txListWidget) {
    return [
      Row(
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            Text(
              'Show Chart',
              style: Theme.of(context).textTheme.caption,
            ),
            Switch.adaptive(
                activeColor: Theme.of(context).accentColor,
                value: _showChart,
                onChanged: (val) => setState(() {
                      _showChart = val;
                    })),
          ]),
      _showChart
          ? Container(
              height: (mediaQuery.size.height - appBar.preferredSize.height) * 0.25,
              child: Chart(recentTransactions: _recentTransactions))
          : txListWidget
    ];
  }

  List<Widget> _buildPortraitContent(
      MediaQueryData mediaQuery, ObstructingPreferredSizeWidget appBar, Widget txListWidget) {
    return [
      Container(
          height: (mediaQuery.size.height - appBar.preferredSize.height) * 0.3,
          child: Chart(recentTransactions: _recentTransactions)),
      txListWidget
    ];
  }

  Widget _buildCupertinoNavBar() {
    return CupertinoNavigationBar(
      middle: Text('Personal Expenses'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            child: Icon(CupertinoIcons.add),
            onTap: () => _startAddNewTransaction(context),
          )
        ],
      ),
    );
  }

  Widget _buildMaterialNavBar() {
    return AppBar(
      title: Text(widget.title),
      actions: [IconButton(onPressed: () => _startAddNewTransaction(context), icon: Icon(Icons.add))],
    );
  }

  @override
  Widget build(BuildContext context) {
    print('Build from main');
    final mediaQuery = MediaQuery.of(context);
    final isLanscape = mediaQuery.orientation == Orientation.landscape;
    final appBar = Platform.isIOS ? _buildCupertinoNavBar() : _buildMaterialNavBar();

    final txListWidget = Container(
      height: (mediaQuery.size.height - (appBar as ObstructingPreferredSizeWidget).preferredSize.height) * 0.75,
      child: TransactionList(transactions: _transactions, deleteTx: _deleteTransaction),
    );

    final body = SafeArea(
        child: SingleChildScrollView(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        if (isLanscape) ..._buildLandscapeContent(mediaQuery, appBar, txListWidget),
        if (!isLanscape) ..._buildPortraitContent(mediaQuery, appBar, txListWidget),
      ],
    )));

    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: appBar,
            child: body,
          )
        : Scaffold(
            appBar: appBar,
            body: body,
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
