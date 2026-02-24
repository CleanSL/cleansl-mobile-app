import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive.dart';

class CleanSlTextInput extends StatelessWidget {
  final String hintText;
  final bool isPassword;
  final TextEditingController? controller;
  final TextInputType? keyboardType;

  const CleanSlTextInput({
    super.key,
    required this.hintText,
    this.isPassword = false,
    this.controller,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    final double hPad = Responsive.w(context, AppTheme.space24);
    final double vPad = Responsive.h(context, 16);
    final double radius = Responsive.r(context, 30);

    return TextField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: Responsive.sp(context, 16)),
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: AppTheme.primaryBackground,
        contentPadding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(radius), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(radius), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(radius), borderSide: BorderSide.none),
      ),
    );
  }
}
