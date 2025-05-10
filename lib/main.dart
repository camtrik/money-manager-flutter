import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_manager/l10n/gen/app_localizations.dart';
import 'package:money_manager/screens/settings_screen.dart';
import 'package:money_manager/screens/tx_screen.dart';
import 'package:money_manager/view_models/category_list_model.dart';
import 'package:money_manager/view_models/settings_provider.dart';
import 'package:provider/provider.dart';
import 'package:money_manager/services/storage_service.dart';
import 'package:money_manager/view_models/tx_list_model.dart';
import 'package:money_manager/screens/category_screen.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = Locale('en');

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }
}

void main() async {
  // await Hive.deleteBoxFromDisk('categories');

  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init(); // 初始化 Hive 本地存储
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider())
      ],
      child: const MyApp(),
    )
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;

  // bottom navigation bar pages 
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
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, SettingsProvider, _) {
          return MaterialApp(
            locale: SettingsProvider.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate, 
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate, 
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
              Locale('zh'),
              Locale('jp'),
            ],
            title: 'Money Manager',
            home: Builder(
              builder: (context) {
                final l10n = AppLocalizations.of(context)!; 
                return Scaffold(
                  appBar: AppBar(
                    // title: Text(l10n.appTitle), 
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.settings),
                        onPressed: () {
                          Navigator.push(
                            context, 
                            MaterialPageRoute(builder: (context) => const SettingsScreen())
                          );
                        }
                      )
                    ]
                  ),

                  body: _pages[_currentIndex],
                  bottomNavigationBar: BottomNavigationBar(
                    currentIndex: _currentIndex,
                    items: <BottomNavigationBarItem> [
                      BottomNavigationBarItem(
                        icon: const Icon(Icons.pie_chart),
                        label: l10n.categories, 
                      ), 
                      BottomNavigationBarItem(
                        icon: const Icon(Icons.list),
                        label: l10n.transactions
                      )
                    ],
                    onTap: (int index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                  ),
                );
              }
            
            )
          );
        }
      )
    );
  }
}