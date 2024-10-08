import 'package:flutter/material.dart';

class CustomRadioButton extends StatelessWidget {
  final String title;
  final dynamic groupValue;
  final Function(dynamic) onChanged;

  const CustomRadioButton({
    Key? key,
    required this.title,
    required this.groupValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RadioListTile(
      title: Text(title),
      value: title,
      groupValue: groupValue,
      onChanged: onChanged,
      controlAffinity:
          ListTileControlAffinity.leading, // Radio button on the left
    );
  }
}
