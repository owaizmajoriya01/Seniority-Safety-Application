import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InfoWidget extends StatelessWidget {
  const InfoWidget({Key? key, required this.title, required this.value, this.icon}) : super(key: key);

  final String title;
  final String value;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        children: [
          if (icon != null)
            Container(
                decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
                padding: const EdgeInsets.all(4),
                margin: const EdgeInsets.only(right: 6),
                child: icon!),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value,
                    style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87)),
                Text(title,
                    style:
                        GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w400, color: const Color(0xff515151))),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class KeyPairWidget extends StatelessWidget {
  const KeyPairWidget({Key? key, required this.title, required this.value, this.icon, this.iconColor})
      : super(key: key);

  final String title;
  final String value;
  final Widget? icon;

  ///default color is Colors.black
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          if (icon != null)
            Container(
                decoration: BoxDecoration(color: iconColor ?? Colors.black, shape: BoxShape.circle),
                padding: const EdgeInsets.all(4),
                margin: const EdgeInsets.only(right: 6),
                child: icon!),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value,
                    style: GoogleFonts.inter(
                        fontSize: 12, fontWeight: FontWeight.w600, color: const Color.fromRGBO(51, 51, 51, 1))),
                Text(title,
                    style:
                        GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w400, color: const Color(0xff515151))),
              ],
            ),
          )
        ],
      ),
    );
  }
}
