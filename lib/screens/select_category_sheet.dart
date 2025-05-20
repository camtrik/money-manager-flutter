import 'package:flutter/material.dart';
import 'package:money_manager/l10n/gen/app_localizations.dart';
import 'package:money_manager/models/category.dart';
import 'package:money_manager/routes/app_routes.dart';
import 'package:money_manager/view_models/category_list_model.dart';
import 'package:provider/provider.dart';

class SelectCategorySheet extends StatelessWidget {
  // callback function
  final Function(Category) onCategorySelected;

  const SelectCategorySheet({super.key, required this.onCategorySelected});

  Widget _buildCategoryItem({
    required IconData icon,
    required String label,
    required Color color,
    String? amount,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color, 
              borderRadius: BorderRadius.circular(28),
            ),
            child: Center(
              child: Icon(
                icon,
                size: 24,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 4),
          if (label.isNotEmpty)
            Text(
              label,
              style: const TextStyle(fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          if (amount != null)
            Text(
              amount,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade600,
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final categories = context.watch<CategoryListModel>().all;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 40, 
            height: 4, 
            margin: const EdgeInsets.symmetric(vertical: 12), 
            decoration: BoxDecoration(
              color: Colors.grey.shade300, 
              borderRadius: BorderRadius.circular(2), 
            ),
          ),

          // Title 
          Padding( 
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), 
            child: Text(
              l10n.category, 
              style: const TextStyle( 
                fontSize: 16, 
                fontWeight: FontWeight.bold, 
              )
            )
          ),

          // Categories grid 
          Expanded( 
            child: GridView.builder(
              padding: const EdgeInsets.all(16), 
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, // 4 columns
                crossAxisSpacing: 8,  // horizontal spacing between columns
                mainAxisSpacing: 16, // vertical spacing between rows
                childAspectRatio: 0.8, // aspect ratio of each item
              ),
              itemCount: categories.length + 1,  
              itemBuilder: (context, index) {
                // Add item
                if (index == categories.length) {
                  return _buildCategoryItem(
                    icon: Icons.add,
                    label: '', 
                    color: Colors.grey,
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.addCategory);
                    }
                  );
                }
                
                // Category items 
                final category = categories[index];
                return _buildCategoryItem(
                  icon: category.icon, 
                  label: category.name, 
                  color: Color(category.colorValue), 
                  onTap: () {
                    onCategorySelected(category);
                    Navigator.pop(context);
                  }
                );
              }                
            )
          )
        ]
      )
    );
  }
}