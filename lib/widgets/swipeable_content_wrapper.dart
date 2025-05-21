// lib/widgets/swipeable_content_wrapper.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:money_manager/view_models/date_range_model.dart';

class SwipeableContentWrapper extends StatefulWidget {
  final Widget child;
  
  const SwipeableContentWrapper({
    super.key,
    required this.child,
  });
  
  @override
  State<SwipeableContentWrapper> createState() => _SwipeableContentWrapperState();
}

class _SwipeableContentWrapperState extends State<SwipeableContentWrapper> {
  late PageController _pageController;
  bool _isAnimating = false;
  
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 1);
  }
  
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  
  void _updateDateRange(DateRangeModel dateRange, int direction) {
    if (direction < 0) {
      // Previous
      switch (dateRange.currentRangeType) {
        case DateRangeType.day:
          dateRange.previousDay();
          break;
        case DateRangeType.week:
          dateRange.previousWeek();
          break;
        case DateRangeType.month:
          dateRange.previousMonth();
          break;
        case DateRangeType.year:
          dateRange.previousYear();
          break;
        case DateRangeType.allTime:
          // Do nothing for all time
          break;
        default:
          dateRange.previousRange();
          break;
      }
    } else if (direction > 0) {
      // Next
      switch (dateRange.currentRangeType) {
        case DateRangeType.day:
          dateRange.nextDay();
          break;
        case DateRangeType.week:
          dateRange.nextWeek();
          break;
        case DateRangeType.month:
          dateRange.nextMonth();
          break;
        case DateRangeType.year:
          dateRange.nextYear();
          break;
        case DateRangeType.allTime:
          // Do nothing for all time
          break;
        default:
          dateRange.nextRange();
          break;
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Consumer<DateRangeModel>(
      builder: (context, dateRange, _) {
        return GestureDetector(
          // 捕获水平滑动手势
          onHorizontalDragEnd: (details) {
            if (_isAnimating) return;
            
            // 检测滑动方向
            if (details.primaryVelocity! < 0) {
              // 向左滑动（下一个）
              setState(() {
                _isAnimating = true;
              });
              _pageController.animateToPage(
                2,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              ).then((_) {
                _updateDateRange(dateRange, 1);
                Future.delayed(const Duration(milliseconds: 20), () {
                  if (_pageController.hasClients) {
                    _pageController.jumpToPage(1);
                    setState(() {
                      _isAnimating = false;
                    });
                  }
                });
              });
            } else if (details.primaryVelocity! > 0) {
              // 向右滑动（上一个）
              setState(() {
                _isAnimating = true;
              });
              _pageController.animateToPage(
                0, 
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              ).then((_) {
                _updateDateRange(dateRange, -1);
                Future.delayed(const Duration(milliseconds: 20), () {
                  if (_pageController.hasClients) {
                    _pageController.jumpToPage(1);
                    setState(() {
                      _isAnimating = false;
                    });
                  }
                });
              });
            }
          },
          child: PageView.builder(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(), // 禁用PageView的默认滚动
            itemCount: 3, // Previous, Current, Next
            itemBuilder: (context, index) {
              return widget.child;
            },
          ),
        );
      },
    );
  }
}