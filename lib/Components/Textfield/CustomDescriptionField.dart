import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../Utils/Constants/TextStyle.dart';

class CustomDescriptionField extends StatelessWidget {
  final String placeHolder;
  final String name;
  final String? labelName;
  final List<String>? autofillHints;
  final bool? loginField;
  final TextStyle? style;
  final bool? readOnly;
  final bool? enable;
  final int? Maxlength;
  final String? CounterText;
  final void Function()? onTap;
  final String? initialValue;
  final TextInputType? keyBoardType;
  final List<TextInputFormatter>? inputformat;
  final TextEditingController? textEditingController;
  final Icon? icon;
  final IconButton? suffixIcon;
  final List<String? Function(String?)>? validators;
  final Function(String?)? onChanged;
  final TextInputAction? textInputAction;
  final bool? required;
  final int? MaxLines;
  const CustomDescriptionField(
      {super.key,
      required this.name,
      required this.placeHolder,
      this.icon,
      this.MaxLines,
      this.labelName,
      this.style,
      this.Maxlength,
      this.CounterText,
      this.loginField = false,
      this.validators,
      this.initialValue,
      this.keyBoardType,
      this.textEditingController,
      this.suffixIcon,
      this.inputformat,
      this.readOnly = false,
      this.onChanged,
      this.autofillHints,
      this.onTap,
      this.enable = true,
      this.textInputAction,
      this.required = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 7, vertical: 5).r,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (labelName != null) ...[
            Row(
              children: [
                Text(
                  labelName!,
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
            maxLength: Maxlength,
            maxLines: MaxLines,
            onTap: onTap,
            autofocus: false,
            enabled: enable!,
            autovalidateMode: AutovalidateMode.always,
            controller: textEditingController,
            autofillHints: autofillHints,
            initialValue: initialValue,
            style: style ?? TextStyleClass.textSize15(),
            inputFormatters: inputformat,
            keyboardType: keyBoardType ?? TextInputType.text,
            textInputAction: textInputAction,
            readOnly: readOnly!,
            decoration: InputDecoration(
              counterText: CounterText,
              errorStyle: TextStyle(
                  color: loginField! ? Colors.red : Colors.redAccent.shade100),
              hintText: placeHolder,
              hintStyle: TextStyleClass.textSize15(),
              prefixIcon: icon,
              fillColor: loginField! ? Colors.black : Color(0xfff5f5f5),
              suffixIcon: suffixIcon,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7.0).r,
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 7.0, horizontal: 10.0).r,
            ),
            // autovalidateMode: AutovalidateMode.,
            validator: validators != null
                ? FormBuilderValidators.compose([...validators!])
                : null,
            onChanged: onChanged,
          ),
          SizedBox(height: 15.h),
        ],
      ),
    );
  }
}
