import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';

/// A specialized container that implements a direct-render swipe-to-reply gesture
/// optimized for comment threads.
///
/// Bypasses standard high-overhead widget trees (such as `Dismissible` or
/// `setState`-driven translations) by managing layout-independent repaints directly
/// via a custom [RenderBox] and painting icons using a [TextPainter]. Includes
/// smooth overscroll rubber-banding once the drag reaches the target cap.
class SwipeToReplyBubble extends StatefulWidget {
  const SwipeToReplyBubble({
    super.key,
    required this.child,
    required this.onReply,
    this.icon = Symbols.reply_all,
    this.threshold = 56.0,
    this.dragCap = 64.0,
    this.maxOverscroll = 24.0,
  });

  /// The primary content widget (e.g., comment bubble) wrapped by this interaction handler.
  final Widget child;

  /// Callback executed when a drag exceeds the activation threshold and the gesture is released.
  final VoidCallback onReply;

  /// The glyph rendered inside the expanding background panel during a drag.
  final IconData icon;

  /// The minimum horizontal distance required to arm the reply action.
  final double threshold;

  /// The target width and distance at which the reveal panel reaches its primary full size.
  final double dragCap;

  /// The maximum allowed stretch distance past [dragCap], governed by an asymptotic resistance curve.
  final double maxOverscroll;

  @override
  State<SwipeToReplyBubble> createState() => _SwipeToReplyBubbleState();
}

class _SwipeToReplyBubbleState extends State<SwipeToReplyBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  /// Tracks the total unprocessed cumulative distance of the active gesture, allowing
  /// smooth bidirectional tracking through the overscroll zone without clipping.
  double _rawDrag = 0;

  bool _armed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      lowerBound: 0,
      upperBound: widget.dragCap + widget.maxOverscroll,
      value: 0,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Applies a decelerating formula to raw drag inputs exceeding [dragCap], creating
  /// a damped rubber-band effect that asymptotically approaches [maxOverscroll].
  double _stretchedValue(double raw) {
    if (raw <= widget.dragCap) return raw;
    final overflow = raw - widget.dragCap;
    final maxOverscroll = widget.maxOverscroll;
    if (maxOverscroll <= 0) return widget.dragCap;
    final stretch = maxOverscroll * overflow / (overflow + maxOverscroll);
    return widget.dragCap + stretch;
  }

  void _onDragStart(DragStartDetails details) {
    _controller.stop();
    _rawDrag = _controller.value;
    _armed = _controller.value >= widget.threshold;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    _rawDrag = (_rawDrag + details.delta.dx).clamp(0.0, double.infinity);
    _controller.value = _stretchedValue(_rawDrag);

    final nowArmed = _controller.value >= widget.threshold;
    if (nowArmed != _armed) {
      _armed = nowArmed;
      HapticFeedback.selectionClick();
    }
  }

  void _endDrag({required bool trigger}) {
    _armed = false;
    _controller.animateTo(
      0,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
    );
    if (trigger) {
      HapticFeedback.mediumImpact();
      widget.onReply();
    }
  }

  void _onDragEnd(DragEndDetails details) =>
      _endDrag(trigger: _controller.value >= widget.threshold);

  void _onDragCancel() => _endDrag(trigger: false);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onHorizontalDragStart: _onDragStart,
      onHorizontalDragUpdate: _onDragUpdate,
      onHorizontalDragEnd: _onDragEnd,
      onHorizontalDragCancel: _onDragCancel,
      child: _SwipeRevealRenderWidget(
        drag: _controller,
        threshold: widget.threshold,
        dragCap: widget.dragCap,
        icon: widget.icon,
        panelColor: theme.colorScheme.primaryContainer,
        armedPanelColor: theme.colorScheme.tertiaryContainer,
        iconColor: theme.colorScheme.onPrimaryContainer,
        armedIconColor: theme.colorScheme.onTertiaryContainer,
        child: widget.child,
      ),
    );
  }
}

/// A proxy widget that bridges the stateful wrapper with the underlying high-performance [RenderBox].
class _SwipeRevealRenderWidget extends SingleChildRenderObjectWidget {
  const _SwipeRevealRenderWidget({
    required this.drag,
    required this.threshold,
    required this.dragCap,
    required this.icon,
    required this.panelColor,
    required this.armedPanelColor,
    required this.iconColor,
    required this.armedIconColor,
    required Widget child,
  }) : super(child: child);

  final Animation<double> drag;
  final double threshold;
  final double dragCap;
  final IconData icon;
  final Color panelColor;
  final Color armedPanelColor;
  final Color iconColor;
  final Color armedIconColor;

  @override
  _RenderSwipeReveal createRenderObject(BuildContext context) {
    return _RenderSwipeReveal(
      drag: drag,
      threshold: threshold,
      dragCap: dragCap,
      icon: icon,
      panelColor: panelColor,
      armedPanelColor: armedPanelColor,
      iconColor: iconColor,
      armedIconColor: armedIconColor,
    );
  }

