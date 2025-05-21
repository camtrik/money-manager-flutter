import 'package:flutter/material.dart';
import 'package:money_manager/models/category.dart';
import 'package:money_manager/routes/app_routes.dart';
import 'package:money_manager/widgets/edit_tx_sheet.dart';
import 'package:money_manager/screens/category_screen.dart';
import 'package:money_manager/screens/edit_category_screen.dart';
import 'package:money_manager/screens/home_screen.dart';
import 'package:money_manager/screens/settings_screen.dart';
import 'package:money_manager/screens/tx_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case AppRoutes.home: 
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case AppRoutes.categories:
        return MaterialPageRoute(builder: (_) => const CategoryScreen());

      case AppRoutes.transactions:
        return MaterialPageRoute(builder: (_) => const TransactionScreen());

      case AppRoutes.settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());

      case AppRoutes.addCategory:
        return MaterialPageRoute(builder: (_) => const EditCategoryScreen());

      case AppRoutes.editCategory:
        if (args is Category) {
          return MaterialPageRoute(builder: (_) => EditCategoryScreen(category: args));
        }
        return _errorRoute();

      // never used 
      case AppRoutes.addTransaction:
        if (args is Category) {
          return _buildModalBottomSheetRoute(
            EditTransactionSheet(category: args),
            isFullScreenDialog: true, 
          );
        }
        return _errorRoute();

      default: 
        return _errorRoute();
    }
  }

  // never used in practice 
  static Route<dynamic> _buildModalBottomSheetRoute(Widget sheet, {isFullScreenDialog = false}) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => sheet, 
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child, 
        );
      },
      fullscreenDialog: isFullScreenDialog, 
    );
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) => const Scaffold(
      body: Center(
        child: Text('Error: Route not found'),
      ), 
    ));
  }
}