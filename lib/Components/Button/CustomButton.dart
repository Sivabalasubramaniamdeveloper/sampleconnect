import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../Utils/Constants/ColorConstants.dart';
import '../../Utils/Constants/TextStyle.dart';

enum ButtonType { elevated, outlined }

class CustomElevatedButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final double borderRadius;
  final Color textColor;
  final double elevation;
  final Gradient? gradient;
  final double? width;
  final double height;
  final ButtonType buttonType;
  final Color? outlineColor;

  const CustomElevatedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.borderRadius = 10.0,
    this.textColor = Colors.white,
    this.elevation = 5.0,
    this.gradient,
    this.width = 120.0,
    this.height = 40.0,
    this.buttonType = ButtonType.elevated,
    this.outlineColor,
  });

  @override
  State<CustomElevatedButton> createState() => _CustomElevatedButtonState();
}

class _CustomElevatedButtonState extends State<CustomElevatedButton> {
  @override
  Widget build(BuildContext context) {
    return  _buildNormalButton(context);
  }

  BoxDecoration _buildDecoration() {
    return BoxDecoration(
      gradient: widget.gradient ?? KConstantColors.bottomBoxWithPrimaryColor,
      borderRadius: BorderRadius.circular(widget.borderRadius),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.07),
          blurRadius: 10,
          spreadRadius: 1,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }

  Widget _buildLoadingButton() {
    return Container(
      width: widget.width?.w ?? 150.w,
      height: widget.height.h,
      decoration: widget.buttonType == ButtonType.elevated ? _buildDecoration() : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 20.h,
            width: 20.w,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(widget.textColor),
              strokeWidth: 3.0,
            ),
          ),
          SizedBox(width: 10.w),
          Text(
            "Loading...",
            style: TextStyleClass.textSize15(
                color: widget.textColor, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  /// Builds the normal button
  Widget _buildNormalButton(BuildContext context) {
    return Container(
      width: widget.width?.w,
      height: widget.height.h,
      decoration: widget.buttonType == ButtonType.elevated ? _buildDecoration() : null,
      child: ElevatedButton(
        onPressed: widget.isLoading ? null : widget.onPressed,
        style: ElevatedButton.styleFrom(
          elevation: widget.buttonType == ButtonType.elevated ? 0 : widget.elevation,
          backgroundColor: widget.buttonType == ButtonType.elevated
              ? KConstantColors.primaryColor // Transparent for gradient effect

              //Color(0xff7c9c14)
              //Color(0xff119e54)
              // Color(0xff0d4a5d)// Transparent for gradient effect
              : Colors.transparent, // Outlined button should have no fill
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            side: widget.buttonType == ButtonType.outlined
                ? BorderSide(
                    color: widget.outlineColor ?? KConstantColors.primaryColor,
                    width: 2.0)
                : BorderSide.none,
          ),
          shadowColor: Colors.transparent,
        ),
        child:widget.isLoading?CircularProgressIndicator(color: Colors.white,): Text(
          widget.text,
          style: TextStyleClass.textSize15Bold(
            color: widget.buttonType == ButtonType.elevated
                ? widget.textColor
                : Theme.of(context).hintColor,
          ),
        ),
      ),
    );
  }
}
