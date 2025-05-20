import 'package:flutter/material.dart';
import 'package:money_manager/l10n/gen/app_localizations.dart';
import 'package:money_manager/view_models/date_range_model.dart';
import 'package:provider/provider.dart';

class DateRangeSelectorSheet extends StatelessWidget {
  const DateRangeSelectorSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateRange = Provider.of<DateRangeModel>(context);
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 标题
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              l10n.periodTitle,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Icon(Icons.date_range, size: 30),
                const SizedBox(height: 8),
                Text(
                  l10n.selectRange,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  _getDisplayText(dateRange),
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          
          // 选项网格
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 1.5,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              // 所有时间
              _buildGridItem(
                context, 
                Icons.all_inclusive, 
                l10n.allTime, 
                "", 
                () => _selectAllTime(context, dateRange),
                false,
              ),
              
              // 选择日期
              _buildGridItem(
                context, 
                Icons.calendar_today, 
                l10n.selectSpecificDate, 
                "", 
                () => _selectSpecificDate(context, dateRange),
                false,
              ),
              
              // 周
              _buildGridItem(
                context, 
                Icons.view_week, 
                l10n.week, 
                "${_getWeekRangeText(now)}", 
                () => _selectWeek(context, dateRange),
                dateRange.currentRangeType == DateRangeType.week,
              ),
              
              // 今天
              _buildGridItem(
                context, 
                Icons.today, 
                l10n.today, 
                "${now.month}月${now.day}日", 
                () => _selectToday(context, dateRange),
                dateRange.currentRangeType == DateRangeType.day,
              ),
              
              // 年
              _buildGridItem(
                context, 
                Icons.calendar_view_month, 
                l10n.year, 
                "${now.year} 年", 
                () => _selectYear(context, dateRange),
                dateRange.currentRangeType == DateRangeType.year,
              ),
              
              // 月
              _buildGridItem(
                context, 
                Icons.calendar_month, 
                l10n.month, 
                "${now.year}年 ${now.month}月", 
                () => _selectMonth(context, dateRange),
                dateRange.currentRangeType == DateRangeType.month,
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  // 获取当前选择的时间范围的显示文本
  String _getDisplayText(DateRangeModel dateRange) {
    final startDate = dateRange.startDate;
    final endDate = dateRange.endDate;
    
    switch (dateRange.currentRangeType) {
      case DateRangeType.day:
        return "${startDate.year}年${startDate.month}月${startDate.day}日";
      case DateRangeType.week:
        return _getWeekRangeText(startDate);
      case DateRangeType.month:
        return "${startDate.year}年${startDate.month}月";
      case DateRangeType.year:
        return "${startDate.year}年";
      case DateRangeType.custom:
        return "${startDate.year}/${startDate.month}/${startDate.day} - ${endDate.year}/${endDate.month}/${endDate.day}";
    }
  }
  
  // 获取周范围的显示文本
  String _getWeekRangeText(DateTime date) {
    final firstDayOfWeek = date.subtract(Duration(days: date.weekday - 1));
    final lastDayOfWeek = firstDayOfWeek.add(const Duration(days: 6));
    return "${firstDayOfWeek.month}月${firstDayOfWeek.day}日 - ${lastDayOfWeek.month}月${lastDayOfWeek.day}日";
  }
  
  // 构建网格项
  Widget _buildGridItem(BuildContext context, IconData icon, String title, String subtitle, VoidCallback onTap, bool isSelected) {
    return GestureDetector(
      onTap: () {
        onTap();
        Navigator.of(context).pop();
      },
      child: Container(
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade100 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? Colors.blue.shade50 : Colors.transparent,
                border: Border.all(
                  color: isSelected ? Colors.blue.shade300 : Colors.grey.shade400,
                ),
              ),
              child: Icon(
                icon, 
                color: isSelected ? Colors.blue.shade700 : Colors.black54,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.blue.shade700 : Colors.black87,
              ),
            ),
            if (subtitle.isNotEmpty)
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
          ],
        ),
      ),
    );
  }
  
  // 选择所有时间
  void _selectAllTime(BuildContext context, DateRangeModel dateRange) {
    // 这里可以设置为一个很大的范围，比如从2000年到现在
    final start = DateTime(2000, 1, 1);
    final end = DateTime.now().add(const Duration(days: 365)); // 未来一年
    dateRange.setDateRange(start, end);
  }
  
  // 选择特定日期
  Future<void> _selectSpecificDate(BuildContext context, DateRangeModel dateRange) async {
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
              primary: Colors.blue.shade400,
              onPrimary: Colors.white,
              surface: Colors.white,
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
  
  // 选择本周
  void _selectWeek(BuildContext context, DateRangeModel dateRange) {
    dateRange.setCurrentWeek();
  }
  
  // 选择今天
  void _selectToday(BuildContext context, DateRangeModel dateRange) {
    dateRange.setToday();
  }
  
  // 选择今年
  void _selectYear(BuildContext context, DateRangeModel dateRange) {
    dateRange.setCurrentYear();
  }
  
  // 选择本月
  void _selectMonth(BuildContext context, DateRangeModel dateRange) {
    dateRange.setCurrentMonth();
  }
} 