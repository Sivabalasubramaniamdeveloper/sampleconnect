import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import '../../Utils/Constants/ColorConstants.dart';
import '../../Utils/Constants/TextStyle.dart';
import '../CommonFunctions.dart';

class CustomTextField extends StatelessWidget {
  final String placeHolder;
  final String name;
  final String? labelName;
  final List<String>? autofillHints;
  final bool? helpdesk;
  final bool? loginField;
  final String? helpdeskText;
  final bool? readOnly;
  final bool? enable;
  final void Function()? onTap;
  final String? initialValue;
  final TextInputType? keyBoardType;
  final List<TextInputFormatter>? inputformat;
  final TextEditingController? textEditingController;
  final IconData? icon;
  final IconButton? suffixIcon;
  final List<String? Function(String?)>? validators;
  final Function(String?)? onChanged;
  final TextInputAction? textInputAction;
  final bool? required;
  final TextStyle? style;

  const CustomTextField(
      {super.key,
      required this.name,
      required this.placeHolder,
      this.icon,
      this.labelName,
      this.loginField = false,
      this.validators,
      this.initialValue,
      this.keyBoardType,
      this.textEditingController,
      this.suffixIcon,
      this.inputformat,
      this.readOnly = false,
      this.onChanged,
      this.helpdesk = false,
      this.helpdeskText = "Enter the Message",
      this.autofillHints,
      this.onTap,
      this.enable = true,
      this.textInputAction,
      this.required = true,
      this.style});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelName != null) ...[
          Row(
            children: [
              Text(
                capitalizeFirstLetter(labelName!),
                style: TextStyleClass.textSize14(),
              ),
              SizedBox(
                width: 5.w,
              ),
              if (required!)
                Text(
                  '*',
                  style: TextStyle(
                    color: Colors.red.shade400,
                  ),
                ),
            ],
          ),
          SizedBox(height: 7.h),
        ],
        FormBuilderTextField(
          key: Key(name), // Avoid duplicate keys
          name: name,
          onTap: onTap,
          enabled: enable!,
          controller: textEditingController,
          autofillHints: autofillHints,
          initialValue: initialValue,
          inputFormatters: inputformat,
          cursorColor: KConstantColors.blackColor,
          keyboardType: keyBoardType ?? TextInputType.text,
          textInputAction: textInputAction,
          readOnly: readOnly!,
          style: style ?? TextStyleClass.textSize15(),
          decoration: InputDecoration(
            errorStyle: TextStyleClass.textSize12(
              color: Colors.redAccent.shade100,
            ),
            hintText: capitalizeFirstLetter(placeHolder),
            hintStyle: TextStyleClass.textSize15(),
            prefixIcon: Icon(
              icon,
              color:KConstantColors.primaryColor,
              size: 22.sp,
            ),
            fillColor: Theme.of(context).cardColor,
            suffixIcon: suffixIcon,
            filled: true,
            focusColor: KConstantColors.primaryColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0).r,
              borderSide: BorderSide.none,
            ),
            // focusedBorder: OutlineInputBorder(
            //   borderSide: BorderSide(
            //       color: KConstantColors.primaryColor, width: 1.5.w),
            //   borderRadius: BorderRadius.circular(10.0).r,
            // ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 7.0, horizontal: 10.0).r,
          ),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: validators != null
              ? FormBuilderValidators.compose([...validators!])
              : null,
          onChanged: onChanged,
        ),
        SizedBox(height: 10.h),
      ],
    );
  }
}
