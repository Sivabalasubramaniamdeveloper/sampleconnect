import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import '../../Utils/Constants/ColorConstants.dart';
import '../../Utils/Constants/TextStyle.dart';
import '../CommonFunctions.dart';

class CustomPasswordTextField extends StatefulWidget {
  final String name;
  final String? labelname;
  final bool? icon;
  final bool? loginField;
  final TextEditingController? textEditingController;
  final List<String? Function(String?)>? validators;
  final String? placeHolder;
  final bool? required;
  final Color? labelColor;

  const CustomPasswordTextField(
      {super.key,
      required this.name,
      this.labelname,
      this.icon = true,
      this.loginField = false,
      this.textEditingController,
      this.validators,
      this.placeHolder = 'Password',
      this.required = true,this.labelColor=Colors.black});

  @override
  _CustomPasswordTextFieldState createState() =>
      _CustomPasswordTextFieldState();
}

class _CustomPasswordTextFieldState extends State<CustomPasswordTextField> {
  bool _obscureText = true;

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final defaultValidators = [
      FormBuilderValidators.required(errorText: 'Password is Required'),
      FormBuilderValidators.minLength(8,
          errorText: 'Password Must be at Least 8 Characters'),
      FormBuilderValidators.maxLength(16,
          errorText: 'Password Must not Exceed 16 Characters'),
      FormBuilderValidators.match(RegExp(r'(?=.*?[A-Z])'),
          errorText: 'Password Must Contain at Least One Uppercase Letter'),
      FormBuilderValidators.match(RegExp(r'(?=.*?[a-z])'),
          errorText: 'Password Must Contain at Least One Lowercase Letter'),
      FormBuilderValidators.match(RegExp(r'(?=.*?[0-9])'),
          errorText: 'Password Must Contain at Least One Number'),
      FormBuilderValidators.match(RegExp(r'(?=.*?[!@#\$&*~])'),
          errorText:
              'Password Must Contain at Least One Special Character (!@#\$&*~)'),
    ];
    final mergedValidators = [
      ...defaultValidators,
      if (widget.validators != null) ...widget.validators!,
    ];
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelname != null) ...[
          Row(
            children: [
              Text(
                capitalizeFirstLetter(widget.labelname!),
                style: TextStyleClass.textSize14(color: widget.labelColor??null),
              ),
              if (widget.required!)
                Text(
                  ' *',
                  style: TextStyle(color: Colors.red.shade400),
                )
            ],
          ),
          SizedBox(height: 10.h),
        ],
        FormBuilderTextField(
          key: const Key("password"),
          name: widget.name,
          controller: widget.textEditingController,
          style: TextStyleClass.textSize15(),
          cursorColor: KConstantColors.blackColor,
          decoration: InputDecoration(
            hintText: widget.placeHolder!.isNotEmpty
                ? capitalizeFirstLetter(widget.placeHolder!)
                : "Password",
            errorStyle: TextStyleClass.textSize12(
              color: Colors.redAccent.shade100,
            ),
            hintStyle: TextStyleClass.textSize15(),
            fillColor: Theme.of(context).cardColor,
            prefixIcon: widget.icon!
                ? Icon(
                    Icons.lock,
                    size: 22.sp,
                    color: KConstantColors.primaryColor,
                  )
                : null,
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility_off : Icons.visibility,
                color: KConstantColors.primaryColor,
                size: 24.sp,
              ),
              onPressed: _toggleVisibility,
            ),
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
            // enabledBorder: OutlineInputBorder(
            //   borderSide: BorderSide(
            //       color: KConstantColors.error, width: 1.5.w),
            //   borderRadius: BorderRadius.circular(20.0).r,
            // ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0)
                    .r, // Adjust the vertical padding to decrease the height
          ),
          obscureText: _obscureText,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: FormBuilderValidators.compose(mergedValidators),
        ),
        SizedBox(
          height: 5.h,
        )
      ],
    );
  }
}
