import 'package:flutter/material.dart';

class MyRippleEffectWidget extends StatelessWidget {
  ///callback function when tap is received.
  final void Function()? onTap;

  ///border radius of ripple effect
  final double borderRadius;
  final Widget child;

  /// ripple color;
  final Color? splashColor;

  final Clip chipBehavior;

  ///decoration for ink widget.
  ///
  /// instead of passing container with decoration in [child], use [decoration] to decorate.
  final Decoration? decoration;

  const MyRippleEffectWidget(
      {Key? key,
        this.onTap,
        this.borderRadius = 5,
        required this.child,
        this.chipBehavior = Clip.none,
        this.decoration,
        this.splashColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        type: MaterialType.transparency,
        clipBehavior: chipBehavior,
        child: InkWell(
            borderRadius: BorderRadius.circular(borderRadius),
            onTap: onTap,
            splashColor: splashColor,
            highlightColor: Colors.transparent,
            child: Ink(
              decoration: decoration,
              child: child,
            )));
  }
}