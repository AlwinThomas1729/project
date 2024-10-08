import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final Function(String) onChanged;
  final TextInputType? keyboardType; // Added optional keyboardType parameter

  const CustomTextField({
    super.key,
    required this.onChanged,
    this.keyboardType, // Initialize the keyboardType
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      keyboardType: keyboardType, // Use the provided keyboardType
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
}
