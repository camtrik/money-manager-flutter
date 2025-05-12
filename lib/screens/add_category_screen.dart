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
  String _selectedIcon = '❓'; // Default icon
  Color _selectedColor = Colors.purple; // Default color
  int _currentIndex = 0; // 0 for icon selection, 1 for color selection
  
  // List of common emoji icons to choose from
  final List<String> _icons = [
    '🍔', '🍕', '🍣', '🍦', '🍵', '🍺', 
    '🚗', '🚌', '🚖', '🚕', '🚅', '✈️',
    '🛍️', '👕', '👟', '💍', '🎁', '📱',
    '🎬', '🎮', '🎯', '🎨', '🎪', '🎭',
    '💊', '🏥', '🩺', '💉', '🦷', '👓',
    '🏠', '🏢', '💡', '🛁', '🧻', '🧼',
    '📱', '💻', '📞', '📺', '🖨️', '📷',
    '🧹', '🧴', '🧾', '🧷', '🧸', '🪒',
    '❓', '🎓', '🏆', '💼', '🧰', '🔧',
  ];
  
  // List of material colors to choose from
  final List<Color> _colors = [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
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
              child: Text(
                icon,
                style: const TextStyle(fontSize: 32),
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
                    child: Text(
                      _selectedIcon,
                      style: const TextStyle(fontSize: 36),
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