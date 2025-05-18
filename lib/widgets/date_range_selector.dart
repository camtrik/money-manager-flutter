import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_manager/view_models/date_range_model.dart';
import 'package:provider/provider.dart';

class DateRangeSelector extends StatelessWidget {
  const DateRangeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final dateRange = Provider.of<DateRangeModel>(context);
    
    // format Date 
    final DateFormat monthFormatter = DateFormat.yMMMM(Localizations.localeOf(context).languageCode);
    final String displayText = monthFormatter.format(dateRange.startDate);
    
    // get days in month
    final int daysInMonth = DateTime(
      dateRange.startDate.year,
      dateRange.startDate.month + 1,
      0,
    ).day;
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.pink.shade50,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // left arrow 
          IconButton(
            icon: Icon(Icons.chevron_left, color: Colors.red.shade400),
            onPressed: () => dateRange.previousMonth(),
          ),
          // date selector 
          GestureDetector(
            onTap: () => _selectDateRange(context, dateRange),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // show
                Container(
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
                ),
                const SizedBox(width: 8),
                // show year and month 
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
          IconButton(
            icon: Icon(Icons.chevron_right, color: Colors.red.shade400),
            onPressed: () => dateRange.nextMonth(),
          ),
        ],
      ),
    );
  }

  // select date 
  // TODO: select range, now select month only
  Future<void> _selectDateRange(BuildContext context, DateRangeModel dateRange) async {
    final initialDate = dateRange.startDate;
    final firstDate = DateTime(2000);
    final lastDate = DateTime(2100);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      initialDatePickerMode: DatePickerMode.day,
    );

    if (picked != null) {
      dateRange.setMonth(picked.year, picked.month);
    }
  }
} 