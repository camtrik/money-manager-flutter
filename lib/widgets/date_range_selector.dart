import 'package:flutter/material.dart';
import 'package:money_manager/l10n/gen/app_localizations.dart';
import 'package:money_manager/utils/date_formatter.dart';
import 'package:money_manager/view_models/date_range_model.dart';
import 'package:money_manager/widgets/date_range_selector_sheet.dart';
import 'package:provider/provider.dart';

class DateRangeSelector extends StatelessWidget {
  const DateRangeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final dateRange = Provider.of<DateRangeModel>(context);
    final l10n = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;
    
    String displayText;
    Widget? dayIndicator;
    
    // Navigation button callbacks 
    VoidCallback previousCallback;
    VoidCallback nextCallback;
    
    switch (dateRange.currentRangeType) {
      case DateRangeType.day:
        displayText = DateFormatter.formatDate(context, dateRange.startDate);
        previousCallback = dateRange.previousDay;
        nextCallback = dateRange.nextDay;
        break;
        
      case DateRangeType.week:
        final startStr = DateFormatter.formatDateShort(context, dateRange.startDate);
        final endStr = DateFormatter.formatDateShort(context, dateRange.endDate);
        displayText = '$startStr - $endStr';
        previousCallback = dateRange.previousWeek;
        nextCallback = dateRange.nextWeek;
        break;
        
      case DateRangeType.year:
        displayText = DateFormatter.formatYear(context, dateRange.startDate);
        previousCallback = dateRange.previousYear;
        nextCallback = dateRange.nextYear;
        break;
        
      case DateRangeType.custom:
        final startStr = DateFormatter.formatDateShort(context, dateRange.startDate);
        final endStr = DateFormatter.formatDateShort(context, dateRange.endDate);
        displayText = '$startStr - $endStr';
        previousCallback = dateRange.previousRange;
        nextCallback = dateRange.nextRange;
        break;

      case DateRangeType.allTime:
        displayText = l10n.allTime;
        // Disable navigation for all time view
        previousCallback = () {};
        nextCallback = () {};
        break;
        
      // case DateRangeType.month:
        
      default:
        displayText = DateFormatter.formatMonthYear(context, dateRange.startDate);
        
        final int daysInMonth = DateTime(
          dateRange.startDate.year,
          dateRange.startDate.month + 1,
          0,
        ).day;
        
        dayIndicator = Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.red.shade400,
          ),
          child: Center(
            child: Text(
              daysInMonth.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
        
        previousCallback = dateRange.previousMonth;
        nextCallback = dateRange.nextMonth;
        break;
    }
    
    final selectorWidth = screenWidth * 0.6;
    
    return Center(
      child: Container(
        width: selectorWidth,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.pink.shade50,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Left arrow
            IconButton(
              icon: Icon(Icons.chevron_left, color: Colors.red.shade400),
              onPressed: previousCallback,
              constraints: const BoxConstraints(),
              padding: const EdgeInsets.all(8),
            ),
            // Date selector
            Expanded(
              child: GestureDetector(
                onTap: () => _showDateRangeSelectorSheet(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Day indicator (only shown in month view)
                    if (dayIndicator != null) ...[
                      dayIndicator,
                      const SizedBox(width: 8),
                    ],
                    // Display date text
                    Flexible(
                      child: Text(
                        displayText,
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 4),
                  ],
                ),
              ),
            ),
            // Right arrow
            IconButton(
              icon: Icon(Icons.chevron_right, color: Colors.red.shade400),
              onPressed: nextCallback,
              constraints: const BoxConstraints(),
              padding: const EdgeInsets.all(8),
            ),
          ],
        ),
      ),
    );
  }

  void _showDateRangeSelectorSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const DateRangeSelectorSheet(),
    );
  }
} 