import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:chat_bubbles/message_bars/message_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sampleconnect/Screens/Personalchat/cubit/chat_message_state.dart';

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
  // Sent and received messages stored separately
  List<Message> sentMessages = [];
  List<Message> receivedMessages = [];

  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    final message = Message(
      text: text,
      isSentByMe: true,
      timestamp: DateTime.now(),
    );

    setState(() {
      sentMessages.add(message);
    });

    _controller.clear();

    // Simulate receiving a reply after 1 second
    Future.delayed(const Duration(seconds: 1), () {
      final reply = Message(
        text: "Reply to: $text",
        isSentByMe: false,
        timestamp: DateTime.now(),
      );

      setState(() {
        receivedMessages.add(reply);
      });
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserList();

  }
  Future<void> getUserList() async {
    try {
      await context.read<ChatMessageCubit>().loadMessages(auth.currentUser!.uid, widget.chatPerson.firebaseUid);
    } on DioException catch (e) {

    }
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
                      color: Color(0xFF1B1424),
                      constraints: BoxConstraints(maxWidth: 200.0),
                      delivered: message.senderID == auth.currentUser!.uid?true:false,
                      textStyle: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                    return Align(
                      alignment: message.senderID == auth.currentUser!.uid
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: message.senderID == auth.currentUser!.uid
                              ? Colors.blue[200]
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(message.content),
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
            onSend: (message) {
              FirebaseFireStore().sendMessage(
                  auth.currentUser!.uid,
                  widget.chatPerson.firebaseUid,
                  MessageModel(
                    senderID: auth.currentUser!.uid,
                    content: message,
                    sentAt: DateTime.now(),
                  ));
              _sendMessage(message);
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
}

// Message model
class Message {
  final String text;
  final bool isSentByMe;
  final DateTime timestamp;

  Message({
    required this.text,
    required this.isSentByMe,
    required this.timestamp,
  });
}
