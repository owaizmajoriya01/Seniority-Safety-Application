import 'package:elderly_care/widgets/ripple_effect_widget.dart';
import 'package:flutter/material.dart';

import '../my_theme.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final TextStyle? textStyle;
  final Function()? onBackPress;
  final Function()? onBackComplete;
  final Widget? trailingWidget;
  final Widget? leadingWidget;
  final Color leadingWidgetColor;
  final Color textColor;
  final Color appBarColor;
  final bool showLeadingWidget;
  final bool centerTitle;
  final double elevation;

  const MyAppBar(
      {Key? key,
      required this.title,
      this.textStyle,
      this.onBackPress,
      this.trailingWidget,
      this.leadingWidget,
      this.showLeadingWidget = true,
      this.leadingWidgetColor = const Color.fromRGBO(102, 102, 102, 1),
      this.textColor = MyTheme.secondaryAccentColor,
      this.centerTitle = false,
      this.onBackComplete,
      this.elevation = 1,
      this.appBarColor = MyTheme.whiteScaffoldColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).viewPadding.top;
    return Container(
      height: kToolbarHeight + statusBarHeight,
      padding: EdgeInsets.fromLTRB(12, statusBarHeight, 20, 0),
      decoration: BoxDecoration(color: appBarColor, boxShadow: _shadow),
      child: Row(
        children: [
          if (showLeadingWidget)
            MyRippleEffectWidget(
                borderRadius: 32,
                onTap: () {
                  if (onBackPress != null) {
                    onBackPress?.call();
                    onBackComplete?.call();
                  } else {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    } else {
                      Navigator.of(context, rootNavigator: true).pop();
                    }
                    onBackComplete?.call();
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 24, maxHeight: 24),
                    child: leadingWidget ??
                        Icon(
                          Icons.arrow_back_rounded,
                          color: leadingWidgetColor,
                        ),
                  ),
                ))
          else
            const SizedBox(
              width: 40,
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                title,
                textAlign: centerTitle ? TextAlign.center : TextAlign.start,
                style: textStyle ?? TextStyle(fontWeight: FontWeight.w600, fontSize: 18, color: textColor),
              ),
            ),
          ),
          trailingWidget ??
              const SizedBox(
                width: 40,
              )
        ],
      ),
    );
  }

  List<BoxShadow>? get _shadow {
    if (elevation == 0) {
      return null;
    } else {
      return [BoxShadow(color: MyTheme.shadowColor, blurRadius: 12.0, offset: Offset(0, elevation))];
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
