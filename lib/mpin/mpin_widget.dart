import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mpin_flutter/mpin/mpin_animation.dart';

class MpinController {
  late void Function(String) addInput;
  late void Function() delete;
  late void Function() notifyWrongInput;
}

class MpinWidget extends StatefulWidget {
  const MpinWidget(
      {Key? key,
      required this.pinLength,
      required this.controller,
      required this.onCompleted})
      : assert(pinLength <= 5 && pinLength > 0),
        super(key: key);
  final int pinLength;
  final MpinController controller;
  final Function(String) onCompleted;

  @override
  _MpinWidgetState createState() => _MpinWidgetState(controller);
}

class _MpinWidgetState extends State<MpinWidget>
    with SingleTickerProviderStateMixin {
  late List<MpinAnimationController> _animationControllers;
  late AnimationController _wrongInputAnimationController;
  late Animation<double> _wiggleAnimation;

  String mPin = '';

  _MpinWidgetState(MpinController controller) {
    controller.addInput = addInput;
    controller.delete = delete;
    controller.notifyWrongInput = notifyWrongInput;
  }

  void addInput(String input) async {
    mPin += input;

    if (mPin.length < widget.pinLength) {
      _animationControllers[mPin.length - 1].animate(input);
    } else if (mPin.length == widget.pinLength) {
      _animationControllers[mPin.length - 1].animate(input);
      await Future.delayed(Duration(milliseconds: 300));
      widget.onCompleted.call(mPin);
      mPin = '';
    }
  }

  void delete() {
    if (mPin.isNotEmpty) {
      mPin = mPin.substring(0, mPin.length - 1);
      _animationControllers[mPin.length].animate('');
    }
  }

  void notifyWrongInput() {
    _wrongInputAnimationController.forward();
    _animationControllers.forEach((controller) {
      controller.clear();
    });
  }

  @override
  void initState() {
    super.initState();
    _animationControllers = List.generate(widget.pinLength, (index) {
      return MpinAnimationController();
    });

    _wrongInputAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _wrongInputAnimationController.reverse();
        }
      });

    _wiggleAnimation = Tween<double>(begin: 0, end: 24.0).animate(
        CurvedAnimation(
            parent: _wrongInputAnimationController, curve: Curves.elasticIn));
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(_wiggleAnimation.value, 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(widget.pinLength, (index) {
          return MpinAnimation(
            controller: _animationControllers[index],
          );
        }),
      ),
    );
  }
}
