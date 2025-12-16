import 'package:flutter/material.dart';

import '../../utils/app_style.dart';

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({super.key
    , this.message = 'Are you sure you want to delete?'
    , this.boxHeading = 'Confirm'
    , required this.callback
    , this.itemName
  });
  final String message;
  final String boxHeading;
  final VoidCallback callback;
  final dynamic itemName;

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
      title: Text(boxHeading, style: Styles.appBarHeading,),
      //content: Text(message, style: Styles.alertBoxMsg,)
      content: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: itemName != null && itemName!.isNotEmpty
                  ? 'Are you sure you want to delete '
                  : 'Are you sure you want to delete?'  // Default message
              , style: Styles.alertBoxMsg,
            ),
            if (itemName != null && itemName!.isNotEmpty)
              TextSpan(
                text: itemName,  // Display the item name in bold if available
                style: Styles.alertBoxItem,
              ),
            TextSpan(
              text: itemName != null && itemName!.isNotEmpty ? '?' : ''  // Add the question mark only if itemName exists
              , style: Styles.alertBoxMsg,
            ),
          ],
        ),
      ),
      actions: [
        cancelButton(context),
        continueButton(context),
      ],
    );
  }
}
