import 'package:flutter/material.dart';

import '/my_theme.dart';
import 'ripple_effect_widget.dart';

class PrimaryButton extends StatelessWidget {
  final void Function()? onPressed;
  final String text;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final TextStyle? textStyle;
  final double borderRadius;
  final bool enable;
  final bool shadowWhenDisabled;
  final String? disableText;
  final Color enableColor;
  final Color? disabledColor;
  final Color? textColor;
  final double disableColorOpacity;
  final BorderSide borderSide;
  final Widget? leadingWidget;
  final Widget? trailingWidget;
  final bool disableShadow;

  /// elevation of the button.
  ///
  /// default value is 8.
  final double elevation;

  /// [minimumSize]=[Size.fromHeight(0)]. this will create button with infinite width and height depending on its child height
  final Size? minimumSize; //minimum size for button

  ///for expanded button use [minimumSize]
  ///
  /// to show shadow in disabled state set [shadowWhenDisabled] to [true]
  const PrimaryButton(
      {Key? key,
      required this.onPressed,
      required this.text,
      this.margin = const EdgeInsets.only(left: 16, right: 16),
      this.padding = const EdgeInsets.fromLTRB(16, 10, 16, 10),
      this.textStyle,
      this.disableText,
      this.borderRadius = 6,
      this.enableColor = MyTheme.accentColor,
      this.disabledColor,
      this.enable = true,
      this.disableColorOpacity = 0.4,
      this.minimumSize,
      this.borderSide = BorderSide.none,
      this.leadingWidget,
      this.trailingWidget,
      this.shadowWhenDisabled = false,
      this.elevation = 8,
      this.textColor,
      this.disableShadow = false})
      : super(key: key);

  const PrimaryButton.expanded(
      {Key? key,
      required this.onPressed,
      required this.text,
      this.margin = const EdgeInsets.only(left: 16, right: 16),
      this.padding = const EdgeInsets.all(14),
      this.textStyle,
      this.disableText,
      this.borderRadius = 6,
      this.enableColor = MyTheme.accentColor,
      this.disabledColor,
      this.enable = true,
      this.disableColorOpacity = 0.4,
      this.borderSide = BorderSide.none,
      this.leadingWidget,
      this.trailingWidget,
      this.shadowWhenDisabled = false,
      this.elevation = 8,
      this.textColor,
      this.disableShadow = false})
      : minimumSize = const Size.fromHeight(0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: _getBoxDecoration(shadowWhenDisabled || enable),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
            //shadowColor: enableColor.withOpacity(0.3),
            //elevation: 14,
            padding: EdgeInsets.zero,
            minimumSize: minimumSize,
            backgroundColor: enable ? enableColor : disabledColor ?? enableColor.withOpacity(disableColorOpacity),
            shape: RoundedRectangleBorder(
              side: borderSide,
              borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
            )),
        child: Padding(
          padding: padding,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (leadingWidget != null) leadingWidget!,
              Flexible(
                  child: Text(
                enable ? text : disableText ?? text,
                style: textStyle ?? _defaultTextStyle(),
                overflow: TextOverflow.ellipsis,
              )),
              if (trailingWidget != null) trailingWidget!,
            ],
          ),
        ),
      ),
    );
  }

  _defaultTextStyle() {
    return TextStyle(fontSize: 14, color: textColor ?? Colors.white, fontWeight: FontWeight.w600);
  }

  BoxDecoration? _getBoxDecoration(bool showShadow) {
    if (showShadow && elevation != 0) {
      return BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: enableColor.withOpacity(0.3),
            blurRadius: 14.0,
            spreadRadius: 0,
            offset: Offset(0.0, elevation),
          ),
        ],
      );
    } else {
      return null;
    }
  }
}

class MyFlatButton extends StatelessWidget {
  final Function onPressed;
  final String text;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final TextStyle? textStyle;
  final double borderRadius;
  final bool enable;
  final String? disableText;
  final Color enableColor;
  final Color? disabledColor;
  final double disableColorOpacity;
  final BorderSide borderSide;
  final Widget? leadingWidget;
  final Widget? trailingWidget;

  final Size? minimumSize; //minimum size for button

  ///for expanded button use [minimumSize]
  ///
  ///eg [minimumSize]=[Size.fromHeight(0)]. this will create button with infinite width and height depending on its child height

  const MyFlatButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.margin = const EdgeInsets.only(left: 16, right: 16),
    this.padding = const EdgeInsets.all(14),
    this.textStyle,
    this.disableText,
    this.borderRadius = 10,
    this.enableColor = MyTheme.lightGray,
    this.disabledColor,
    this.enable = true,
    this.disableColorOpacity = 0.4,
    this.minimumSize,
    this.borderSide = BorderSide.none,
    this.leadingWidget,
    this.trailingWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: TextButton(
        onPressed: onPressed as void Function()?,
        style: TextButton.styleFrom(
            //shadowColor: enableColor.withOpacity(0.3),
            //elevation: 14,
            padding: EdgeInsets.zero,
            minimumSize: minimumSize,
            backgroundColor: enable ? enableColor : disabledColor ?? enableColor.withOpacity(disableColorOpacity),
            shape: RoundedRectangleBorder(
              side: borderSide,
              borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
            )),
        child: Padding(
          padding: padding,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (leadingWidget != null) leadingWidget!,
              Flexible(
                  child: Text(
                enable ? text : disableText ?? text,
                style: textStyle ?? _defaultTextStyle(),
                overflow: TextOverflow.ellipsis,
              )),
              if (trailingWidget != null) trailingWidget!,
            ],
          ),
        ),
      ),
    );
  }

  _defaultTextStyle() {
    return const TextStyle(fontSize: 14, color: MyTheme.black_85, fontWeight: FontWeight.w600);
  }
}

