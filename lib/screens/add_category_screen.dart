import 'package:flutter/material.dart';
import 'package:money_manager/l10n/gen/app_localizations.dart';
import 'package:money_manager/models/category.dart';
import 'package:money_manager/view_models/category_list_model.dart';
import 'package:provider/provider.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({super.key});

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final TextEditingController _nameController = TextEditingController();
  IconData _selectedIcon = Icons.question_mark; // Default icon
  Color _selectedColor = Colors.purple; // Default color
  int _currentIndex = 0; // 0 for icon selection, 1 for color selection
  
  // List of common emoji icons to choose from
  final List<IconData> _icons = [
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
  final List<Color> _colors = [
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


  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveCategory() {
    if (_nameController.text.trim().isEmpty) {
      // Show error if name is empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.categoryNameRequired ?? 'Category name is required'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Create new category
    final category = Category(
      name: _nameController.text.trim(),
      icon: _selectedIcon,
      colorValue: _selectedColor.value,
    );

    // Add to category list
    context.read<CategoryListModel>().add(category);
    
    // Return to previous screen
    Navigator.pop(context, category);
  }
  
  Widget _buildIconGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
      ),
      itemCount: _icons.length,
      itemBuilder: (context, index) {
        final icon = _icons[index];
        final isSelected = icon == _selectedIcon;
        
        return InkWell(
          onTap: () {
            setState(() {
              _selectedIcon = icon;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? _selectedColor.withOpacity(0.2) : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: isSelected 
                  ? Border.all(color: _selectedColor, width: 2)
                  : Border.all(color: Colors.grey.withOpacity(0.3)),
            ),
            child: Center(
              child: Icon(
                icon,
                size: 32,
              ),
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildColorGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
      ),
      itemCount: _colors.length,
      itemBuilder: (context, index) {
        final color = _colors[index];
        final isSelected = color.value == _selectedColor.value;
        
        return InkWell(
          onTap: () {
            setState(() {
              _selectedColor = color;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: isSelected 
                  ? Border.all(color: Colors.white, width: 3)
                  : null,
              boxShadow: isSelected
                  ? [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 8)]
                  : null,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
            ),
            Text(l10n.addCategory ?? 'Add Category'),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ElevatedButton(
                onPressed: _saveCategory,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _selectedColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  l10n.save,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name input with preview on the right
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category name input - takes most of the width
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.categoryName ?? 'Category Name',
                        style: const TextStyle(fontSize: 18),
                      ),
                      TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Preview on the right
                Container(
                  margin: const EdgeInsets.only(left: 16),
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: _selectedColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      _selectedIcon,
                      size: 36,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Tab navigation
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => setState(() => _currentIndex = 0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: _currentIndex == 0 ? _selectedColor : Colors.grey.shade300,
                          width: _currentIndex == 0 ? 2 : 1,
                        ),
                      ),
                    ),
                    child: Text(
                      l10n.selectIcon ?? 'Select Icon',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _currentIndex == 0 ? _selectedColor : Colors.grey.shade600,
                        fontWeight: _currentIndex == 0 ? FontWeight.bold : FontWeight.normal,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () => setState(() => _currentIndex = 1),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: _currentIndex == 1 ? _selectedColor : Colors.grey.shade300,
                          width: _currentIndex == 1 ? 2 : 1,
                        ),
                      ),
                    ),
                    child: Text(
                      l10n.selectColor ?? 'Select Color',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _currentIndex == 1 ? _selectedColor : Colors.grey.shade600,
                        fontWeight: _currentIndex == 1 ? FontWeight.bold : FontWeight.normal,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          // Icon or color grid
          Expanded(
            child: _currentIndex == 0 ? _buildIconGrid() : _buildColorGrid(),
          ),
        ],
      ),
    );
  }
}