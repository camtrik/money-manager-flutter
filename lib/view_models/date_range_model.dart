import 'package:flutter/material.dart';

class DateRangeModel extends ChangeNotifier {
  // data range now 
  DateTime _startDate;
  DateTime _endDate;
  
  // default as current month
  DateRangeModel() 
    : _startDate = DateTime(DateTime.now().year, DateTime.now().month, 1),
      _endDate = DateTime(
        DateTime.now().year, 
        DateTime.now().month + 1, 
        0, // 当前月的最后一天
        23, 59, 59
      );
  
  // Getters
  DateTime get startDate => _startDate;
  DateTime get endDate => _endDate;
  
  // check if a date is in the current range
  bool isInRange(DateTime date) {
    return date.isAtSameMomentAs(_startDate) || 
           date.isAtSameMomentAs(_endDate) || 
           (date.isAfter(_startDate) && date.isBefore(_endDate));
  }
  
  // set current month as default 
  void setCurrentMonth() {
    final now = DateTime.now();
    _startDate = DateTime(now.year, now.month, 1);
    _endDate = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
    notifyListeners();
  }
  
  // set custom date range
  void setDateRange(DateTime start, DateTime end) {
    _startDate = DateTime(start.year, start.month, start.day, 0, 0, 0);
    _endDate = DateTime(end.year, end.month, end.day, 23, 59, 59);
    notifyListeners();
  }
  
  // set to specific month 
  void setMonth(int year, int month) {
    _startDate = DateTime(year, month, 1);
    _endDate = DateTime(year, month + 1, 0, 23, 59, 59);
    notifyListeners();
  }
  
  // move to previous month 
  void previousMonth() {
    final year = _startDate.month == 1 ? _startDate.year - 1 : _startDate.year;
    final month = _startDate.month == 1 ? 12 : _startDate.month - 1;
    setMonth(year, month);
  }
  
  // move to next month 
  void nextMonth() {
    final year = _startDate.month == 12 ? _startDate.year + 1 : _startDate.year;
    final month = _startDate.month == 12 ? 1 : _startDate.month + 1;
    setMonth(year, month);
  }
  
  // TODO: not used yet 
  String formatDisplayText(BuildContext context) {
    // if it's a full month, only show year and month
    if (_startDate.day == 1 && _endDate.day == DateTime(_endDate.year, _endDate.month + 1, 0).day) {
      return '${_startDate.year} ${_startDate.month}月';
    }
    // otherwise, show the specific date range
    return '${_startDate.year}/${_startDate.month}/${_startDate.day} - ${_endDate.year}/${_endDate.month}/${_endDate.day}';
  }
} 