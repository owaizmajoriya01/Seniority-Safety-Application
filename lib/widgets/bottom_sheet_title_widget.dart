import 'package:flutter/material.dart';

import '../my_theme.dart';

class BottomSheetTitleWidget extends StatelessWidget {
  final String title;
  final void Function()? onCloseTap;

  const BottomSheetTitleWidget({
    Key? key,
    required this.title,
    this.onCloseTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          width: 56,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: MyTheme.black_34, fontWeight: FontWeight.w500),
            ),
          ),
        ),
        GestureDetector(
          onTap: onCloseTap ??
              () {
                Navigator.pop(context);
              },
          child: Container(
              color: Colors.transparent,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: const Icon(
                Icons.cancel,
                size: 20,
                color: MyTheme.black_85,
              )),
        )
      ],
    );
  }
}
