import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double height;
  final List<Color> gradientColors;
  final double borderRadius;
  final EdgeInsets padding;
  final double fontSize;
  final FontWeight fontWeight;
  final RxBool isLoading; // Changed to RxBool

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.height = 50.0,
    this.gradientColors = const [
      Color(0xFF4776E6),
      Color(0xFF8E54E9),
    ],
    this.borderRadius = 8.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0),
    this.fontSize = 16.0,
    this.fontWeight = FontWeight.w600,
    required this.isLoading, // Made required since we need the RxBool instance
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Container(
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: gradientColors.last.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: Obx(() => InkWell( // Wrap with Obx for reactivity
            onTap: isLoading.value ? null : onPressed, // Use .value to access RxBool
            borderRadius: BorderRadius.circular(32),
            child: Center(
              child: isLoading.value // Use .value to access RxBool
                  ? SizedBox(
                      height: height * 0.5,
                      width: height * 0.5,
                      child: const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 3,
                      ),
                    )
                  : Text(
                      text,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: fontSize,
                        fontWeight: fontWeight,
                      ),
                    ),
            ),
          )),
        ),
      ),
    );
  }
}