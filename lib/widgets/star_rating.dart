import 'package:flutter/material.dart';

import '/my_theme.dart';
import 'textfield_v2.dart';

class StarRatingV2 extends StatefulWidget {
  const StarRatingV2(
      {Key? key,
      this.starCount = 5,
      this.initialRating = 0,
      this.onRatingChanged,
      this.ratingIconColor = MyTheme.golden,
      this.ratingIconSize = 16,
      this.isReadOnly = true,
      this.ratingIcons})
      : super(key: key);

  /// number of stars in this widget
  ///
  /// default is 5.
  final int starCount;

  /// initial rating of this widget
  ///
  /// default value is 0.
  final double initialRating;

  //callback function when rating is changed.
  final void Function(double rating)? onRatingChanged;

  ///rating's icon color
  ///
  /// default is [MyColors.yellowColor]
  final Color ratingIconColor;

  ///icon size of rating icon
  ///
  ///default value is 16.
  final double ratingIconSize;

  ///removes onTap listeners if [isReadOnly] is true.
  final bool isReadOnly;

  ///rating icons for "empty", "half" and "full" state
  ///
  ///Icons in [ratingIcons] will ignore [ratingIconColor] and [ratingIconSize].
  ///
  ///
  final MyRatingIcon? ratingIcons;

  @override
  State<StarRatingV2> createState() => _StarRatingV2State();
}

class _StarRatingV2State extends State<StarRatingV2> {
  double rating = 0;

  @override
  void initState() {
    super.initState();
    rating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: List.generate(widget.starCount, (index) => buildStar(context, index)));
  }

  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    if (index >= rating) {
      icon = widget.ratingIcons?.empty ??
          Icon(
            Icons.star_border_outlined,
            color: const Color(0x1a000000),
            size: widget.ratingIconSize,
          );
    } else if (index > rating - 1 && index < rating) {
      icon = widget.ratingIcons?.half ??
          Icon(
            Icons.star_half,
            color: widget.ratingIconColor,
            size: widget.ratingIconSize,
          );
    } else {
      icon = widget.ratingIcons?.full ??
          Icon(
            Icons.star,
            color: widget.ratingIconColor,
            size: widget.ratingIconSize,
          );
    }

    if (widget.isReadOnly) {
      return icon;
    } else {
      return InkResponse(
        onTap: () {
          setState(() {
            rating = index + 1;
          });

          widget.onRatingChanged?.call(rating);
        },
        radius: _rippleRadius,
        child: icon,
      );
    }
  }

  double get _rippleRadius => widget.ratingIconSize * 0.6;
}

class MyRatingIcon {
  MyRatingIcon({required this.empty, required this.half, required this.full});

  // should we use image path instead of "Icon"?
  final Icon empty;
  final Icon half;
  final Icon full;
}

class StarWithTextField extends StatefulWidget {
  const StarWithTextField(
      {Key? key,
      this.starCount = 5,
      this.initialRating = 2,
      this.onRatingChanged,
      this.ratingIconColor = MyTheme.golden,
      this.ratingIconSize = 24,
      required this.isReadOnly,
      this.ratingIcons, this.controller,
      this.textFieldThreshold = 1,
      this.textFieldvalidator,
      this.autoValidateMode, this.onSaved})
      : super(key: key);

  final int starCount;
  final double initialRating;
  final void Function(double rating)? onRatingChanged;
  final void Function(String? onSaved)? onSaved;
  final Color ratingIconColor;
  final double ratingIconSize;
  final bool isReadOnly;
  final MyRatingIcon? ratingIcons;
  final String? Function(String?)? textFieldvalidator;

  ///rating at which textField should be visible
  ///
  /// default value is 1
  final double textFieldThreshold;
  final TextEditingController? controller;
  final AutovalidateMode? autoValidateMode;

  @override
  State<StarWithTextField> createState() => _StarWithTextFieldState();
}

class _StarWithTextFieldState extends State<StarWithTextField> {
  double _rating = 0.0;

  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StarRatingV2(
          starCount: widget.starCount,
          initialRating: widget.initialRating,
          onRatingChanged: (double rating) {
            widget.onRatingChanged?.call(rating);
            _rating = rating;
            setState(() {});
          },
          ratingIconColor: widget.ratingIconColor,
          ratingIconSize: widget.ratingIconSize,
          isReadOnly: widget.isReadOnly,
          ratingIcons: widget.ratingIcons,
        ),
        if (_rating <= widget.textFieldThreshold)
          Padding(
            padding: const EdgeInsets.only(top:6.0),
            child: MyTextFieldV2(
              autoValidateMode: widget.autoValidateMode,
              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              hintText: "Remark",
              labelText: "Remark",
              controller: widget.controller,
              validator: widget.textFieldvalidator,
              onSaved: widget.onSaved,
            ),
          )
      ],
    );
  }
}
