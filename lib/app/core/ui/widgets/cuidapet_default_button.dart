// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../extensions/theme_extension.dart';

class CuidapetDefaultButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? color;
  final double borderRadius;
  final double labelSize;
  final String label;
  final Color? labelColor;
  final double padding;
  final double wigth;
  final double height;

  const CuidapetDefaultButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.labelColor,
    this.labelSize = 20,
    this.borderRadius = 10,
    this.color,
    this.padding = 10,
    this.wigth = double.infinity,
    this.height = 66,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding),
      width: wigth,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          backgroundColor: color ?? context.primaryColor,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: labelSize,
            color: labelColor ?? Colors.white,
          ),
        ),
      ),
    );
  }
}
