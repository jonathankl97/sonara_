import 'package:flutter/material.dart';
import 'package:sonara/core/exceptions/app_exception.dart';

void showErrorSnackbar(BuildContext context, Object error) {
  final message = error is AppException
      ? error.message
      : 'Ein unbekannter Fehler ist aufgetreten.';

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: const Color(0xFFFF453A),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );
}