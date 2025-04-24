/* lib/Widgets/snackbar.dart */
import 'package:flutter/material.dart';

/*
  Displays a SnackBar with a custom message and optional parameters.
    [context]: BuildContext to display the SnackBar.
    [message]: The text message to display.
    [duration]: Optional duration for how long the SnackBar should be visible.
    [backgroundColor]: Optional background color for the SnackBar.
    [action]: Optional SnackBarAction for an additional interactive button.
*/
void showSnackBar(
  BuildContext context,
  String message, {
  Duration duration = const Duration(seconds: 10),
  Color? backgroundColor,
  SnackBarAction? action,
}) {
  final snackBar = SnackBar(
    content: Text(message),
    duration: duration,
    backgroundColor: backgroundColor,
    action: action,
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}