class MyBorderElevatedButton extends StatelessWidget {
  final void Function() onPressed;
  final String text;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final TextStyle? textStyle;
  final double borderRadius;
  final bool enable;
  final bool shadowWhenDisabled;
  final String? disableText;
  final Color enableColor;
  final Color? disabledColor;
  final Color? textColor;
  final Color? shadowColor;
  final double disableColorOpacity;
  final BorderSide borderSide;
  final Widget? leadingWidget;
  final Widget? trailingWidget;
  final double? elevation;

  final Size? minimumSize; //minimum size for button

  ///for expanded button use [minimumSize]
  ///
  ///eg [minimumSize]=[Size.fromHeight(0)]. this will create button with infinite width and height depending on its child height
  ///
  /// to show in disabled state set [shadowWhenDisabled] to [true]
  const MyBorderElevatedButton(
      {Key? key,
      required this.onPressed,
      required this.text,
      this.margin = const EdgeInsets.only(left: 0, right: 0),
      this.padding = const EdgeInsets.symmetric(vertical: 14),
      this.textStyle,
      this.disableText,
      this.borderRadius = 10,
      this.enableColor = Colors.white,
      this.disabledColor,
      this.enable = true,
      this.disableColorOpacity = 0.4,
      this.minimumSize,
      this.borderSide = const BorderSide(color: Color.fromRGBO(204, 204, 204, 1), width: 1),
      this.leadingWidget,
      this.trailingWidget,
      this.shadowWhenDisabled = false,
      this.textColor,
      this.shadowColor = const Color(0x4dcccccc),
      this.elevation = 8})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: _getBoxDecoration(shadowWhenDisabled || enable),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
            //shadowColor: shadowColor ?? enableColor.withOpacity(0.3),
            //elevation: elevation,
            padding: EdgeInsets.zero,
            minimumSize: minimumSize,
            backgroundColor: enable ? enableColor : disabledColor ?? enableColor.withOpacity(disableColorOpacity),
            shape: RoundedRectangleBorder(
              side: borderSide,
              borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
            )),
        child: Padding(
          padding: padding,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (leadingWidget != null) leadingWidget!,
              Flexible(
                  child: Text(
                enable ? text : disableText ?? text,
                style: textStyle ?? _defaultTextStyle(),
                maxLines: 2,
                // overflow: TextOverflow.ellipsis,
              )),
              if (trailingWidget != null) trailingWidget!,
            ],
          ),
        ),
      ),
    );
  }

  _defaultTextStyle() {
    return TextStyle(fontSize: 14, color: textColor ?? MyTheme.primaryColor, fontWeight: FontWeight.w600);
  }

  BoxDecoration? _getBoxDecoration(bool showShadow) {
    if (showShadow) {
      return BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: shadowColor ?? enableColor.withOpacity(0.3),
            blurRadius: 14.0,
            spreadRadius: 0,
            offset: const Offset(0.0, 8.0),
          ),
        ],
      );
    } else {
      return null;
    }
  }
}

class MyIconButton extends StatelessWidget {
  const MyIconButton(
      {Key? key,
      required this.icon,
      this.padding,
      this.onTap,
      this.color,
      this.shape = BoxShape.circle,
      this.borderRadius = 6})
      : super(key: key);

  final Widget icon;

  ///default padding is 8 from all sides
  final EdgeInsets? padding;
  final VoidCallback? onTap;

  ///default color is Colors.blueGrey
  final Color? color;
  final BoxShape shape;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return MyRippleEffectWidget(
        onTap: onTap,
        decoration: BoxDecoration(
            color: color ?? Colors.blueGrey,
            shape: shape,
            borderRadius: shape == BoxShape.circle ? null : BorderRadius.circular(borderRadius)),
        borderRadius: shape == BoxShape.circle ? 100 : borderRadius,
        child: Padding(padding: padding ?? const EdgeInsets.all(8), child: icon));
  }
}

class MyRectangleIconButton extends StatelessWidget {
  const MyRectangleIconButton(
      {Key? key, required this.icon, this.padding, this.onTap, this.color, this.borderRadius = 6})
      : super(key: key);

  final Widget icon;

  ///default padding is 8 from all sides
  final EdgeInsets? padding;
  final VoidCallback? onTap;

  ///default color is Colors.blueGrey
  final Color? color;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return MyRippleEffectWidget(
        onTap: onTap,
        decoration: BoxDecoration(
          color: color ?? Colors.blueGrey,
          borderRadius: BorderRadius.circular(borderRadius),
          shape: BoxShape.rectangle,
        ),
        borderRadius: 100,
        child: Padding(padding: padding ?? const EdgeInsets.all(8), child: icon));
  }
}
