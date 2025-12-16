import 'package:flutter/material.dart';
import '../utils/app_style.dart';

class SnackbarHelper {
  // Show success snackbar
  static void showSuccess(
      BuildContext context,
      String message, {
        VoidCallback? onDismissed, // Callback for when the snackbar is dismissed
      }) {
    _showSnackbar(context, message, Styles.colorSuccess, onDismissed);
  }

  // Show error snackbar
  static void showError(
      BuildContext context,
      String message, {
        VoidCallback? onDismissed, // Callback for when the snackbar is dismissed
      }) {
    _showSnackbar(context, message, Styles.colorError, onDismissed);
  }

  // Private method to show snackbar
  static void _showSnackbar(
      BuildContext context,
      String message,
      Color color,
      VoidCallback? onDismissed,
      ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.yellow,
          onPressed: () {
            // Manually dismiss the snackbar
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    ).closed.then((reason) {
      // Trigger the callback when the snackbar is dismissed
      if (onDismissed != null) {
        onDismissed();
      }
    });
  }
}
