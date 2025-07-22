import 'package:flutter/material.dart';
import 'package:edunjema3/utils/constants.dart';

/// A customizable button widget with predefined styling.
class CustomButton extends StatelessWidget {
  /// The text displayed on the button.
  final String text;
  /// The callback function executed when the button is pressed. Can be null to disable the button.
  final VoidCallback? onPressed; // Made nullable
  /// Optional background color for the button. Defaults to [AppConstants.primaryColor].
  final Color? color;
  /// Optional text color for the button. Defaults to [AppConstants.buttonTextStyle.color].
  final Color? textColor;
  /// Optional padding for the button's content. Defaults to [EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0)].
  final EdgeInsetsGeometry? padding;
  /// Optional border radius for the button. Defaults to [BorderRadius.circular(8.0)].
  final BorderRadiusGeometry? borderRadius;
  /// Whether the button is currently in a loading state, showing a progress indicator.
  final bool isLoading;

  /// Creates a [CustomButton].
  const CustomButton({
    super.key,
    required this.text,
    this.onPressed, // Now nullable
    this.color,
    this.textColor,
    this.padding,
    this.borderRadius,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed, // Disable button when loading or if onPressed is null
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? AppConstants.primaryColor,
        foregroundColor: textColor ?? AppConstants.buttonTextStyle.color,
        padding: padding ?? const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(8.0),
        ),
        elevation: 3, // Add a subtle shadow
      ),
      child: isLoading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : Text(
              text,
              style: AppConstants.buttonTextStyle.copyWith(color: textColor ?? AppConstants.buttonTextStyle.color),
            ),
    );
  }
}
