import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:sampleconnect/Components/CustomToast/CustomToast.dart';
import 'package:sampleconnect/Screens/microsoft/RFIDWorkbookModel.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class MicroSoftLogin extends StatefulWidget {
  const MicroSoftLogin({super.key});

  @override
  State<MicroSoftLogin> createState() => _MicroSoftLoginState();
}

class _MicroSoftLoginState extends State<MicroSoftLogin> {
  User? _user;
  String? token;
  String? _csvContent;
  List<Map<String, dynamic>> files = [];
  List<RFIDWorkbook> workbookList = [];
  bool isLoading = true;
  Uint8List? imageBytes;
  List<List<dynamic>>? _csvTable;



  Future<void> signInWithMicrosoft() async {
    try {
      final microsoftProvider = OAuthProvider("microsoft.com")
        ..addScope('email')
        ..addScope('profile')
        ..addScope('User.Read')
        ..addScope('Files.Read')
        ..setCustomParameters({
          'prompt': 'consent',
          'tenant': 'c6d90ebc-1fd6-4a00-812c-328a88f6bfa6',
        });

      UserCredential userCredential;

      if (kIsWeb) {
        // Use popup or redirect for web
        userCredential = await FirebaseAuth.instance.signInWithPopup(microsoftProvider);
      } else {
        // Use native flow for mobile
        userCredential = await FirebaseAuth.instance.signInWithProvider(microsoftProvider);
      }

      final user = userCredential.user;
      final accessToken = userCredential.credential?.accessToken?.toString();

      if (accessToken != null) {
        await fetchMicrosoftProfilePhoto(accessToken);
        await readFilesFromOneDrive(accessToken);
      }

      setState(() {
        token = accessToken;
        _user = user;
      });
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.code} - ${e.message}');
    } catch (e) {
      debugPrint('Error during Microsoft sign-in: $e');
    }
  }


  Future<void> downloadFile(String fileName) async {
    try {
      final url = 'http://172.20.224.1:8000/$fileName';
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName';

      final dio = Dio();
      final response = await dio.download(
        url,
        filePath,
        options: Options(
          receiveTimeout: const Duration(seconds: 30),
        ),
      );

      if (response.statusCode == 200) {
        print('Downloaded to $filePath');
      } else {
        print('Failed to download file. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Download error: $e');
    }
  }

  Future<void> getAPI() async {
    try {
      final url = 'http://172.22.208.1:3000';

      final dio = Dio();
      final response = await dio.get(
        url,
        options: Options(
          receiveTimeout: const Duration(seconds: 30),
        ),
      );

      if (response.statusCode == 200) {
        print('Downloaded to ${response.data}');
        showSuccessToast("${response.data}");
      } else {
        print('Failed to download file. Status: ${response.statusCode}');
      }

    } catch (e) {
      print('Download error: $e');
    }
  }

  Future<void> fetchMicrosoftProfilePhoto(String accessToken) async {
    final response = await http.get(
      Uri.parse('https://graph.microsoft.com/v1.0/me/photo/\$value'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    print('response');
    print(response.body);
    print('response');
    if (response.statusCode == 200) {
      final base64Photo = base64Encode(response.bodyBytes);

      print('base64Photo');
      print(base64Photo);
      print('base64Photo');
      setState(() {
        imageBytes = base64Decode(base64Photo);
      });
    } else {
      debugPrint('Failed to fetch photo: ${response.statusCode}');
    }
  }

  Future<void> readFilesFromOneDrive(String accessToken) async {
    final url =
        Uri.parse('https://graph.microsoft.com/v1.0/me/drive/root/children');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> fileList = data['value'];

      setState(() {
        files = fileList
            .map<Map<String, dynamic>>((item) => {
                  'name': item['name'],
                  'id': item['id'],
                  'webUrl': item['webUrl'],
                  'size': item['size'],
                })
            .toList();
        isLoading = false;
      });
    } else {
      debugPrint(
          'Error fetching files: ${response.statusCode} ${response.body}');
      setState(() {
        isLoading = false;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> readCsvContent(String accessToken, String fileId) async {
    final csvUrl = Uri.parse(
        'https://graph.microsoft.com/v1.0/me/drive/items/$fileId/content');

    final response = await http.get(
      csvUrl,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final csvBody = response.body;
      final rows = const CsvToListConverter().convert(csvBody);
      setState(() {
        _csvContent = csvBody;
        _csvTable = rows;
      });
    } else {
      debugPrint('Failed to fetch CSV: ${response.statusCode}');
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    setState(() {
      _user = null;
      _csvContent = null;
      files = [];
    });
  }

  Future<void> uploadExcelFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls', 'xlsm'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);

      try {
        Dio dio = Dio();

        String fileName = file.path.split('/').last;

        FormData formData = FormData.fromMap({
          'file': await MultipartFile.fromFile(file.path, filename: fileName),
        });

        Response response = await dio.post(
          'http://192.168.0.235:3000/upload-excel',
          data: formData,
          options: Options(
            headers: {
              'Content-Type': 'multipart/form-data',
            },
          ),
        );

        if (response.statusCode == 200) {
          // log('✅ Upload success: ${response.data}');
          // showSuccessToast('Success: ${response.data}');
          // RFIDWorkbook.fromJson(response.data['data']);
          print("SSSSSSSSSSSSSSSSSS");
          (response.data['data'] as List<dynamic>)
              .toList()
              .forEach((e) => print(e));
          setState(() {
          workbookList=  (response.data['data'] as List<dynamic>)
                .toList()
                .map((e) => RFIDWorkbook.fromMap(e as Map<String,dynamic>))
                .toList();
          });
          print("workbookList.length");
          print(workbookList.length);
          // print(RF)

          // // If response is a List, access the first item
          // if (response.data is List && response.data.isNotEmpty) {
          //   Map<String, dynamic> jsonData = response.data[0];
          //   RFIDWorkbook.fromMap(jsonData);
          // }
          // // If response is already a Map
          // else if (response.data is Map<String, dynamic>) {
          //   RFIDWorkbook.fromMap(response.data);
          // }
        } else {
          log('❌ Upload failed: ${response.statusCode}');
          showSuccessToast('Upload failed: ${response.statusCode}');
        }
      } catch (e) {
        log('⚠️ Error: $e');
        showSuccessToast('Error uploading file');
      }
    } else {
      log('⚠️ No file selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Microsoft Sign-In')),
      body: Column(
        children: [
          Center(
            child: _user == null
                ? ElevatedButton.icon(
                    onPressed: () {
                      signInWithMicrosoft();
                      // uploadExcelFile();
                      // downloadFile('Document2.docx');
                    },
                    icon: const Icon(Icons.login),
                    label: const Text('Sign in with Microsoft'),
                  )
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (imageBytes != null)
                            CircleAvatar(
                              radius: 60,
                              backgroundImage: MemoryImage(imageBytes!),
                            ),
                          const SizedBox(height: 10),
                          Text('Name: ${_user?.displayName ?? 'N/A'}'),
                          Text('Email: ${_user?.email ?? 'N/A'}'),
                          const Divider(height: 30),
                          const Text('OneDrive Files:',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          if (isLoading)
                            const CircularProgressIndicator()
                          else if (files.isEmpty)
                            const Text('No files found')
                          else
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: files.length,
                              itemBuilder: (context, index) {
                                final file = files[index];
                                return ListTile(
                                  title: Text(file['name']),
                                  subtitle: Text('Size: ${file['size']} bytes'),
                                  onTap: () async {
                                    if (file['name'].endsWith('.csv')) {
                                      // final oauthCredential =
                                      // FirebaseAuth.instance.currentUser!
                                      //     .providerData.first
                                      // as OAuthCredential;
                                      // final accessToken = oauthCredential.accessToken;
                                      await readCsvContent(token!, file['id']);
                                    }
                                  },
                                );
                              },
                            ),
                          const Divider(height: 30),
                          if (_csvTable != null && _csvTable!.isNotEmpty) ...[
                            const Text("CSV Table:",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 10),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                columns: _csvTable![0]
                                    .map((value) => DataColumn(
                                        label: Text(value.toString())))
                                    .toList(),
                                rows: _csvTable!
                                    .sublist(1)
                                    .where((row) =>
                                        row.length == _csvTable![0].length)
                                    .map(
                                      (row) => DataRow(
                                        cells: row
                                            .map((value) => DataCell(
                                                Text(value.toString())))
                                            .toList(),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ],
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: signOut,
                            icon: const Icon(Icons.logout),
                            label: const Text('Sign Out'),
                          )
                        ],
                      ),
                    ),
                  ),
          ),
          workbookList.isEmpty
              ? SizedBox()
              : Expanded(
                child: ListView.builder(
                    itemCount: workbookList.length,
                    padding: const EdgeInsets.all(0).r,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(workbookList[index].purchaseOrder!),
                        subtitle: Text(workbookList[index].rFID!),
                      );
                    }),
              ),
        ],
      ),
    );
  }
}
