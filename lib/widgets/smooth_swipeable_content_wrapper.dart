// lib/widgets/smooth_swipeable_content.dart
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import 'package:money_manager/view_models/date_range_model.dart';

class SmoothSwipeableContent extends StatefulWidget {
  // Builder function for creating content with specific time period
  final Widget Function(BuildContext, DateRangeModel) contentBuilder;
  
  const SmoothSwipeableContent({
    super.key,
    required this.contentBuilder,
  });
  
  @override
  State<SmoothSwipeableContent> createState() => _SmoothSwipeableContentState();
}

class _SmoothSwipeableContentState extends State<SmoothSwipeableContent> with TickerProviderStateMixin {
  // 固定三页布局：前一页，当前页，后一页
  static const int _prevPageIndex = 0;
  static const int _currentPageIndex = 1;
  static const int _nextPageIndex = 2;
  
  // 页面控制器
  late final PageController _pageController;
  
  // 三个固定页面的日期范围模型
  late final List<DateRangeModel> _pageModels;
  
  // 动画控制器，用于处理平滑过渡
  late final AnimationController _transitionController;
  
  // 记录是否正在处理滑动更新
  bool _isHandlingPageChange = false;
  
  // 存储主日期范围模型的引用
  late DateRangeModel _mainDateRange;
  
