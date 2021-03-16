import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BounceButton extends StatefulWidget {
  final void Function() onTap;

  final Widget child;

  BounceButton({
    Key key,
    @required this.child,
    this.onTap,
  }) : super(key: key);

  @override
  _BounceButtonState createState() => _BounceButtonState();
}

class _BounceButtonState extends State<BounceButton>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 25),
      lowerBound: 0.0,
      upperBound: 0.1,
    );
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double scale = 1 - _controller.value;
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: _onPointerDown,
      onPointerUp: _onPointerUp,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _onTap,
        child: Transform.scale(
          scale: scale,
          child: Container(
            child: widget.child,
          ),
        ),
      ),
    );
  }

  void _onPointerDown(PointerDownEvent event) {
    if (mounted) _controller?.forward();
  }

  void _onPointerUp(PointerUpEvent event) {
    if (mounted) _controller?.reverse();
  }

  void _onTap() {
    if (widget.onTap != null) widget.onTap();
    HapticFeedback.lightImpact();
  }
}
