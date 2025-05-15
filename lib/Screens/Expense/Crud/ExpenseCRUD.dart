import 'package:sampleconnect/Models/ExpenseModel.dart';
import 'package:sqflite/sqflite.dart';

class ExpenseCrud{
  insertExpense(ExpenseModel expense, db) async {
    try {
      int id = await db!.insert(
        'users',
        expense.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return id;

    } catch (e) {
      rethrow;
    }
  }
}