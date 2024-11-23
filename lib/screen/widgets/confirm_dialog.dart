import 'package:flutter/material.dart';

import '../../utils/app_style.dart';

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({Key? key
    , this.message = 'Are you sure you want to delete?'
    , this.boxHeading = 'Confirm'
    , required this.callback,
  }) : super(key: key);
  final String message;
  final String boxHeading;
  final VoidCallback callback;

  Widget cancelButton(BuildContext context) => TextButton(
    child: Text("Cancel", style: Styles.alertBoxBtn,),
    onPressed:  () {
      Navigator.of(context, rootNavigator: true).pop('dialog');
    },
  );
  Widget continueButton(BuildContext context) => TextButton(
    onPressed:  callback,
    child: Text("Continue", style: Styles.alertBoxBtn,),
  );

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(boxHeading, style: const TextStyle(
          fontWeight: FontWeight.w700
      ),),
      content: Text(message, style: Styles.alertBoxMsg,),
      actions: [
        cancelButton(context),
        continueButton(context),
      ],
    );
  }
}
