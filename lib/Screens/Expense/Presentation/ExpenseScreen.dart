import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:sampleconnect/Components/Textfield/CustomTextField.dart';
import 'package:sampleconnect/main.dart';

import '../../../Models/ExpenseModel.dart';
import '../Crud/ExpenseCRUD.dart';
// Import your ExpenseModel

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({Key? key}) : super(key: key);

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FormBuilder(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                name: 'amount',
                placeHolder: "Amount",
                keyBoardType: TextInputType.number,
                validators: [
                  FormBuilderValidators.required(
                      errorText: 'Email is Required'),
                ],
              ),
              CustomTextField(
                name: 'description',
                placeHolder: "Description",
                validators: [
                  FormBuilderValidators.required(
                      errorText: 'Email is Required'),
                ],
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveExpense,
                child: Text('Save Expense'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveExpense() async {
    if (_formKey.currentState!.saveAndValidate()) {
      final formData = _formKey.currentState?.value;
      final expense = ExpenseModel(
        name: auth.currentUser!.displayName!,
        amount: double.parse(formData!['amount']),
        description: formData['description'],
        firebaseUid: auth.currentUser!.uid,
        date: DateTime.now(),
      );
      print("expense");
      print(expense.amount);
      print(expense.toMap().values);

      await ExpenseCrud().insertExpense(expense, localDB);
    }
  }
}
