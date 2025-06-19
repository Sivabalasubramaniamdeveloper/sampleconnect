import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:sampleconnect/Components/CustomToast/CustomToast.dart';

class GoogleSheets extends StatefulWidget {
  const GoogleSheets({super.key});

  @override
  State<GoogleSheets> createState() => _GoogleSheetsState();
}

class _GoogleSheetsState extends State<GoogleSheets> {
  List<dynamic> data = [];
  Future<void> readSheet() async {
    final url =
        'https://script.google.com/macros/s/AKfycbw_c-kU6uAp-Dj-9yE3-lvjgnsRBknfARsc0Z7AnAH65eZ2_D1CzaKhxAS8FfzFp7Spig/exec';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        print("Response body:");
        print(response.body);

        // Try parsing JSON
        setState(() {
          data = jsonDecode(response.body);
        });
        print("Parsed JSON:");
        print(data);
      } else {
        print("Failed with status: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception occurred: $e");
    }
  }

// For adding/updating
  Future<void> modifySheet(
      String operation, String name, String email, String message) async {
    final response = await http.post(
      Uri.parse(
          'https://script.google.com/macros/s/AKfycbw_c-kU6uAp-Dj-9yE3-lvjgnsRBknfARsc0Z7AnAH65eZ2_D1CzaKhxAS8FfzFp7Spig/exec'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'operation': operation,
        'name': name,
        'email': email,
        'message': message,
      }),
    );
   await readSheet();
    showSuccessToast(response.statusCode.toString());
    // print(response.statusCode); // Success
  }

  Future<void> addHeader(
      String operation, String name, String email, String message) async {
    final response = await http.post(
      Uri.parse(
          'https://script.google.com/macros/s/AKfycbw_c-kU6uAp-Dj-9yE3-lvjgnsRBknfARsc0Z7AnAH65eZ2_D1CzaKhxAS8FfzFp7Spig/exec'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'operation': operation,
        'name': name,
        'email': email,
        'message': message,
      }),
    );
    showSuccessToast(response.statusCode.toString());
    // print(response.statusCode); // Success
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readSheet();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(onPressed: (){
          modifySheet("add","raaj","raaj@gmail.com","message");
        }, child: Text("add data")),
        SizedBox(height: 10.h,),
        Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal, // for horizontal overflow
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Email')),
                DataColumn(label: Text('Message')),
              ],
              rows: data.map((row) {
                return DataRow(
                  cells: row.map<DataCell>((cell) => DataCell(Text(cell.toString()))).toList(),
                );
              }).toList(),

            ),
          ),
        ),
      ],
    );
  }
}
