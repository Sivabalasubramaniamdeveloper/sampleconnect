import 'dart:convert';

import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:chat_bubbles/message_bars/message_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:sampleconnect/Screens/Personalchat/cubit/chat_message_state.dart';

import '../../../../Components/CommonFunctions.dart';
import '../../../../Firebase/controllers/firebase_firestore.dart';
import '../../../../Models/MessageModel.dart';
import '../../../../Models/UserModel.dart';
import '../../cubit/chat_message_cubit.dart';

class ChatScreen extends StatefulWidget {
  final UserListModel chatPerson;
  const ChatScreen({super.key, required this.chatPerson});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserList();
  }

  Future<void> getUserList() async {
    try {
      await context
          .read<ChatMessageCubit>()
          .loadMessages(auth.currentUser!.uid, widget.chatPerson.firebaseUid);
    } on DioException catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatMessageCubit, ChatMessageState>(
                builder: (context, state) {
              if (state.data != null) {
                List<MessageModel> chatMessage = [];
                if (state.data!.messages.isNotEmpty) {
                  for (var e in state.data!.messages) {
                    chatMessage.add(e);
                  }
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: chatMessage.length,
                  itemBuilder: (context, index) {
                    final message = chatMessage[index];
                    return BubbleSpecialOne(
                      text: message.content,
                      isSender: message.senderID == auth.currentUser!.uid,
                      color: Theme.of(context).cardColor,
                      constraints: BoxConstraints(maxWidth: 200.0),
                      textStyle: TextStyle(
                        fontSize: 16.sp,
                        color: Theme.of(context).hintColor,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                );
              } else if (state.message == "Failed to load users") {
                return const Center(child: Text("Something went wrong"));
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
          ),
          MessageBar(
            onSend: (message) async {
              await FirebaseFireStore().sendMessage(
                  auth.currentUser!.uid,
                  widget.chatPerson.firebaseUid,
                  MessageModel(
                    senderID: auth.currentUser!.uid,
                    content: message,
                    sentAt: DateTime.now(),
                  ));
              if (widget.chatPerson.status != 'online') {
                sendPushNotification(widget.chatPerson.firebaseToken,
                    widget.chatPerson, message);
              }
            },
            actions: [
              InkWell(
                child: Icon(
                  Icons.add,
                  color: Colors.black,
                  size: 24,
                ),
                onTap: () {},
              ),
              Padding(
                padding: EdgeInsets.only(left: 8, right: 8),
                child: InkWell(
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.green,
                    size: 24,
                  ),
                  onTap: () {},
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20.h,
          ),
        ],
      ),
    );
  }

  Future<void> sendPushNotification(
      String deviceToken, UserListModel person, String sentMessage) async {
    try {
      // 1. Load your service account JSON file
      final serviceAccountJson =
          await rootBundle.loadString('assets/images/service_account.json');
      final serviceAccount = json.decode(serviceAccountJson);

      final credentials = ServiceAccountCredentials.fromJson(serviceAccount);

      // 2. Create authenticated client
      final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
      final authClient = await clientViaServiceAccount(credentials, scopes);

      // 3. Get the access token from the auth client
      final accessToken = authClient.credentials.accessToken.data;

      // 4. Create Dio instance
      final dio = Dio();

      final projectId = serviceAccount['project_id'];
      final url =
          'https://fcm.googleapis.com/v1/projects/$projectId/messages:send';

      // 5. Build the notification message
      final message = {
        "message": {
          "token": deviceToken,
          "notification": {
            "title": person.name,
            "body": sentMessage,
          },
          "data": {
            "chatId": person.firebaseUid.toString(),
          }
        }
      };
print(message);
print(message);
print(message);
print(message);
print(message);

      // 6. Send the push notification using Dio
      final response = await dio.post(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
        ),
        data: jsonEncode(message),
      );

      if (response.statusCode == 200) {
        print('Push notification sent successfully ✅');
      } else {
        print(
            'Failed to send push notification ❌: ${response.statusCode} ${response.data}');
      }
    } catch (e) {
      print('Error sending push notification ❌: $e');
    }
  }
}
