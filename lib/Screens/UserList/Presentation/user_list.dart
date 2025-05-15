import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sampleconnect/Models/MessageModel.dart';
import 'package:sampleconnect/Utils/Constants/ColorConstants.dart';
import 'package:sampleconnect/Utils/Constants/TextConstants.dart';
import '../../../Components/CommonFunctions.dart';
import '../../../Firebase/controllers/firebase_firestore.dart';
import '../../../Models/UserModel.dart';
import '../../../Utils/Constants/CustomWidgets.dart';
import '../../Personalchat/Presentation/Screens/personal_chat.dart';
import '../../Personalchat/cubit/chat_message_cubit.dart';
import '../cubit/user_list_cubit.dart';
import '../cubit/user_list_state.dart';

class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserList();
  }

  Future<void> getUserList() async {
    try {
      await context.read<UserListCubit>().listenToChat();
      analytics.setAnalyticsCollectionEnabled(true);
      await analytics.logEvent(
        name: 'screen_view',
        parameters: {
          'screen_name': 'chatpage',
        },
      );
    } on DioException catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.r),
                  topRight: Radius.circular(30.r),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        TextConstants.chat,
                        style: TextStyle(
                            fontSize: 24.sp, fontWeight: FontWeight.bold),
                      ),
                      BlocBuilder<UserListCubit, UserListState>(
                          builder: (context, state) {
                        if (state.data != null && state.data!.isNotEmpty) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 5.h),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade100,
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Text(
                              "${state.data!.length - 1}",
                              style: TextStyle(color: Colors.blue),
                            ),
                          );
                        } else if (state.message == "Failed to load users") {
                          return const Center(
                              child: Text("Something went wrong"));
                        } else {
                          return const Center(
                              child: SizedBox());
                        }
                      }),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  // All Chats
                  Text(
                    "ALL CHAT",
                    style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                  ),
                  // SizedBox(height: 10.h),
                  Expanded(
                    child: BlocBuilder<UserListCubit, UserListState>(
                      builder: (context, state) {
                        if (state.data != null && state.data!.isNotEmpty) {
                          final currentUserId =
                              FirebaseAuth.instance.currentUser?.uid;
                          final users = state.data!
                              .where(
                                  (user) => user.firebaseUid != currentUserId)
                              .toList();

                          return ListView.builder(
                            itemCount: users.length,
                            padding: const EdgeInsets.all(0).r,
                            itemBuilder: (context, index) {
                              final user = users[index];

                              return StreamBuilder<MessageModel?>(
                                stream: context
                                    .read<ChatMessageCubit>()
                                    .loadMessagesLastMessage(
                                      currentUserId!,
                                      user.firebaseUid,
                                    ),
                                builder: (context, snapshot) {
                                  final lastMessage = limitMessage(
                                      snapshot.data?.content ?? '',
                                      limit: 20);

                                  return GestureDetector(
                                    onTap: () async {
                                      final chatExists =
                                          await FirebaseFireStore()
                                              .checkChatExist(currentUserId,
                                                  user.firebaseUid);
                                      if (!chatExists) {
                                        await FirebaseFireStore().createChat(
                                            currentUserId, user.firebaseUid);
                                      }
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PersonalChat(chatPerson: user.firebaseUid),
                                        ),
                                      );
                                    },
                                    child: _buildChatTile(
                                      name: user.name,
                                      online: user.status == "online",
                                      message: lastMessage.isNotEmpty
                                          ? lastMessage
                                          : "No messages yet",
                                      time: "${snapshot.data?.sentAt}",
                                      imageUrl: user.imageUrl,
                                      isTyping: false, // optional
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        } else if (state.message == "Failed to load users") {
                          return const Center(
                              child: Text("Something went wrong"));
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.blue,
        child: Icon(Icons.chat, color: Colors.white),
      ),
    );
  }

  Widget _buildChatTile({
    required String name,
    required String message,
    required bool online,
    required String time,
    required String imageUrl,
    bool isTyping = false,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 5.h),
      leading: Badge(
        backgroundColor: online ? Colors.green : Colors.red,
        smallSize: 1,
        offset: Offset(3, 0),
        isLabelVisible: true,
        label: Text(
          "",
          style: TextStyle(fontSize: 8.sp),
        ),
        child: CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
          radius: 24.r,
        ),
      ),
      title: Text(capitalizeFirstLetter(name),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp)),
      subtitle: Text(
        message,
        style: TextStyle(
            color: isTyping ? Colors.blue : Colors.grey.shade600,
            fontStyle: isTyping ? FontStyle.italic : FontStyle.normal),
      ),
      trailing: Text(
        convertToDateTimeString(time),
        style: TextStyle(color: Colors.grey, fontSize: 12.sp),
      ),
    );
  }
}
