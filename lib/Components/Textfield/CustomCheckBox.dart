import 'package:flutter/cupertino.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import '../../Utils/Constants/ColorConstants.dart';
import '../../Utils/Constants/TextStyle.dart';

class CustomCheckBox extends StatelessWidget {
  final String name;
  final String textName;
  final bool initialValue;
  final Function(bool?)? onChanged;
  const CustomCheckBox(
      {super.key, required this.name, required this.textName, this.onChanged, required this.initialValue});

  @override
  Widget build(BuildContext context) {
    return FormBuilderCheckbox(
      name: name,
      activeColor: KConstantColors.primaryColor,
      initialValue: initialValue,
      onChanged: onChanged,
      title: Text(
        textName,
        style: TextStyleClass.textSize13Bold(),
      ),
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(
            errorText: 'You must accept terms and conditions to continue'),
      ]),
    );
  }
}
