import 'package:flutter/material.dart';

import 'buttons.dart';


class InfoDialog extends StatelessWidget {
  const InfoDialog(
      {Key? key, this.header, this.message, this.onPositiveTap, this.onNegativeTap, this.showDialogType = false})
      : super(key: key);

  final String? header;
  final String? message;
  final void Function()? onPositiveTap;
  final void Function()? onNegativeTap;
  final bool showDialogType;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: Alignment.center,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      //clipBehavior: Clip.hardEdge,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
              color: Colors.blueAccent,
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  color: Colors.white,
                  size: 64,
                ),
                if (showDialogType)
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      "Info Dialog",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: Colors.white),
                    ),
                  )
              ],
            ),
          ),
          if (header != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Text(
                header!,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black87),
              ),
            ),
          if (message != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 2, 16, 0),
              child: Text(message!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black87)),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 32, 0, 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Spacer(),
                PrimaryButton(
                  borderRadius: 4,
                  enableColor: Colors.red,
                  onPressed: onNegativeTap,
                  text: "No",
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                ),
                PrimaryButton(
                    borderRadius: 4,
                    enableColor: Colors.green,
                    onPressed: onPositiveTap,
                    text: "Yes",
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SuccessDialog extends StatelessWidget {
  const SuccessDialog({Key? key, this.header, this.message, this.onNeutralTap, this.showDialogType = false})
      : super(key: key);

  final String? header;
  final String? message;
  final void Function()? onNeutralTap;

  final bool showDialogType;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: Alignment.center,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      //clipBehavior: Clip.hardEdge,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
              color: Colors.green,
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                const Icon(
                  Icons.check_circle_outline_rounded,
                  color: Colors.white,
                  size: 64,
                ),
                if (showDialogType)
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      "Success Dialog",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: Colors.white),
                    ),
                  )
              ],
            ),
          ),
          if (header != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                header!,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black87),
              ),
            ),
          if (message != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 2, 16, 0),
              child: Text(message!,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black87)),
            ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 32, 0, 24),
              child: PrimaryButton(
                borderRadius: 4,
                enableColor: Colors.green,
                onPressed: onNeutralTap ?? () => Navigator.pop(context),
                text: "OK",
                textStyle: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white, letterSpacing: 0.9),
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ErrorDialog extends StatelessWidget {
  const ErrorDialog({Key? key, this.header, this.message, this.onNeutralTap, this.showDialogType = false})
      : super(key: key);

  final String? header;
  final String? message;
  final void Function()? onNeutralTap;

  final bool showDialogType;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: Alignment.center,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      //clipBehavior: Clip.hardEdge,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
              color: Colors.red,
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                const Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                  size: 64,
                ),
                if (showDialogType)
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      "Error Dialog",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: Colors.white),
                    ),
                  )
              ],
            ),
          ),
          if (header != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Text(
                header!,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black87),
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 2, 16, 0),
            child: Text(message ?? "Some Error Occurred",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black87)),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 32, 0, 24),
              child: PrimaryButton(
                borderRadius: 4,
                enableColor: Colors.red,
                onPressed: onNeutralTap ?? () => Navigator.pop(context),
                text: "OK",
                textStyle: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white, letterSpacing: 0.9),
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InfoDialog2 extends StatelessWidget {
  const InfoDialog2({Key? key, this.header, this.message, this.onTap, this.showDialogType = false}) : super(key: key);

  final String? header;
  final String? message;
  final void Function()? onTap;
  final bool showDialogType;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: Alignment.center,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      //clipBehavior: Clip.hardEdge,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
              color: Colors.blueAccent,
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  color: Colors.white,
                  size: 64,
                ),
                if (showDialogType)
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      "Info Dialog",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: Colors.white),
                    ),
                  )
              ],
            ),
          ),
          if (header != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Text(
                header!,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black87),
              ),
            ),
          if (message != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 2, 16, 0),
              child: Text(message!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black87)),
            ),
          Align(
            alignment: Alignment.bottomRight,
            child: PrimaryButton(
                margin: const EdgeInsets.fromLTRB(0, 16, 24, 24),
                borderRadius: 4,
                enableColor: Colors.blueAccent,
                onPressed: onTap,
                text: "OK",
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8)),
          ),
        ],
      ),
    );
  }
}
