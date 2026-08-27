import 'package:flutter/material.dart';

class AppMessenger {
  static ScaffoldMessengerState of(BuildContext context) =>
      ScaffoldMessenger.of(context);

  static void showSuccess(BuildContext context, String message) {
    of(context).showSnackBar(
      SnackBar(
        content: Row(children: [
          Icon(Icons.check_circle, color: Colors.white),
          SizedBox(width: 8),
          Text(message),
        ]),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.all(16),
      ),
    );
  }

  static void showError(BuildContext context, String message) {
    of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

