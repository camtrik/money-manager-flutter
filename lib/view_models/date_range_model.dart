import 'package:flutter/material.dart';

// range type enum
enum DateRangeType {
  custom,
  day,
  week,
  month,
  year
}

class DateRangeModel extends ChangeNotifier {
  // data range now 
  DateTime _startDate;
  DateTime _endDate;
  
  // current range type
  DateRangeType _currentRangeType = DateRangeType.month;
  
  // default as current month
  DateRangeModel() 
    : _startDate = DateTime(DateTime.now().year, DateTime.now().month, 1),
      _endDate = DateTime(
        DateTime.now().year, 
        DateTime.now().month + 1, 
        0,
        23, 59, 59
      );
  
  // Getters
  DateTime get startDate => _startDate;
  DateTime get endDate => _endDate;
  DateRangeType get currentRangeType => _currentRangeType;
  
  // check if a date is in the current range
  bool isInRange(DateTime date) {
    return date.isAtSameMomentAs(_startDate) || 
           date.isAtSameMomentAs(_endDate) || 
           (date.isAfter(_startDate) && date.isBefore(_endDate));
  }
  
  // set custom range 
  void setDateRange(DateTime start, DateTime end) {
    _startDate = DateTime(start.year, start.month, start.day, 0, 0, 0);
    _endDate = DateTime(end.year, end.month, end.day, 23, 59, 59);
    _currentRangeType = DateRangeType.custom;
    notifyListeners();
  }
  
  // set previous range 
  void previousRange() {
    final duration = _endDate.difference(_startDate);
    final newEnd = _startDate.subtract(const Duration(seconds: 1));
    final newStart = newEnd.subtract(duration);
    
    setDateRange(newStart, newEnd);
  }
  
  // set next range 
  void nextRange() {
    final duration = _endDate.difference(_startDate);
    final newStart = _endDate.add(const Duration(seconds: 1));
    final newEnd = newStart.add(duration);
    
    setDateRange(newStart, newEnd);
  }

  // set current month as default 
  void setCurrentMonth() {
    final now = DateTime.now();
    _setMonth(now.year, now.month);
  }
  
  // set to specific month (private implementation)
  void _setMonth(int year, int month) {
    _startDate = DateTime(year, month, 1);
    _endDate = DateTime(year, month + 1, 0, 23, 59, 59);
    _currentRangeType = DateRangeType.month;
    notifyListeners();
  }
  
  // set month 
  void setMonth(int year, int month) {
    _setMonth(year, month);
  }
  
  // move to previous month 
  void previousMonth() {
    final year = _startDate.month == 1 ? _startDate.year - 1 : _startDate.year;
    final month = _startDate.month == 1 ? 12 : _startDate.month - 1;
    _setMonth(year, month);
  }
  
  // move to next month 
  void nextMonth() {
    final year = _startDate.month == 12 ? _startDate.year + 1 : _startDate.year;
    final month = _startDate.month == 12 ? 1 : _startDate.month + 1;
    _setMonth(year, month);
  }
  
  // set year 
  void setYear(int year) {
    _startDate = DateTime(year, 1, 1);
    _endDate = DateTime(year, 12, 31, 23, 59, 59);
    _currentRangeType = DateRangeType.year;
    notifyListeners();
  }
  
  // set current year 
  void setCurrentYear() {
    setYear(DateTime.now().year);
  }
  
  // set previous year 
  void previousYear() {
    setYear(_startDate.year - 1);
  }
  
  // set next year 
  void nextYear() {
    setYear(_startDate.year + 1);
  }
  
  // set day 
  void setDay(DateTime day) {
    _startDate = DateTime(day.year, day.month, day.day, 0, 0, 0);
    _endDate = DateTime(day.year, day.month, day.day, 23, 59, 59);
    _currentRangeType = DateRangeType.day;
    notifyListeners();
  }
  
  // set today 
  void setToday() {
    setDay(DateTime.now());
  }
  
  // set previous day 
  void previousDay() {
    setDay(_startDate.subtract(const Duration(days: 1)));
  }
  
  // set next day 
  void nextDay() {
    setDay(_startDate.add(const Duration(days: 1)));
  }
  
  // set week 
  void setWeek(DateTime date) {
    // find the first day of the week (Monday)
    final firstDayOfWeek = date.subtract(Duration(days: date.weekday - 1));
    // set from Monday to Sunday
    _startDate = DateTime(firstDayOfWeek.year, firstDayOfWeek.month, firstDayOfWeek.day, 0, 0, 0);
    _endDate = _startDate.add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));
    _currentRangeType = DateRangeType.week;
    notifyListeners();
  }
  
  // set current week 
  void setCurrentWeek() {
    setWeek(DateTime.now());
  }
  
  // set previous week 
  void previousWeek() {
    setWeek(_startDate.subtract(const Duration(days: 7)));
  }
  
  // set next week 
  void nextWeek() {
    setWeek(_startDate.add(const Duration(days: 7)));
  }
  
  String formatDisplayText(BuildContext context) {
    switch (_currentRangeType) {
      case DateRangeType.day:
        return '${_startDate.year}/${_startDate.month}/${_startDate.day}';
      case DateRangeType.week:
        return '${_startDate.year}/${_startDate.month}/${_startDate.day} - ${_endDate.year}/${_endDate.month}/${_endDate.day}';
      case DateRangeType.month:
        return '${_startDate.year}年${_startDate.month}月';
      case DateRangeType.year:
        return '${_startDate.year}年';
      case DateRangeType.custom:
      default:
        return '${_startDate.year}/${_startDate.month}/${_startDate.day} - ${_endDate.year}/${_endDate.month}/${_endDate.day}';
    }
  }
} 