  @override
  void initState() {
    super.initState();
    
    // 初始化页面控制器，从中间页面开始
    _pageController = PageController(
      initialPage: _currentPageIndex,
      viewportFraction: 1.0,
      keepPage: true,
    );
    
    // 初始化过渡动画控制器
    _transitionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    
    // 初始化三个页面的日期范围模型
    _pageModels = List.generate(3, (_) => DateRangeModel());
    
    // 页面控制器添加监听
    _pageController.addListener(_onPageScrollUpdate);
    
    // 在构建后初始化页面模型
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializePageModels();
    });
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 更新主日期范围模型的引用
    _mainDateRange = Provider.of<DateRangeModel>(context, listen: false);
  }
  
  void _initializePageModels() {
    if (!mounted) return;
    
    final mainModel = Provider.of<DateRangeModel>(context, listen: false);
    _mainDateRange = mainModel;
    
    // 为三个页面创建日期范围模型
    // 当前页面使用主模型的副本
    _pageModels[_currentPageIndex] = _cloneDateRange(mainModel);
    
    // 前一页使用"上一个"日期范围
    _pageModels[_prevPageIndex] = _createPreviousDateRange(mainModel);
    
    // 后一页使用"下一个"日期范围
    _pageModels[_nextPageIndex] = _createNextDateRange(mainModel);
    
    // 确保UI更新
    if (mounted) setState(() {});
  }
  
  // 为前一页创建日期范围模型
  DateRangeModel _createPreviousDateRange(DateRangeModel baseModel) {
    final model = _cloneDateRange(baseModel);
    _applyPreviousOffset(model);
    return model;
  }
  
  // 为后一页创建日期范围模型
  DateRangeModel _createNextDateRange(DateRangeModel baseModel) {
    final model = _cloneDateRange(baseModel);
    _applyNextOffset(model);
    return model;
  }
  
  // 深度复制日期范围模型
  DateRangeModel _cloneDateRange(DateRangeModel source) {
    final newModel = DateRangeModel();
    
    // 根据类型设置日期范围
    switch (source.currentRangeType) {
      case DateRangeType.day:
        newModel.setDay(source.startDate);
        break;
      case DateRangeType.week:
        newModel.setWeek(source.startDate);
        break;
      case DateRangeType.month:
        newModel.setMonth(source.startDate.year, source.startDate.month);
        break;
      case DateRangeType.year:
        newModel.setYear(source.startDate.year);
        break;
      case DateRangeType.custom:
        newModel.setDateRange(source.startDate, source.endDate);
        break;
      case DateRangeType.allTime:
        newModel.setAllTime();
        break;
    }
    
    return newModel;
  }
  
  // 页面滚动更新监听器
  void _onPageScrollUpdate() {
    // 仅在非处理状态且控制器可用时处理滚动
    if (_isHandlingPageChange || !_pageController.hasClients) return;
    
    // 获取当前页面位置
    final currentPosition = _pageController.page!;
    
    // 检测页面是否已经完全滑动到新位置
    if (currentPosition.round() != _currentPageIndex && 
        (currentPosition - currentPosition.round()).abs() < 0.01) {
      _handlePageChange(currentPosition.round());
    }
  }
  
  // 处理页面完全切换时的逻辑
  void _handlePageChange(int pageIndex) {
    if (_isHandlingPageChange) return;
    _isHandlingPageChange = true;
    
    // 确保动画是平滑的
    _transitionController.forward(from: 0.0);
    
    // 使用微任务确保处理发生在当前帧之后
    Future.microtask(() {
      if (!mounted) {
        _isHandlingPageChange = false;
        return;
      }
      
      // 获取主日期范围模型
      final mainModel = _mainDateRange;
      
      // 基于页面索引更新主模型
      if (pageIndex == _prevPageIndex) {
        _applyPreviousOffset(mainModel);
      } else if (pageIndex == _nextPageIndex) {
        _applyNextOffset(mainModel);
      }
      
      // 通知相关组件
      Provider.of<DateRangeModel>(context, listen: false).notifyListeners();
      
      // 在模型更新后，重置页面控制器到中央位置，并使用动画
      if (mounted && _pageController.hasClients) {
        _pageController.animateToPage(
          _currentPageIndex,
          duration: const Duration(milliseconds: 1), // 极短的动画使跳转看不出来
          curve: Curves.easeInOut,
        ).then((_) {
          // 动画完成后重新初始化页面模型
          _resetPages();
          _isHandlingPageChange = false;
        });
      } else {
        _isHandlingPageChange = false;
      }
    });
  }
  
  // 重置所有页面模型
  void _resetPages() {
    if (!mounted) return;
    
    // 更新三个页面的模型
    final mainModel = Provider.of<DateRangeModel>(context, listen: false);
    
    _pageModels[_currentPageIndex] = _cloneDateRange(mainModel);
    _pageModels[_prevPageIndex] = _createPreviousDateRange(mainModel);
    _pageModels[_nextPageIndex] = _createNextDateRange(mainModel);
    
    // 触发UI更新
    if (mounted) setState(() {});
  }
  
  // 向前偏移日期范围
  void _applyPreviousOffset(DateRangeModel model) {
    switch (model.currentRangeType) {
      case DateRangeType.day:
        model.previousDay();
        break;
      case DateRangeType.week:
        model.previousWeek();
        break;
      case DateRangeType.month:
        model.previousMonth();
        break;
      case DateRangeType.year:
        model.previousYear();
        break;
      case DateRangeType.allTime:
        // 全部时间不做偏移
        break;
      default:
        model.previousRange();
        break;
    }
  }
  
  // 向后偏移日期范围
  void _applyNextOffset(DateRangeModel model) {
    switch (model.currentRangeType) {
      case DateRangeType.day:
        model.nextDay();
        break;
      case DateRangeType.week:
        model.nextWeek();
        break;
      case DateRangeType.month:
        model.nextMonth();
        break;
      case DateRangeType.year:
        model.nextYear();
        break;
      case DateRangeType.allTime:
        // 全部时间不做偏移
        break;
      default:
        model.nextRange();
        break;
    }
  }
  
  // 监听主日期范围模型变化
  void _onDateRangeChanged() {
    // 当主模型发生变化时，重置页面
    if (!_isHandlingPageChange && mounted) {
      _resetPages();
    }
  }
  
  @override
  void dispose() {
    _transitionController.dispose();
    _pageController.removeListener(_onPageScrollUpdate);
    _pageController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    // 监听主日期范围模型的变化
    return Consumer<DateRangeModel>(
      builder: (context, mainDateRange, _) {
        // 当主模型变化时，如果不是由内部引起的，更新页面
        if (mainDateRange != _mainDateRange && !_isHandlingPageChange) {
          _mainDateRange = mainDateRange;
          
          // 使用postFrameCallback以避免在构建期间setState
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _resetPages();
          });
        }
        
        return PageView.builder(
          controller: _pageController,
          itemCount: 3, // 固定三页布局
          physics: const PageScrollPhysics(),
          pageSnapping: true,
          dragStartBehavior: DragStartBehavior.start, // 改善响应性
          itemBuilder: (context, index) {
            // 确保模型已正确初始化
            if (_pageModels.length != 3) {
              return const Center(child: CircularProgressIndicator());
            }
            
            // 使用RepaintBoundary和AnimatedSwitcher实现平滑过渡
            return RepaintBoundary(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 100),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: KeyedSubtree(
                  key: ValueKey('page_${_pageModels[index].hashCode}'),
                  child: widget.contentBuilder(context, _pageModels[index]),
                ),
              ),
            );
          },
        );
      },
    );
  }
}