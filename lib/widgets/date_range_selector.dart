import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_manager/l10n/gen/app_localizations.dart';
import 'package:money_manager/view_models/date_range_model.dart';
import 'package:money_manager/widgets/date_range_selector_sheet.dart';
import 'package:provider/provider.dart';

class DateRangeSelector extends StatelessWidget {
  const DateRangeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final dateRange = Provider.of<DateRangeModel>(context);
    final l10n = AppLocalizations.of(context)!;
    
    String displayText;
    Widget? dayIndicator;
    
    // navigation button callbacks 
    VoidCallback previousCallback;
    VoidCallback nextCallback;
    
    switch (dateRange.currentRangeType) {
      case DateRangeType.day:
        final DateFormat dayFormatter = DateFormat.yMd(Localizations.localeOf(context).languageCode);
        displayText = dayFormatter.format(dateRange.startDate);
        previousCallback = dateRange.previousDay;
        nextCallback = dateRange.nextDay;
        break;
        
      case DateRangeType.week:
        final DateFormat dateFormatter = DateFormat.MMMd(Localizations.localeOf(context).languageCode);
        displayText = '${dateFormatter.format(dateRange.startDate)} - ${dateFormatter.format(dateRange.endDate)}';
        previousCallback = dateRange.previousWeek;
        nextCallback = dateRange.nextWeek;
        break;
        
      case DateRangeType.year:
        final DateFormat yearFormatter = DateFormat.y(Localizations.localeOf(context).languageCode);
        displayText = yearFormatter.format(dateRange.startDate);
        previousCallback = dateRange.previousYear;
        nextCallback = dateRange.nextYear;
        break;
        
      case DateRangeType.custom:
        final DateFormat dateFormatter = DateFormat.yMd(Localizations.localeOf(context).languageCode);
        displayText = '${dateFormatter.format(dateRange.startDate)} - ${dateFormatter.format(dateRange.endDate)}';
        previousCallback = dateRange.previousRange;
        nextCallback = dateRange.nextRange;
        break;
        
      case DateRangeType.month:
      default:
        final DateFormat monthFormatter = DateFormat.yMMMM(Localizations.localeOf(context).languageCode);
        displayText = monthFormatter.format(dateRange.startDate);
        
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
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.pink.shade50,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 左箭头
          IconButton(
            icon: Icon(Icons.chevron_left, color: Colors.red.shade400),
            onPressed: previousCallback,
          ),
          // 日期选择器
          GestureDetector(
            onTap: () => _showDateRangeSelectorSheet(context),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 天数指示器（仅在月视图中显示）
                if (dayIndicator != null) ...[
                  dayIndicator,
                  const SizedBox(width: 8),
                ],
                // 显示日期文本
                Text(
                  displayText,
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.red,
                ),
              ],
            ),
          ),
          // 右箭头
          IconButton(
            icon: Icon(Icons.chevron_right, color: Colors.red.shade400),
            onPressed: nextCallback,
          ),
        ],
      ),
    );
  }

  // 显示日期范围选择器底部弹出sheet
  void _showDateRangeSelectorSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const DateRangeSelectorSheet(),
    );
  }
} 