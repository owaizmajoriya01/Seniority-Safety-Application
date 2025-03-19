import 'package:flutter/material.dart';

import '../widgets/loading_dialog.dart';

class MyLoadingDialog {
  static bool _isShowingDialog = false;


  static bool get isDialogVisible => _isShowingDialog;

  static String get _defaultDialogMessage => "Loading....";


  static show(BuildContext context, String? message) {
    _isShowingDialog = true;
    showDialog(
        context: context,
        useRootNavigator: false,
        barrierDismissible: false,
        builder: (context) => LoadingDialogBody(message: message ?? _defaultDialogMessage))
        .then((value) => _isShowingDialog = false);
  }

  ///close dialog, if it is visible.
  static Future<bool> close(BuildContext context) async {
    if (_isShowingDialog) {
      var result = await Navigator.maybePop(context);
      return result;
      //close dialog
    }
    return false;
  }
}
