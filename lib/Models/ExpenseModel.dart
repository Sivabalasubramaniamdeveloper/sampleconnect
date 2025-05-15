import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseModel {
  final int? id;
  final double amount;
  final String description;
  final String firebaseUid;
  final String name;
  final DateTime date;

  ExpenseModel({
    this.id,
    required this.amount,
    required this.description,
    required this.firebaseUid,
    required this.name,
    required this.date,
  });

  // Factory to create ExpenseModel from Map
  factory ExpenseModel.fromMap(Map<String, dynamic> map) {
    return ExpenseModel(
      id: map['id'],
      amount: (map['amount'] ?? 0).toDouble(),
      description: map['description'] ?? '',
      firebaseUid: map['firebaseUid'] ?? '',
      name: map['name'] ?? '',
      date: DateTime.parse(map['date']),
    );
  }

  // Convert ExpenseModel to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'description': description,
      'firebaseUid': firebaseUid,
      'name': name,
      'date': date.toIso8601String(),
    };
  }
}

