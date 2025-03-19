import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoadingDialogBody extends StatelessWidget {
  final String message;

  const LoadingDialogBody({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Material(
          type: MaterialType.transparency,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            margin: const EdgeInsets.only(left: 24.0, right: 24),
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const _Spinner(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10.0, 10, 10),
                  child: Text(
                    message,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: const Color.fromRGBO(102, 109, 128, 1),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Spinner extends StatelessWidget {
  const _Spinner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator(
      strokeWidth: 3,
      color: Color.fromRGBO(0, 82, 155, 1),
      backgroundColor: Color.fromRGBO(204, 172, 84, 0.2),
    );
  }
}
