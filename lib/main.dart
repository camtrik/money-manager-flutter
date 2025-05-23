import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:money_manager/l10n/gen/app_localizations.dart';
import 'package:money_manager/routes/app_routes.dart';
import 'package:money_manager/routes/route_generator.dart';
import 'package:money_manager/view_models/category_list_model.dart';
import 'package:money_manager/view_models/date_range_model.dart';
import 'package:money_manager/view_models/settings_provider.dart';
import 'package:provider/provider.dart';
import 'package:money_manager/services/storage_service.dart';
import 'package:money_manager/view_models/tx_list_model.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = Locale('en');

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }
}

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  final storageService = StorageService();
  await storageService.init();

  runApp(
    MultiProvider(
      providers: [
        Provider<StorageService>.value(value: storageService), 

        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        
        ChangeNotifierProvider(create: (_) => DateRangeModel()),

        ChangeNotifierProxyProvider<StorageService, CategoryListModel>(
          create: (context) => CategoryListModel(
            Provider.of<StorageService>(context, listen: false)
          ),
          update: (context, storage, previous) => 
            previous ?? CategoryListModel(storage),
        ),

        ChangeNotifierProxyProvider<StorageService, TxListModel>(
          create: (context) => TxListModel(
            Provider.of<StorageService>(context, listen: false)
          ),
          update: (context, storage, previous) => 
            previous ?? TxListModel(storage),
        ),

        ChangeNotifierProxyProvider<StorageService, SettingsProvider>(
          create: (context) => SettingsProvider(
            Provider.of<StorageService>(context, listen: false)
          ),
          update: (context, storage, previous) => 
            previous ?? SettingsProvider(storage),
        ),

      ],
      child: const MyApp(),
    )
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    
    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: settingsProvider.locale,
          localizationsDelegates: const [
            AppLocalizations.delegate, 
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate, 
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('zh'),
            Locale('ja'),
          ],
          title: 'Money Manager',
          initialRoute: AppRoutes.home, 
          onGenerateRoute: RouteGenerator.generateRoute,
        );
      }
    );
  }
}