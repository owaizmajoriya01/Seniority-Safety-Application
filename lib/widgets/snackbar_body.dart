import 'package:elderly_care/widgets/ripple_effect_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class MySnackBarBody extends StatelessWidget {
  final bool success;
  final String? message;

  const MySnackBarBody({Key? key, required this.success, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: const Color(0xff333333)),
        child: Row(
          children: [
            success
                ? const Icon(
              Icons.check,
              color: Colors.green,
            )
                : const Icon(
              Icons.close_rounded,
              color: Colors.red,
            ),

            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                message ?? "Some Error Occurred",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
            //SvgPicture.asset("assets/new_cross_sign.svg"),
            MyRippleEffectWidget(
              onTap: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
              child: const Icon(Icons.close_rounded, color: Colors.white, size: 16),
            )
          ],
        ));
  }
}