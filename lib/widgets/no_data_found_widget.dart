import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NoDataFound extends StatelessWidget {
  const NoDataFound({Key? key, this.message, this.textStyle, this.imageSize}) : super(key: key);

  final String? message;
  final TextStyle? textStyle;
  final Size? imageSize;

  TextStyle get _textStyle =>
      textStyle ?? const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87);

  Size get _imageSize => imageSize ?? const Size(256, 256);

  @override
  Widget build(BuildContext context) {
    return Column(
      //mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SvgPicture.asset(
          "assets/svgs/no_data.svg",
          fit: BoxFit.contain,
          height: _imageSize.height,
          width: _imageSize.width,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0, bottom: 32),
          child: Text(
            message ?? "No Items Found",
            style: _textStyle,
          ),
        )
      ],
    );
  }
}
