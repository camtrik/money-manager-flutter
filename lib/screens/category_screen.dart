// lib/screens/category_screen.dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:money_manager/l10n/gen/app_localizations.dart';
import 'package:money_manager/models/category.dart';
import 'package:money_manager/models/transaction.dart';
import 'package:money_manager/routes/app_routes.dart';
import 'package:money_manager/widgets/edit_tx_sheet.dart';
import 'package:money_manager/view_models/date_range_model.dart';
import 'package:money_manager/widgets/date_range_selector.dart';
import 'package:money_manager/widgets/swipeable_content_wrapper.dart';

import 'package:money_manager/widgets/manage_category_sheet.dart';
import 'package:money_manager/utils/category_utils.dart';
import 'package:money_manager/view_models/category_list_model.dart';
import 'package:money_manager/view_models/tx_list_model.dart';
import 'package:provider/provider.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return SafeArea(
      child: Column(
        children: [
          // data range selector 
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Center(
              child: DateRangeSelector(),
            ),
          ),
          
          // Wrap the expanded content with SwipeableContentWrapper
          Expanded(
            child: SwipeableContentWrapper(
              child: Consumer<DateRangeModel>(
                builder: (context, dateRange, _) {
                  final txListModel = context.watch<TxListModel>();
                  
                  // get filtered transactions by date range
                  final List<Transaction> txs = txListModel.getFilteredByDateRange(dateRange);
                  final Map<String, double> sums = {};
                  final List<Category> categories = context.watch<CategoryListModel>().all;

                  // Get screen size for better adaptation
                  final screenSize = MediaQuery.of(context).size;
                  final screenWidth = screenSize.width;
                  final screenHeight = screenSize.height;
                  
                  // Calculate available space, considering safe area and bottom navigation bar
                  final padding = 16.0;
                  final availableWidth = screenWidth - (padding * 2);
                  final topPadding = MediaQuery.of(context).padding.top;
                  final bottomPadding = MediaQuery.of(context).padding.bottom;
                  // Subtract bottom navigation bar height (around 60) and top action bar
                  final availableHeight = screenHeight - (padding * 2) - topPadding - bottomPadding - 120;
                  
                  // In portrait mode, height is usually greater than width, we need to better utilize vertical space
                  final isPortrait = screenHeight > screenWidth;
                  
                  // Calculate grid height based on screen orientation
                  double gridHeight;
                  double cellHeight;
                  double childAspectRatio;
                  
                  if (isPortrait) {
                    // Portrait mode: utilize as much screen height as possible
                    // Calculate ideal cell width
                    final idealCellWidth = availableWidth / 4;
                    
                    // In portrait mode, we can use a larger proportion of available height
                    gridHeight = min((availableHeight * 0.9).toInt(), (idealCellWidth * 5.5).toInt()).toDouble();
                    
                    // Calculate cell height based on grid height
                    cellHeight = gridHeight / 5;
                    
                    // Adjust aspect ratio, cells can be slightly flatter in portrait mode
                    childAspectRatio = idealCellWidth / cellHeight;
                  } else {
                    // Landscape mode: maintain original logic
                    final idealCellWidth = availableWidth / 4;
                    final idealGridHeight = idealCellWidth * 5;
                    
                    gridHeight = idealGridHeight > availableHeight * 0.8 
                        ? availableHeight * 0.8
                        : idealGridHeight;
                    
                    cellHeight = gridHeight / 5;
                    childAspectRatio = idealCellWidth / cellHeight;
                  }

                  for (var c in categories) {
                    sums[c.id] = 0.0;
                  }

                  for (var tx in txs) {
                    final id = tx.category.id;
                    sums[id] = (sums[id] ?? 0) + tx.amount;
                  }

                  final List<PieChartSectionData> sections = [];
                  for (var c in categories) {
                    final total = sums[c.id] ?? 0;
                    if (total > 0) {
                      sections.add(PieChartSectionData(
                        color: Color(c.colorValue),
                        value: total,
                        radius: 20, // Slightly reduced to fit central space
                        showTitle: false,
                      ));
                    }
                  }

                  final totalExpense = sums.values.fold(0.0, (a, b) => a + b);

                  // Create a 4x5 grid (20 positions)
                  final gridItems = List<Widget>.filled(20, Container());
                  
                  // Define positions to be left empty (for pie chart placement)
                  final pieChartPositions = [5, 6, 9, 10, 13, 14]; // Corresponding to positions 6, 7, 10, 11, 14, 15
                  
                  // Define available positions for categories (excluding pie chart positions)
                  final availablePositions = List<int>.generate(20, (i) => i)
                    ..removeWhere((pos) => pieChartPositions.contains(pos));
                  
                  // Assign categories to available positions
                  for (var i = 0; i < min(categories.length, availablePositions.length - 1); i++) {
                    final category = categories[i];
                    final amount = sums[category.id] ?? 0;
                    final hasExpense = amount > 0;
                    
                    gridItems[availablePositions[i]] = _buildCategoryItem(
                      category, amount, hasExpense, context, i
                    );
                  }
                  
                  // Place the add button
                  if (categories.length < availablePositions.length - 1) {
                    // If there are not enough categories, place the add button after the last category
                    gridItems[availablePositions[categories.length]] = _buildAddButton(context);
                  } else {
                    // If categories are full, replace the last position with add button
                    gridItems[availablePositions.last] = _buildAddButton(context);
                  }
                  
                  // Place transparent containers in pie chart positions (so these areas still take up space but are invisible)
                  for (var pos in pieChartPositions) {
                    gridItems[pos] = Container(
                      color: Colors.transparent,
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        // Recalculate dimensions inside LayoutBuilder to get more accurate available space
                        final actualAvailableWidth = constraints.maxWidth;
                        final actualAvailableHeight = constraints.maxHeight;
                        
                        // Recalculate cell dimensions to better fit current actual available space
                        final actualCellWidth = actualAvailableWidth / 4;
                        
                        // Adjust grid height based on actual available height, fully utilizing vertical space
                        final actualGridHeight = actualAvailableHeight;
                        final actualCellHeight = actualGridHeight / 5;
                        final actualChildAspectRatio = actualCellWidth / actualCellHeight;
                        
                        return Stack(
                          children: [
                            // The base layer is GridView, now it will fill the entire available space
                            GridView.count(
                              crossAxisCount: 4, // 4 columns
                              childAspectRatio: actualChildAspectRatio, // Use calculated aspect ratio
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              children: gridItems,
                            ),
                            
                            // The top layer is the pie chart, placed in the position of the central 6 cells
                            Positioned(
                              // Calculate pie chart position: 2x3 area starting from second row, second column
                              left: actualCellWidth * 1 + 4, 
                              top: actualCellHeight * 1 + 4,
                              width: actualCellWidth * 2 - 4,
                              height: actualCellHeight * 3 - 8,
                              child: sections.isEmpty
                                ? Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        l10n.noTransactions,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  )
                                : FittedBox(
                                    fit: BoxFit.contain,
                                    child: SizedBox(
                                      width: 240, // Fixed width of pie chart
                                      height: 240, // Fixed height of pie chart
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          PieChart(
                                            PieChartData(
                                              sections: sections,
                                              centerSpaceRadius: 100,
                                              sectionsSpace: 0.5, // Reduced from 2 to 0.5 for thinner lines
                                              borderData: FlBorderData(show: false),
                                            ),
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                l10n.totalExpense,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey.shade600,
                                                ),
                                              ),
                                              Text(
                                                '¥${totalExpense.toStringAsFixed(0)}',
                                                style: const TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                            ),
                          ],
                        );
                      }
                    ),
                  );
                }
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Build category item
  Widget _buildCategoryItem(Category category, double amount, bool hasExpense, BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true, 
          useSafeArea: true, 
          backgroundColor: Colors.transparent, 
          builder: (context) {
            return EditTransactionSheet(category: category);
          },
        );
      },
      onLongPress: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.white, 
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) => ManageCategorySheet(category: category),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Category amount displayed at the top
          Text(
            '¥${amount.toStringAsFixed(0)}',
            style: TextStyle(
              color: hasExpense ? Color(category.colorValue) : Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          
          // Category icon
          CircleAvatar(
            radius: 22,
            backgroundColor: hasExpense
                ? Color(category.colorValue)
                : Color(category.colorValue).withValues(alpha: 0.2),
            child: Icon(
              category.icon,
              size: 20,
              color: hasExpense ? Colors.white : Color(category.colorValue),
            ),
          ),
          const SizedBox(height: 4),
          
          // Category name
          Text(
            CategoryUtils.getLocalizedName(context, category.id, category.name),
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade800,
              fontWeight: hasExpense ? FontWeight.bold : FontWeight.normal,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // Build add button
  Widget _buildAddButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to add category screen
        Navigator.pushNamed(context, AppRoutes.addCategory);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 18), // Align with amount position
          
          CircleAvatar(
            radius: 22,
            backgroundColor: Colors.grey.shade200,
            child: Icon(
              Icons.add,
              size: 20,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 4),
          
          Text(
            'Add',
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// Helper function
int min(int a, int b) {
  return a < b ? a : b;
}