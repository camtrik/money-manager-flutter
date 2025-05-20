import 'package:flutter/material.dart';
import 'package:money_manager/l10n/gen/app_localizations.dart';
import 'package:money_manager/utils/date_formatter.dart';
import 'package:money_manager/view_models/date_range_model.dart';
import 'package:provider/provider.dart';

class DateRangeSelectorSheet extends StatelessWidget {
  const DateRangeSelectorSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateRange = Provider.of<DateRangeModel>(context);
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    
    // Calculate grid width with padding and margins
    final screenWidth = MediaQuery.of(context).size.width;
    final gridWidth = (screenWidth - 32) / 2; // 16px padding on each side
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              l10n.periodTitle,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          // Current date range display (clickable to open date range picker)
          GestureDetector(
            onTap: () => _selectCustomDateRange(context, dateRange),
            child: Container(
              width: screenWidth - 32, // Same width as two grid items
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Icon(Icons.date_range, size: 30),
                  const SizedBox(height: 8),
                  Text(
                    l10n.selectRange,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    _getDisplayText(context, dateRange),
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ),
          
          // Grid options
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 1.5,
            crossAxisSpacing: 4, // Even smaller gap between grid items
            mainAxisSpacing: 4, // Even smaller gap between grid items
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              // All time option
              _buildGridItem(
                context, 
                Icons.all_inclusive, 
                l10n.allTime, 
                "", 
                () => _selectAllTime(context, dateRange),
                dateRange.currentRangeType == DateRangeType.allTime,
              ),
              
              // Select specific date option
              _buildGridItem(
                context,
                Icons.calendar_today,
                l10n.selectSpecificDate,
                "",
                () async {
                  await _selectSpecificDate(context, dateRange);
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
                false,
              ),
              
              // Week option
              _buildGridItem(
                context, 
                Icons.view_week, 
                l10n.week, 
                DateFormatter.formatDateShort(context, now), 
                () => _selectWeek(context, dateRange),
                dateRange.currentRangeType == DateRangeType.week,
              ),
              
              // Today option
              _buildGridItem(
                context, 
                Icons.today, 
                l10n.today, 
                DateFormatter.formatDateShort(context, now), 
                () => _selectToday(context, dateRange),
                dateRange.currentRangeType == DateRangeType.day,
              ),
              
              // Year option
              _buildGridItem(
                context, 
                Icons.calendar_view_month, 
                l10n.year, 
                DateFormatter.formatYear(context, now), 
                () => _selectYear(context, dateRange),
                dateRange.currentRangeType == DateRangeType.year,
              ),
              
              // Month option
              _buildGridItem(
                context, 
                Icons.calendar_month, 
                l10n.month, 
                DateFormatter.formatMonthYear(context, now), 
                () => _selectMonth(context, dateRange),
                dateRange.currentRangeType == DateRangeType.month,
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  // Get display text for the current date range using DateFormatter
  String _getDisplayText(BuildContext context, DateRangeModel dateRange) {
    final startDate = dateRange.startDate;
    final endDate = dateRange.endDate;
    
    switch (dateRange.currentRangeType) {
      case DateRangeType.day:
        return DateFormatter.formatDate(context, startDate);
      case DateRangeType.week:
        return "${DateFormatter.formatDateShort(context, startDate)} - ${DateFormatter.formatDateShort(context, endDate)}";
      case DateRangeType.month:
        return DateFormatter.formatMonthYear(context, startDate);
      case DateRangeType.year:
        return DateFormatter.formatYear(context, startDate);
      case DateRangeType.allTime:
        return AppLocalizations.of(context)!.allTime;
      case DateRangeType.custom:
        return "${DateFormatter.formatDate(context, startDate)} - ${DateFormatter.formatDate(context, endDate)}";
    }
  }
  
  // Build a grid item
  Widget _buildGridItem(BuildContext context, IconData icon, String title, String subtitle, VoidCallback onTap, bool isSelected) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        margin: const EdgeInsets.all(2), // Even smaller margins
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
  
  // Select all time range
  void _selectAllTime(BuildContext context, DateRangeModel dateRange) {
    dateRange.setAllTime();
    Navigator.of(context).pop();
  }
  
  // Select specific date (opens date picker for a single day)
  Future<void> _selectSpecificDate(BuildContext context, DateRangeModel dateRange) async {
    final now = DateTime.now();
    
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    
    if (picked != null) {
      dateRange.setDay(picked);
    }
  }
  
  // Select custom date range
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
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    }
  }
  
  // Select current week
  void _selectWeek(BuildContext context, DateRangeModel dateRange) {
    dateRange.setCurrentWeek();
    Navigator.of(context).pop();
  }
  
  // Select today
  void _selectToday(BuildContext context, DateRangeModel dateRange) {
    dateRange.setToday();
    Navigator.of(context).pop();
  }
  
  // Select current year
  void _selectYear(BuildContext context, DateRangeModel dateRange) {
    dateRange.setCurrentYear();
    Navigator.of(context).pop();
  }
  
  // Select current month
  void _selectMonth(BuildContext context, DateRangeModel dateRange) {
    dateRange.setCurrentMonth();
    Navigator.of(context).pop();
  }
} 