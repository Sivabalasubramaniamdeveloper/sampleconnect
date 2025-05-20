import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:csv/csv.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

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
  String currentFolderId = 'root';
  List<String> navigationStack = ['root'];
  List<List<dynamic>>? _xlsmTable;
  String? editingXlsmFileId;

  String? editingFileId;
  bool isSaving = false;

  Future<void> signInWithMicrosoft() async {
    try {
      final microsoftProvider = OAuthProvider("microsoft.com");

      microsoftProvider
        ..addScope('email')
        ..addScope('profile')
        ..addScope('User.Read')
        ..addScope('Files.ReadWrite') // Add this for read/write access
        ..addScope('offline_access')
        ..setCustomParameters({
          'prompt': 'consent',
          'tenant': 'c6d90ebc-1fd6-4a00-812c-328a88f6bfa6',
        });

      final userCredential =
          await FirebaseAuth.instance.signInWithProvider(microsoftProvider);
      final user = userCredential.user;

      final accessToken = userCredential.credential?.accessToken.toString();

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

  Future<void> fetchMicrosoftProfilePhoto(String accessToken) async {
    final response = await http.get(
      Uri.parse('https://graph.microsoft.com/v1.0/me/photo/\$value'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final base64Photo = base64Encode(response.bodyBytes);
      setState(() {
        imageBytes = base64Decode(base64Photo);
      });
    } else {
      debugPrint('Failed to fetch photo: ${response.statusCode}');
    }
  }

  Future<void> readFilesFromOneDrive(String accessToken,
      [String folderId = 'root']) async {
    setState(() {
      isLoading = true;
      editingFileId = null;
      _csvTable = null;
      _xlsmTable = null;
      _csvContent = null;
      currentFolderId = folderId;
    });

    final url = Uri.parse(
        'https://graph.microsoft.com/v1.0/me/drive/items/$folderId/children');

    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> fileList = data['value'];

      setState(() {
        files = fileList
            .map<Map<String, dynamic>>((item) => {
                  'name': item['name'],
                  'id': item['id'],
                  'folder': item.containsKey('folder'),
                  'size': item['size'] ?? 0,
                })
            .toList();
      });
    } else {
      debugPrint(
          'Error fetching files: ${response.statusCode} ${response.body}');
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> openImage(String accessToken, String fileId) async {
    final response = await http.get(
      Uri.parse(
          'https://graph.microsoft.com/v1.0/me/drive/items/$fileId/content'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      final bytes = response.bodyBytes;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          content: Image.memory(bytes),
        ),
      );
    } else {
      debugPrint('Error loading image: ${response.statusCode}');
    }
  }

  Future<void> openVideo(String accessToken, String fileId) async {
    final videoUrl =
        'https://graph.microsoft.com/v1.0/me/drive/items/$fileId/content';

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => Dialog(
        insetPadding: const EdgeInsets.all(10),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: VideoPlayerPopup(url: videoUrl, accessToken: accessToken),
        ),
      ),
    );
  }

  Future<void> openExcel(String accessToken, String fileId) async {
    final url =
        'https://graph.microsoft.com/v1.0/me/drive/items/$fileId/content';
    final response = await http.get(Uri.parse(url), headers: {
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 200) {
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/file.xlsx');
      await file.writeAsBytes(response.bodyBytes);
      OpenFile.open(file.path);
    } else {
      debugPrint('Error opening Excel file');
    }
  }

  Future<void> readCsvContent(String accessToken, String fileId) async {
    setState(() {
      isLoading = true;
      _csvTable = null;
      _xlsmTable = null;
      _csvContent = null;
      editingFileId = fileId;
    });

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
    setState(() {
      isLoading = false;
    });
  }

  Future<void> uploadUpdatedCsv(
      String accessToken, String fileId, String csvContent) async {
    setState(() {
      isSaving = true;
    });

    final url =
        'https://graph.microsoft.com/v1.0/me/drive/items/$fileId/content';

    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'text/csv',
      },
      body: csvContent,
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('CSV saved successfully!')),
      );
      await readFilesFromOneDrive(accessToken);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save CSV: ${response.statusCode}')),
      );
    }

    setState(() {
      isSaving = false;
    });
  }

  Future<void> uploadUpdatedXlsm(
      String token, String fileId, List<List<dynamic>> table) async {
    setState(() {
      isSaving = true;
    });

    // Download existing XLSM file bytes (optional if you want to preserve macros, otherwise create new)
    final downloadUrl =
        'https://graph.microsoft.com/v1.0/me/drive/items/$fileId/content';
    final existingBytes = await downloadFile(downloadUrl, token);
    if (existingBytes == null) {
      print('Failed to download existing XLSM file');
      setState(() {
        isSaving = false;
      });
      return;
    }

    // Decode existing bytes
    final excel = Excel.decodeBytes(existingBytes);

    String sheetName = excel.getDefaultSheet() ?? 'Sheet1';
    var sheet = excel[sheetName];

    // Update sheet cells with your table data
    for (int rowIndex = 0; rowIndex < table.length; rowIndex++) {
      for (int colIndex = 0; colIndex < table[rowIndex].length; colIndex++) {
        sheet
            .cell(CellIndex.indexByColumnRow(
                columnIndex: colIndex, rowIndex: rowIndex))
            .value = TextCellValue(table[rowIndex][colIndex].toString());
      }
    }

    // Encode updated Excel file to bytes
    final updatedBytes = excel.encode();
    if (updatedBytes == null) {
      print('Failed to encode Excel file');
      setState(() {
        isSaving = false;
      });
      return;
    }

    // Upload updated bytes to OneDrive
    final response = await http.put(
      Uri.parse(downloadUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/vnd.ms-excel.sheet.macroEnabled.12',
      },
      body: updatedBytes,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('XLSM file saved successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload XLSM: ${response.body}')),
      );
    }

    setState(() {
      isSaving = false;
    });
  }

  Future<void> deleteFileFromOneDrive(String accessToken, String fileId) async {
    setState(() {
      isLoading = true;
    });

    final url = 'https://graph.microsoft.com/v1.0/me/drive/items/$fileId';

    final response = await http.delete(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 204) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('File deleted successfully!')),
      );
      await readFilesFromOneDrive(accessToken);

      if (editingFileId == fileId) {
        setState(() {
          editingFileId = null;
          _csvTable = null;
          _xlsmTable = null;
          _csvContent = null;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Failed to delete file: ${response.statusCode}')),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  void updateCell(int row, int col, String value) {
    if (_csvTable == null) return;
    setState(() {
      _csvTable![row][col] = value;
      _csvContent = const ListToCsvConverter().convert(_csvTable!);
    });
  }

  void updateXlsmCell(int row, int col, String value) {
    if (_xlsmTable == null) return;
    setState(() {
      _xlsmTable![row][col] = value;
    });
  }

  Future<Uint8List> downloadFile(String url, String accessToken) async {
    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to download file');
    }
  }

  void showXlsmContent(BuildContext context, Uint8List bytes, String fileId) {
    final excel = Excel.decodeBytes(bytes);
    final sheet = excel.tables[excel.tables.keys.first];
    if (sheet == null) return;

    setState(() {
      _xlsmTable = sheet.rows
          .map((row) => row.map((cell) => cell?.value ?? '').toList())
          .toList();
      editingXlsmFileId = fileId;
    });
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    setState(() {
      _user = null;
      _csvContent = null;
      files = [];
      _csvTable = null;
      editingFileId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PeraTrack Sign-In')),
      body: Center(
        child: _user == null
            ? ElevatedButton.icon(
                onPressed: signInWithMicrosoft,
                icon: const Icon(Icons.login),
                label: const Text('Sign in with Microsoft'),
              )
            : SingleChildScrollView(
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('OneDrive Files:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        // ElevatedButton.icon(
                        //   onPressed: () {
                        //     if (token != null) {
                        //       readFilesFromOneDrive(token!);
                        //     }
                        //   },
                        //   icon: const Icon(Icons.refresh),
                        //   label: const Text('Refresh'),
                        // ),
                        if (navigationStack.length > 1)
                          ElevatedButton.icon(
                            onPressed: () async {
                              navigationStack.removeLast();
                              final parentId = navigationStack.last;
                              if (token != null) {
                                await readFilesFromOneDrive(token!, parentId);
                              }
                            },
                            icon: const Icon(Icons.arrow_back),
                            label: const Text('Back'),
                          ),
                      ],
                    ),
                    if (isLoading)
                      const Padding(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator(),
                      )
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
                            leading: Icon(file['folder'] == true
                                ? Icons.folder
                                : Icons.insert_drive_file),
                            title: Text(file['name']),
                            subtitle: file['folder'] == true
                                ? null
                                : Text('Size: ${file['size']} bytes'),
                            onTap: () async {
                              if (file['folder'] == true && token != null) {
                                navigationStack.add(file['id']);
                                await readFilesFromOneDrive(token!, file['id']);
                              } else if (token != null) {
                                final fileName = file['name'].toLowerCase();

                                if (fileName.endsWith('.csv')) {
                                  await readCsvContent(token!, file['id']);
                                } else if (fileName.endsWith('.jpg') ||
                                    fileName.endsWith('.jpeg') ||
                                    fileName.endsWith('.png') ||
                                    fileName.endsWith('.gif')) {
                                  await openImage(token!, file['id']);
                                } else if (fileName.endsWith('.mp4') ||
                                    fileName.endsWith('.mov') ||
                                    fileName.endsWith('.avi')) {
                                  await openVideo(token!, file['id']);
                                } else if (fileName.endsWith('.xlsx') ||
                                    fileName.endsWith('.xls')) {
                                  await openExcel(token!, file['id']);
                                } else if (fileName.endsWith('.xlsm')) {
                                  final url =
                                      "https://graph.microsoft.com/v1.0/me/drive/items/${file['id']}/content";
                                  final bytes = await downloadFile(url, token!);
                                  showXlsmContent(context, bytes, file['id']);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('Unsupported file format')),
                                  );
                                }
                              }
                            },
                            trailing: file['folder'] != true
                                ? Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () async {
                                          if (token != null) {
                                            final confirmed =
                                                await showDialog<bool>(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: const Text(
                                                    'Confirm Delete'),
                                                content: Text(
                                                    'Are you sure you want to delete "${file['name']}"?'),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () =>
                                                          Navigator.of(context)
                                                              .pop(false),
                                                      child:
                                                          const Text('Cancel')),
                                                  TextButton(
                                                      onPressed: () =>
                                                          Navigator.of(context)
                                                              .pop(true),
                                                      child:
                                                          const Text('Delete')),
                                                ],
                                              ),
                                            );
                                            if (confirmed == true) {
                                              await deleteFileFromOneDrive(
                                                  token!, file['id']);
                                            }
                                          }
                                        },
                                      ),
                                      if (file['name'].endsWith('.csv'))
                                        IconButton(
                                          icon: const Icon(Icons.edit),
                                          onPressed: () async {
                                            if (token != null) {
                                              await readCsvContent(
                                                  token!, file['id']);
                                            }
                                          },
                                        ),
                                    ],
                                  )
                                : null,
                          );
                        },
                      ),
                    const Divider(height: 30),
                    if (_csvTable != null && _csvTable!.isNotEmpty) ...[
                      const Text("CSV Editor:",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: _csvTable![0]
                              .map((value) =>
                                  DataColumn(label: Text(value.toString())))
                              .toList(),
                          rows: List.generate(
                            _csvTable!.length - 1,
                            (rowIndex) {
                              final headerLength = _csvTable![0].length;
                              final row = _csvTable![rowIndex + 1];

                              // Make sure the row has the same number of cells as header
                              final adjustedRow = List<dynamic>.from(row);
                              while (adjustedRow.length < headerLength) {
                                adjustedRow.add(
                                    ''); // add empty string if less columns
                              }
                              while (adjustedRow.length > headerLength) {
                                adjustedRow
                                    .removeLast(); // remove extra columns if any
                              }

                              return DataRow(
                                cells: List.generate(
                                  headerLength,
                                  (colIndex) {
                                    final cellValue =
                                        adjustedRow[colIndex].toString();
                                    return DataCell(
                                      EditableTextCell(
                                        initialValue: cellValue,
                                        onChanged: (newValue) {
                                          updateCell(
                                              rowIndex + 1, colIndex, newValue);
                                        },
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      isSaving
                          ? const CircularProgressIndicator()
                          : ElevatedButton.icon(
                              onPressed: () {
                                if (token != null &&
                                    editingFileId != null &&
                                    _csvContent != null) {
                                  uploadUpdatedCsv(
                                      token!, editingFileId!, _csvContent!);
                                }
                              },
                              icon: const Icon(Icons.save),
                              label: const Text('Save CSV'),
                            ),
                    ],
                    if (_xlsmTable != null && _xlsmTable!.isNotEmpty) ...[
                      const Text("XLSM Editor:",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: _xlsmTable![0]
                              .map((value) =>
                                  DataColumn(label: Text(value.toString())))
                              .toList(),
                          rows:
                              List.generate(_xlsmTable!.length - 1, (rowIndex) {
                            final headerLength = _xlsmTable![0].length;
                            final row = _xlsmTable![rowIndex + 1];

                            final adjustedRow = List<dynamic>.from(row);
                            while (adjustedRow.length < headerLength) {
                              adjustedRow
                                  .add(''); // add empty string if less columns
                            }
                            while (adjustedRow.length > headerLength) {
                              adjustedRow
                                  .removeLast(); // remove extra columns if any
                            }
                            return DataRow(
                              cells: List.generate(headerLength, (colIndex) {
                                final cellValue =
                                    adjustedRow[colIndex].toString();
                                return DataCell(
                                  EditableTextCell(
                                    initialValue: cellValue,
                                    onChanged: (newValue) {
                                      updateXlsmCell(
                                          rowIndex + 1, colIndex, newValue);
                                    },
                                  ),
                                );
                              }),
                            );
                          }),
                        ),
                      ),
                      const SizedBox(height: 20),
                      isSaving
                          ? const CircularProgressIndicator()
                          : ElevatedButton.icon(
                              onPressed: () {
                                if (token != null &&
                                    editingXlsmFileId != null &&
                                    _xlsmTable != null) {
                                  uploadUpdatedXlsm(
                                      token!, editingXlsmFileId!, _xlsmTable!);
                                }
                              },
                              icon: const Icon(Icons.save),
                              label: const Text('Save XLSM'),
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
    );
  }
}

class EditableTextCell extends StatefulWidget {
  final String initialValue;
  final ValueChanged<String> onChanged;

  const EditableTextCell({
    super.key,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  State<EditableTextCell> createState() => _EditableTextCellState();
}

class _EditableTextCellState extends State<EditableTextCell> {
  late TextEditingController _controller;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(covariant EditableTextCell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue && !_isEditing) {
      _controller.text = widget.initialValue;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isEditing
        ? TextField(
            autofocus: true,
            controller: _controller,
            onSubmitted: (value) {
              setState(() {
                _isEditing = false;
              });
              widget.onChanged(value);
            },
            onEditingComplete: () {
              setState(() {
                _isEditing = false;
              });
              widget.onChanged(_controller.text);
            },
          )
        : GestureDetector(
            onTap: () {
              setState(() {
                _isEditing = true;
              });
            },
            child: Text(
              _controller.text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          );
  }
}

class VideoPlayerPopup extends StatefulWidget {
  final String url;
  final String accessToken;

  const VideoPlayerPopup(
      {required this.url, required this.accessToken, Key? key})
      : super(key: key);

  @override
  _VideoPlayerPopupState createState() => _VideoPlayerPopupState();
}

class _VideoPlayerPopupState extends State<VideoPlayerPopup> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.url),
      httpHeaders: {'Authorization': 'Bearer ${widget.accessToken}'},
    )..initialize().then((_) {
        setState(() {
          _isInitialized = true;
          _controller.play();
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isInitialized
        ? Stack(
            children: [
              VideoPlayer(_controller),
              Align(
                alignment: Alignment.bottomCenter,
                child: VideoProgressIndicator(
                  _controller,
                  allowScrubbing: true,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          )
        : const Center(child: CircularProgressIndicator());
  }
}
