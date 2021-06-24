import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MpinAnimationController {
  late void Function(String input) animate;
  late void Function() clear;
}

class MpinAnimation extends StatefulWidget {
  final MpinAnimationController controller;

  const MpinAnimation({Key? key, required this.controller}) : super(key: key);
  @override
  _MpinAnimationState createState() => _MpinAnimationState(controller);
}

class _MpinAnimationState extends State<MpinAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sizeAnimation;
  late Animation<double> _opacityAnimation;
  String pin = '';

  void animate(String input) {
    _controller.forward();
    setState(() {
      pin = input;
    });
  }

  void clear() {
    setState(() {
      pin = '';
    });
  }

  _MpinAnimationState(controller) {
    controller.animate = animate;
    controller.clear = clear;
  }
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    _controller.addListener(() {
      if (_controller.status == AnimationStatus.completed) {
        _controller.reverse();
      }
      setState(() {});
    });
    _sizeAnimation = Tween<double>(begin: 24, end: 72).animate(_controller);
    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      width: 48,
      alignment: Alignment.center,
      child: Container(
        height: _sizeAnimation.value,
        width: _sizeAnimation.value,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_sizeAnimation.value),
          color: pin == '' ? Colors.white54 : Colors.white,
        ),
        child: Center(
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Transform.scale(
              scale: _sizeAnimation.value / 48,
              child: Text(
                pin,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
