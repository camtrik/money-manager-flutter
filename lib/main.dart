import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:money_manager/services/storage_service.dart';
import 'package:money_manager/view_models/tx_list_model.dart';
import 'package:money_manager/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TxListModel(),
      child: MaterialApp(title: '记账应用', home: const HomeScreen()),
    );
  }
}
