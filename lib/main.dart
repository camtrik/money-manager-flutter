import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_manager/screens/tx_screen.dart';
import 'package:money_manager/view_models/category_list_model.dart';
import 'package:provider/provider.dart';
import 'package:money_manager/services/storage_service.dart';
import 'package:money_manager/view_models/tx_list_model.dart';
import 'package:money_manager/screens/category_screen.dart';

void main() async {
  // await Hive.deleteBoxFromDisk('categories');

  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init(); // 初始化 Hive 本地存储
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;

  // 底部导航对应的页面列表
  static const List<Widget> _pages = <Widget>[
    CategoryScreen(),
    TransactionScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CategoryListModel()),
        ChangeNotifierProvider(create: (_) => TxListModel()),
      ],
      child: MaterialApp(
        title: '记账应用',
        home: Scaffold(
          body: _pages[_currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.pie_chart),
                label: '类别',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list),
                label: '交易',
              ),
            ],
            onTap: (int index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
