// my_button.dart
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final VoidCallback onTap;
  final String buttonText;
  final Color color;
  final double? elevation;
  final TextStyle? textStyle;

  const MyButton({
    super.key,
    required this.onTap,
    required this.buttonText,
    this.color = Colors.blueAccent,
    this.elevation,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: buttonText,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          backgroundColor: color,
          elevation: elevation ?? 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: onTap,
        child: Text(
          buttonText,
          style: textStyle ??
              const TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
    );
  }
}