import 'dart:convert';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:csv/csv.dart';

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
  bool isLoading = true;
  Uint8List? imageBytes;
  List<List<dynamic>>? _csvTable;

  Future<void> signInWithMicrosoft() async {
    try {
      final microsoftProvider = OAuthProvider("microsoft.com");

      microsoftProvider
        ..addScope('email')
        ..addScope('profile')
        ..addScope('User.Read')
        ..addScope('Files.Read')
        ..setCustomParameters({
          'prompt': 'consent',
          'tenant': 'c6d90ebc-1fd6-4a00-812c-328a88f6bfa6',
        });

      final userCredential =
      await FirebaseAuth.instance.signInWithProvider(microsoftProvider);
      final user = userCredential.user;
print('user');
print(user);
print(userCredential);
print('user');
      final accessToken = userCredential.credential?.accessToken.toString();


      if (accessToken != null) {
        await fetchMicrosoftProfilePhoto(accessToken);
        await readFilesFromOneDrive(accessToken);
      }

      setState(() {
        token = userCredential.credential?.accessToken.toString();
        _user = user;
      });
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.code} - ${e.message}');
    } catch (e) {
      debugPrint('Error during Microsoft sign-in: $e');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Microsoft Sign-In')),
      body: Center(
        child: _user == null
            ? ElevatedButton.icon(
          onPressed: signInWithMicrosoft,
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
                            await readCsvContent(
                                token!, file['id']);
                          }
                        },
                      );
                    },
                  ),
                const Divider(height: 30),
                if (_csvTable != null && _csvTable!.isNotEmpty) ...[
                  const Text("CSV Table:", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: _csvTable![0]
                          .map((value) => DataColumn(label: Text(value.toString())))
                          .toList(),
                      rows: _csvTable!
                          .sublist(1)
                          .where((row) => row.length == _csvTable![0].length)
                          .map(
                            (row) => DataRow(
                          cells: row
                              .map((value) => DataCell(Text(value.toString())))
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
    );
  }
}
