import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Components/CommonFunctions.dart';
import '../../../Firebase/controllers/firebase_auth.dart';
import '../../../Models/UserModel.dart';

class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade700,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top greeting
          Padding(
            padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 50.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24.r,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.r))),
                        child: ClipOval(
                          child: CachedNetworkImage(
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                              imageUrl: auth.currentUser!.photoURL!),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Good Morning,",
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400),
                        ),
                        Text(
                          "${capitalizeFirstLetter(auth.currentUser!.displayName!)} 👋",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    FirebaseAuthentication().signOut(context);
                  },
                  child: Icon(Icons.logout, color: Colors.white, size: 28.sp),
                ),
              ],
            ),
          ),
          SizedBox(height: 30.h),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.r),
                  topRight: Radius.circular(30.r),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Chat title with count
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Chat",
                        style: TextStyle(
                            fontSize: 24.sp, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 5.h),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          "24",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildTabButton("Personal", isSelected: true),
                      _buildTabButton("Group"),
                      _buildTabButton("Community"),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  // Pinned chats
                  Text(
                    "PINNED",
                    style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                  ),
                  SizedBox(height: 10.h),
                  _buildChatTile(
                    name: "Charlie Rosser",
                    message: "Can I have both?",
                    time: "11:52 PM",
                    imageUrl: "https://i.pravatar.cc/150?img=10",
                  ),
                  _buildChatTile(
                    name: "Jakob Schleifer",
                    message: "Danielle is Typing...",
                    time: "11:52 PM",
                    imageUrl: "https://i.pravatar.cc/150?img=20",
                    isTyping: true,
                  ),
                  SizedBox(height: 20.h),
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
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final List<UserModel> users =
                              snapshot.data!.docs.map((doc) {
                            final data = doc.data() as Map<String, dynamic>;
                            return UserModel.fromMap(data);
                          }).toList();
                    
                          return ListView.builder(
                            itemCount: users.length,
                            padding: const EdgeInsets.all(0).r,
                            itemBuilder: (context, index) {
                              final user = users[index];
                              return _buildChatTile(
                                name: user.name,
                                message: "${user.name} is Typing...",
                                time: "${user.createdAt}",
                                imageUrl: user.imageUrl,
                                isTyping: true,
                              );
                            },
                          );
                        } else if (snapshot.hasError) {
                          return Center(child: Text("Something went wrong"));
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ),
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

  Widget _buildTabButton(String title, {bool isSelected = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        title,
        style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildChatTile({
    required String name,
    required String message,
    required String time,
    required String imageUrl,
    bool isTyping = false,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 5.h),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
        radius: 24.r,
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
