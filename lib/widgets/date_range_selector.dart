import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_manager/l10n/gen/app_localizations.dart';
import 'package:money_manager/view_models/date_range_model.dart';
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
            onTap: () => _selectDateRange(context, dateRange),
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

  // 选择日期范围
  Future<void> _selectDateRange(BuildContext context, DateRangeModel dateRange) async {
    final l10n = AppLocalizations.of(context)!;
    final items = <PopupMenuEntry<dynamic>>[];
    
    // 选择特定日期选项
    items.add(
      PopupMenuItem<String>(
        value: 'select_specific_date',
        child: Text(l10n.selectSpecificDate),
      ),
    );
    
    // 添加分隔线
    items.add(const PopupMenuDivider());
    
    // 原有的选项
    items.add(
      PopupMenuItem<DateRangeType>(
        value: DateRangeType.day,
        child: Text(l10n.viewByDay),
      ),
    );
    
    items.add(
      PopupMenuItem<DateRangeType>(
        value: DateRangeType.week,
        child: Text(l10n.viewByWeek),
      ),
    );
    
    items.add(
      PopupMenuItem<DateRangeType>(
        value: DateRangeType.month,
        child: Text(l10n.viewByMonth),
      ),
    );
    
    items.add(
      PopupMenuItem<DateRangeType>(
        value: DateRangeType.year,
        child: Text(l10n.viewByYear),
      ),
    );
    
    items.add(
      PopupMenuItem<DateRangeType>(
        value: DateRangeType.custom,
        child: Text(l10n.customDateRange),
      ),
    );
    
    // 显示弹出菜单
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay = Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );
    
    final dynamic result = await showMenu<dynamic>(
      context: context,
      position: position,
      items: items,
    );
    
    if (result != null) {
      if (result == 'select_specific_date') {
        // 处理选择特定日期
        _selectSpecificDate(context, dateRange);
      } else if (result is DateRangeType) {
        // 处理现有的日期范围类型
        switch (result) {
          case DateRangeType.day:
            dateRange.setToday();
            break;
          case DateRangeType.week:
            dateRange.setCurrentWeek();
            break;
          case DateRangeType.month:
            dateRange.setCurrentMonth();
            break;
          case DateRangeType.year:
            dateRange.setCurrentYear();
            break;
          case DateRangeType.custom:
            _selectCustomDateRange(context, dateRange);
            break;
        }
      }
    }
  }
  
  // 选择特定日期
  Future<void> _selectSpecificDate(BuildContext context, DateRangeModel dateRange) async {
    final DateTime initialDate = dateRange.startDate;
    final DateTime firstDate = DateTime(2000);
    final DateTime lastDate = DateTime(2100);
    
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.red.shade400,
              onPrimary: Colors.white,
              surface: Colors.pink.shade50,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      dateRange.setDay(picked);
    }
  }
  
  Future<void> _selectCustomDateRange(BuildContext context, DateRangeModel dateRange) async {
    final initialDateRange = DateTimeRange(
      start: dateRange.startDate,
      end: dateRange.endDate,
    );
    
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: initialDateRange,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.red.shade400,
              onPrimary: Colors.white,
              surface: Colors.pink.shade50,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      dateRange.setDateRange(picked.start, picked.end);
    }
  }
} 