library history_list;

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class HistoryMessageList extends StatefulWidget {
  ///新消息子组件
  final Widget? Function(BuildContext, int) newBuilder;

  ///历史消息子组件
  final Widget? Function(BuildContext, int) oldBuilder;

  ///新消息加载组件
  final Widget? oldloadingWidget;

  ///新消息加载组件
  final Widget? newloadingWidget;

  ///加载历史消息
  final Future? Function() oldHardle;

  ///加载新消息
  final Future? Function() newHardle;

  ///历史消息数量
  final int? oldCount;

  ///新消息数量;
  final int? newCount;

  ///触发加载新信息距离  需要 >0  在离屏幕外距离开始加载
  final double? extentAfter;

  ///触发加载历史信息距离 需要 >0  在离屏幕外距离开始加载
  final double? extentBefore;

  ///滑动控制器
  final ScrollController? scrollController;

  const HistoryMessageList(
      {Key? key,
      this.extentAfter = 0.0,
      this.extentBefore = 0.0,
      required this.newBuilder,
      required this.oldBuilder,
      required this.newHardle,
      required this.oldHardle,
      this.scrollController,
      this.newCount,
      this.oldCount,
      this.oldloadingWidget,
      this.newloadingWidget})
      : super(key: key);

  @override
  State<HistoryMessageList> createState() => _HistoryMessageListState();
}

class _HistoryMessageListState extends State<HistoryMessageList> {
  bool _isLoading = false;
  GlobalKey centerKey = GlobalKey();
  late double _extentAfter = 0;
  late double _extentBefore = 0;

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
        onNotification: (notification) {
          return onNotificationHandle(notification);
        },
        child: CustomScrollView(
          controller: widget.scrollController,
          center: centerKey,
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                  alignment: Alignment.center,
                  child: widget.oldloadingWidget ?? Text('正在加载中')),
            ),
            SliverList(
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
                return widget.oldBuilder(context, index);
              }, childCount: widget.oldCount),
            ),
            SliverPadding(
              padding: EdgeInsets.zero,
              key: centerKey,
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return widget.newBuilder(context, index);
                },
                childCount: widget.newCount,
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                alignment: Alignment.center,
                child: widget.newloadingWidget ?? Text('正在加载中'),
              ),
            ),
          ],
        ));
  }

  bool onNotificationHandle(notification) {
    if (notification is ScrollNotification) {
      if (notification.metrics is PageMetrics) {
        return false;
      }
      if (notification.metrics is FixedScrollMetrics) {
        if (notification.metrics.axisDirection == AxisDirection.left ||
            notification.metrics.axisDirection == AxisDirection.right) {
          return false;
        }
      }
      _extentAfter = notification.metrics.extentAfter;
      _extentBefore = notification.metrics.extentBefore;
      if (_extentAfter <= widget.extentAfter! && !_isLoading) {
        setLoading(true);
        widget.newHardle()?.then((value) => setLoading(false));
      }
      if (_extentBefore <= widget.extentBefore! && !_isLoading) {
        setLoading(true);
        widget.oldHardle()?.then((value) => setLoading(false));
      }
    }
    return false;
  }

  setLoading(isLoading) {
    _isLoading = isLoading;
  }
}
