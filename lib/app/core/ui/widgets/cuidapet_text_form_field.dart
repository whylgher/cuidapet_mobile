import 'package:flutter/material.dart';

import '../extensions/theme_extension.dart';

class CuidapetTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;

  final String label;
  final bool obscureText;
  final ValueNotifier<bool> _obscureTextVn;

  CuidapetTextFormField({
    Key? key,
    required this.label,
    this.obscureText = false,
    this.controller,
    this.validator,
  })  : _obscureTextVn = ValueNotifier<bool>(obscureText),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _obscureTextVn,
      builder: (_, obscureTextVnValue, child) {
        return TextFormField(
          controller: controller,
          obscureText: obscureTextVnValue,
          validator: validator,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(fontSize: 15, color: Colors.black),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              // gapPadding: 0,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              // gapPadding: 0,
              borderSide: const BorderSide(color: Colors.grey),
            ),
            suffixIcon: obscureText
                ? IconButton(
                    onPressed: () {
                      _obscureTextVn.value = !obscureTextVnValue;
                    },
                    icon:
                        Icon(obscureTextVnValue ? Icons.lock : Icons.lock_open),
                    color: context.primaryColor,
                  )
                : null,
          ),
        );
      },
    );
  }
}
