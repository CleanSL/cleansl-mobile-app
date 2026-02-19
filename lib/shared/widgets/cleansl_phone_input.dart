import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class CleanSlPhoneInput extends StatelessWidget {
  // It's good practice to allow passing a controller so you can grab the text later!
  final TextEditingController? controller;

  const CleanSlPhoneInput({
    super.key,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.phone,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppTheme.textColor,
            fontWeight: FontWeight.w400,
          ),
      decoration: InputDecoration(
        hintText: "77 123 4567",
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 12.0, right: 8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.phone_android_rounded, color: AppTheme.accentColor),
              const SizedBox(width: 8),
              Text(
                "+94",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppTheme.textColor,
                      fontWeight: FontWeight.w400,
                    ),
              ),
              const SizedBox(width: 12),
              Container(
                height: 24, 
                width: 1, 
                color: AppTheme.secondaryColor1.withValues(alpha: 0.2),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
        filled: true,
        fillColor: AppTheme.primaryBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0), 
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0), 
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide(
            color: AppTheme.accentColor.withValues(alpha: 0.5), 
            width: 1,
          ),
        ),
      ),
    );
  }
}