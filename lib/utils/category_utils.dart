// lib/utils/category_utils.dart

import 'package:flutter/material.dart';
import 'package:money_manager/l10n/gen/app_localizations.dart';

class CategoryUtils {
  // get the localized name for defailt categories
  static String getLocalizedName(BuildContext context, String categoryId, String categoryName) {
    final l10n = AppLocalizations.of(context)!;

    switch (categoryId) {
      case 'dining':
        return l10n.categoryDining;
      case 'transport':
        return l10n.categoryTransport;
      case 'shopping':
        return l10n.categoryShopping;
      case 'entertainment':
        return l10n.categoryEntertainment;
      case 'medical':
        return l10n.categoryMedical;
      case 'housing':
        return l10n.categoryHousing;
      case 'communication':
        return l10n.categoryCommunication;
      case 'daily_necessities':
        return l10n.categoryDaily;
      case 'other':
        return l10n.categoryOther;
      default:
        return categoryName; // Fallback to ID if no translation found
    }
  }


  // List of common emoji icons to choose from
  static final List<IconData> icons = [
    // Food & Dining
    Icons.restaurant, Icons.fastfood, Icons.local_cafe, Icons.local_bar, Icons.local_pizza, Icons.bakery_dining,
    // Transport
    Icons.directions_car, Icons.directions_bus, Icons.train, Icons.flight, Icons.directions_bike, Icons.electric_scooter,
    // Shopping
    Icons.shopping_cart, Icons.shopping_bag, Icons.store, Icons.shopping_basket, Icons.redeem, Icons.card_giftcard,
    // Entertainment
    Icons.movie, Icons.sports_esports, Icons.sports, Icons.music_note, Icons.theaters, Icons.nightlife,
    // Health & Medical
    Icons.medical_services, Icons.local_hospital, Icons.medication, Icons.fitness_center, Icons.spa, Icons.sports_tennis,
    // Home & Living
    Icons.house, Icons.home_repair_service, Icons.cleaning_services, Icons.shower, Icons.lightbulb, Icons.bed,
    // Communication & Electronics
    Icons.smartphone, Icons.computer, Icons.phone, Icons.tv, Icons.headphones, Icons.camera_alt,
    // Daily necessities & Misc
    Icons.pets, Icons.child_care, Icons.school, Icons.book, Icons.savings, Icons.work, 
    // Others
    Icons.attach_money, Icons.credit_card, Icons.payments, Icons.receipt_long, Icons.extension, Icons.question_mark,
  ];

  // List of material colors to choose from
  static final List<Color> colors = [
    // Reds
    Colors.red,
    Colors.red.shade300,
    Colors.red.shade800,
    Colors.redAccent,
    
    // Pinks
    Colors.pink,
    Colors.pink.shade300,
    Colors.pink.shade800,
    Colors.pinkAccent,
    
    // Purples
    Colors.purple,
    Colors.purple.shade300,
    Colors.purple.shade800,
    Colors.purpleAccent,
    Colors.deepPurple,
    Colors.deepPurple.shade300,
    
    // Blues
    Colors.indigo,
    Colors.indigo.shade300,
    Colors.blue,
    Colors.blue.shade300,
    Colors.blue.shade800,
    Colors.blueAccent,
    Colors.lightBlue,
    Colors.lightBlue.shade300,
    
    // Cyans & Teals
    Colors.cyan,
    Colors.cyan.shade300,
    Colors.teal,
    Colors.teal.shade300,
    
    // Greens
    Colors.green,
    Colors.green.shade300,
    Colors.green.shade800,
    Colors.greenAccent,
    Colors.lightGreen,
    Colors.lightGreen.shade300,
    
    // Yellows & Ambers
    Colors.lime,
    Colors.lime.shade300,
    Colors.yellow,
    Colors.yellow.shade600,
    Colors.amber,
    Colors.amber.shade300,
    
    // Oranges
    Colors.orange,
    Colors.orange.shade300,
    Colors.orange.shade800,
    Colors.orangeAccent,
    Colors.deepOrange,
    Colors.deepOrange.shade300,
    
    // Browns & Greys
    Colors.brown,
    Colors.brown.shade300,
    Colors.grey,
    Colors.grey.shade600,
    Colors.blueGrey,
    Colors.blueGrey.shade300,
  ];

}