  @override
  void updateRenderObject(BuildContext context, _RenderSwipeReveal renderObject) {
    renderObject
      ..drag = drag
      ..threshold = threshold
      ..dragCap = dragCap
      ..icon = icon
      ..panelColor = panelColor
      ..armedPanelColor = armedPanelColor
      ..iconColor = iconColor
      ..armedIconColor = armedIconColor;
  }
}

/// A custom render object that handles translation and painting completely isolated
/// from layout passes, eliminating widget reconstruction overhead during active drags.
class _RenderSwipeReveal extends RenderProxyBox {
  _RenderSwipeReveal({
    required Animation<double> drag,
    required double threshold,
    required double dragCap,
    required IconData icon,
    required Color panelColor,
    required Color armedPanelColor,
    required Color iconColor,
    required Color armedIconColor,
  }) : _drag = drag,
       _threshold = threshold,
       _dragCap = dragCap,
       _icon = icon,
       _panelColor = panelColor,
       _armedPanelColor = armedPanelColor,
       _iconColor = iconColor,
       _armedIconColor = armedIconColor {
    _iconPainter = TextPainter(textDirection: TextDirection.ltr);
  }

  static const double _cornerRadius = 100.0;
  static const double _iconFontSize = 20.0;
  static const double _panelGap = 4.0;

  late final TextPainter _iconPainter;

  Animation<double> _drag;
  Animation<double> get drag => _drag;
  set drag(Animation<double> value) {
    if (identical(_drag, value)) return;
    if (attached) _drag.removeListener(markNeedsPaint);
    _drag = value;
    if (attached) _drag.addListener(markNeedsPaint);
    markNeedsPaint();
  }

  double _threshold;
  set threshold(double value) {
    if (_threshold == value) return;
    _threshold = value;
    markNeedsPaint();
  }

  double _dragCap;
  set dragCap(double value) {
    if (_dragCap == value) return;
    _dragCap = value;
    markNeedsPaint();
  }

  IconData _icon;
  set icon(IconData value) {
    if (_icon == value) return;
    _icon = value;
    markNeedsPaint();
  }

  Color _panelColor;
  set panelColor(Color value) {
    if (_panelColor == value) return;
    _panelColor = value;
    markNeedsPaint();
  }

  Color _armedPanelColor;
  set armedPanelColor(Color value) {
    if (_armedPanelColor == value) return;
    _armedPanelColor = value;
    markNeedsPaint();
  }

  Color _iconColor;
  set iconColor(Color value) {
    if (_iconColor == value) return;
    _iconColor = value;
    markNeedsPaint();
  }

  Color _armedIconColor;
  set armedIconColor(Color value) {
    if (_armedIconColor == value) return;
    _armedIconColor = value;
    markNeedsPaint();
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _drag.addListener(markNeedsPaint);
  }

  @override
  void detach() {
    _drag.removeListener(markNeedsPaint);
    super.detach();
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    if (child == null) return false;
    return result.addWithPaintOffset(
      offset: Offset(_drag.value, 0),
      position: position,
      hitTest: (BoxHitTestResult result, Offset transformed) {
        return child!.hitTest(result, position: transformed);
      },
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child == null) return;

    final value = _drag.value;
    if (value <= 0.5) {
      context.paintChild(child!, offset);
      return;
    }

    final childOffset = offset + Offset(value, 0);
    context.paintChild(child!, childOffset);

    final childSize = child!.size;

    final panelLeft = offset.dx;
    final panelWidth = (value - _panelGap).clamp(0.0, double.infinity);
    if (panelWidth <= 0) return;
    final panelRect = Rect.fromLTWH(panelLeft, offset.dy, panelWidth, childSize.height);

    final progress = (value / _dragCap).clamp(0.0, 1.0);
    final armedRange = (_dragCap - _threshold).clamp(1.0, double.infinity);
    final armedProgress = value >= _threshold
        ? ((value - _threshold) / armedRange).clamp(0.0, 1.0)
        : 0.0;

    final bgColor = Color.lerp(_panelColor, _armedPanelColor, armedProgress)!;
    final rrect = RRect.fromRectAndRadius(panelRect, const Radius.circular(_cornerRadius));
    context.canvas.drawRRect(rrect, Paint()..color = bgColor);

    final iconColor = Color.lerp(_iconColor, _armedIconColor, armedProgress)!;
    _iconPainter
      ..text = TextSpan(
        text: String.fromCharCode(_icon.codePoint),
        style: TextStyle(
          fontFamily: _icon.fontFamily,
          package: _icon.fontPackage,
          fontSize: _iconFontSize,
          color: iconColor.withValues(alpha: progress),
        ),
      )
      ..layout();

    context.canvas.save();
    context.canvas.clipRect(panelRect);
    _iconPainter.paint(
      context.canvas,
      panelRect.center - Offset(_iconPainter.width / 2, _iconPainter.height / 2),
    );
    context.canvas.restore();
  }
}
