import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum VerificationStatus { verified, notVerified, unKnown }

class VerificationChip extends StatelessWidget {
  const VerificationChip({Key? key, required this.status}) : super(key: key);
  final VerificationStatus status;

  @override
  Widget build(BuildContext context) {
    return MyChip(
      /* label: Text(_title, style: TextStyle(fontSize: 10, color: _chipTextColor, fontWeight: FontWeight.w600)),
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity(vertical: -3),
      labelPadding: EdgeInsets.fromLTRB(8, 0, 8, 0),
      shape: StadiumBorder(side: BorderSide(color: _chipBorderColor)),
      backgroundColor: _chipColor.withOpacity(0.5),*/
      text: _title,
      status: _chipStatus,
      icon: _icon,
    );
  }

  Widget? get _icon {
    switch (status) {
      case VerificationStatus.verified:
        return const Padding(
          padding: EdgeInsets.only(right: 4.0),
          child: Icon(
            Icons.verified_user,
            size: 16,
            color: Colors.green,
          ),
        );
      case VerificationStatus.notVerified:
      case VerificationStatus.unKnown:
        return null;
    }
  }

  String get _title {
    switch (status) {
      case VerificationStatus.verified:
        return "Verified";

      case VerificationStatus.notVerified:
        return "Not verified";

      case VerificationStatus.unKnown:
        return "Unknown";
    }
  }

  ///return [ChipStatus] based on [VerificationStatus]
  ChipStatus get _chipStatus {
    switch (status) {
      case VerificationStatus.verified:
        return ChipStatus.green;
      case VerificationStatus.notVerified:
        return ChipStatus.red;
      case VerificationStatus.unKnown:
        return ChipStatus.orange;
    }
  }
}

enum ChipStatus { green, orange, red, blue, grey }

class MyChip extends StatelessWidget {
  const MyChip(
      {Key? key, required this.status, this.text, this.textStyle, this.chipPadding, this.iconPadding, this.icon})
      : super(key: key);

  ///[status] is used to define chip color and chip text
  final ChipStatus status;

  ///default value of text is [status.name]
  final String? text;
  final TextStyle? textStyle;

  final EdgeInsets? chipPadding;
  final EdgeInsets? iconPadding;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    /* return RawChip(
      label: Text(_title, style: TextStyle(fontSize: 10, color: _chipTextColor, fontWeight: FontWeight.w600)),
      padding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity(vertical: -4),
      labelPadding: EdgeInsets.fromLTRB(8, 0, 8, 0),
      shape: StadiumBorder(side: BorderSide(color: _chipBorderColor)),
      backgroundColor: _chipColor.withOpacity(0.5),
      pressElevation: 0,
    );*/

    return Container(
      constraints: const BoxConstraints(minHeight: 28),
      decoration: BoxDecoration(
          color: _chipColor,
          //gradient: chipGradientColors != null ? LinearGradient(colors: chipGradientColors!) : null,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _chipBorderColor, width: 1)),
      padding: chipPadding ?? const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null)
            Padding(
              padding: iconPadding ?? EdgeInsets.zero,
              child: icon,
            ),
          Text(
            _title,
            style: textStyle ?? GoogleFonts.inter(fontWeight: FontWeight.w600, color: _chipTextColor, fontSize: 10),
          ),
        ],
      ),
    );
  }

  String get _title {
    if (text != null) return text!;
    switch (status) {
      case ChipStatus.green:
        return "Success";

      case ChipStatus.red:
        return "Fail";

      case ChipStatus.orange:
        return "Pending";
      case ChipStatus.blue:

      case ChipStatus.grey:
        return "Unknown";
    }
  }

  Color get _chipTextColor {
    switch (status) {
      case ChipStatus.orange:
        return const Color(0xFFF57F2A);
      case ChipStatus.green:
        return const Color(0xFF11BF0E);
      case ChipStatus.red:
        return const Color(0xFFFA4B4B);
      case ChipStatus.blue:
        return const Color(0xFF4BA3FA);
      case ChipStatus.grey:
        return const Color(0xFFFFFFFF);
    }
  }

  Color get _chipColor {
    switch (status) {
      case ChipStatus.orange:
        return const Color(0xFFFFEEE3);
      case ChipStatus.green:
        return const Color(0xFFE7F9E7);
      case ChipStatus.red:
        return const Color(0xFFFFEDED);
      case ChipStatus.blue:
        return const Color(0xFFEDEDFF);
      case ChipStatus.grey:
        return const Color(0xFFCDCDCD);
    }
  }

  Color get _chipBorderColor {
    switch (status) {
      case ChipStatus.orange:
        return const Color(0x1AF57F2A);
      case ChipStatus.green:
        return const Color(0x1A11BF0E);
      case ChipStatus.red:
        return const Color(0x1AFA4B4B);
      case ChipStatus.blue:
        return const Color(0x1A4BA3FA);
      case ChipStatus.grey:
        return const Color(0x1AF4F9FD);
    }
  }
}
