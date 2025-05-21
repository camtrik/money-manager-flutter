// lib/widgets/smooth_swipeable_content_wrapper.dart
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
  
  // 记录当前实际页面索引
  int _activePageIndex = _currentPageIndex;
  
  // 缓存页面内容，防止闪烁
  final Map<int, Widget> _cachedPageContents = {};
  
  @override
  void initState() {
    super.initState();
    
    // 初始化页面控制器，从中间页面开始
    _pageController = PageController(
      initialPage: _currentPageIndex,
      viewportFraction: 1.0,
      keepPage: false, // 设置为false以避免保持页面状态导致的闪烁
    );
    
    // 初始化过渡动画控制器
    _transitionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
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
    
    // 清除缓存的页面内容
    _cachedPageContents.clear();
    
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
    if (!_pageController.position.hasContentDimensions) return;
    
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
    
    // 记录新的活动页面索引
    _activePageIndex = pageIndex;
    
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
      
      // 在数据更新完成后再重置页面，避免视觉闪烁
      // 关键修改：我们不再使用动画跳转，而是直接跳转，并在跳转前后保持内容一致
      if (mounted && _pageController.hasClients) {
        // 使用WidgetsBinding确保在视觉更新之后执行跳转
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted || !_pageController.hasClients) {
            _isHandlingPageChange = false;
            return;
          }
          
          // 重要：在跳转前预先重置页面模型
          _preResetPagesForIndex(pageIndex);
          
          // 直接跳转到中央页面，不使用动画
          _pageController.jumpToPage(_currentPageIndex);
          
          // 跳转后完成剩余的页面重置
          _completePageReset();
          
          _isHandlingPageChange = false;
        });
      } else {
        _isHandlingPageChange = false;
      }
    });
  }
  
  // 预先重置页面模型，保持视觉一致性
  void _preResetPagesForIndex(int pageIndex) {
    if (!mounted) return;
    
    final mainModel = Provider.of<DateRangeModel>(context, listen: false);
    
    // 缓存当前活动页面的内容
    if (!_cachedPageContents.containsKey(pageIndex)) {
      _cachedPageContents[pageIndex] = widget.contentBuilder(context, _pageModels[pageIndex]);
    }
    
    // 重要：将当前活动页面的模型数据复制到中央页面
    _pageModels[_currentPageIndex] = _cloneDateRange(mainModel);
  }
  
  // 完成页面重置过程
  void _completePageReset() {
    if (!mounted) return;
    
    // 更新所有页面模型
    final mainModel = Provider.of<DateRangeModel>(context, listen: false);
    
    _pageModels[_currentPageIndex] = _cloneDateRange(mainModel);
    _pageModels[_prevPageIndex] = _createPreviousDateRange(mainModel);
    _pageModels[_nextPageIndex] = _createNextDateRange(mainModel);
    
    // 清除缓存
    _cachedPageContents.clear();
    _activePageIndex = _currentPageIndex;
    
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
  
  @override
  void dispose() {
    _transitionController.dispose();
    _pageController.removeListener(_onPageScrollUpdate);
    _pageController.dispose();
    _cachedPageContents.clear();
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
            _resetAndRefreshPages();
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
            
            // 使用缓存的内容或生成新内容
            Widget pageContent;
            if (_cachedPageContents.containsKey(index) && _isHandlingPageChange) {
              pageContent = _cachedPageContents[index]!;
            } else {
              pageContent = widget.contentBuilder(context, _pageModels[index]);
              
              // 如果是活动页面，缓存内容以备后用
              if (index == _activePageIndex && _isHandlingPageChange) {
                _cachedPageContents[index] = pageContent;
              }
            }
            
            // 使用RepaintBoundary优化重绘，但不再使用AnimatedSwitcher
            // 因为我们将通过保持内容一致性来避免闪烁
            return RepaintBoundary(
              child: KeyedSubtree(
                key: ValueKey('page_${_pageModels[index].hashCode}_$index'),
                child: pageContent,
              ),
            );
          },
        );
      },
    );
  }
  
  // 重置并刷新所有页面
  void _resetAndRefreshPages() {
    if (!mounted) return;
    
    // 首先清除缓存
    _cachedPageContents.clear();
    
    // 然后重置页面模型
    final mainModel = Provider.of<DateRangeModel>(context, listen: false);
    
    _pageModels[_currentPageIndex] = _cloneDateRange(mainModel);
    _pageModels[_prevPageIndex] = _createPreviousDateRange(mainModel);
    _pageModels[_nextPageIndex] = _createNextDateRange(mainModel);
    
    // 如果页面控制器不在中央页面，重置它
    if (_pageController.hasClients && 
        _pageController.page != null && 
        _pageController.page!.round() != _currentPageIndex) {
      _pageController.jumpToPage(_currentPageIndex);
    }
    
    // 重置活动页面索引
    _activePageIndex = _currentPageIndex;
    
    // 触发UI更新
    if (mounted) setState(() {});
  }
}