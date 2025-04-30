import 'package:chat_bubbles/message_bars/message_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sampleconnect/Utils/Constants/TextStyle.dart';

import '../../../Firebase/controllers/firebase_firestore.dart';
import '../../../Models/MessageModel.dart';
import '../../../Models/UserModel.dart';
import '../../../Utils/Constants/ColorConstants.dart';

class PersonalChat extends StatefulWidget {
  final UserModel chatPerson;
  const PersonalChat({super.key, required this.chatPerson});

  @override
  State<PersonalChat> createState() => _PersonalChatState();
}

class _PersonalChatState extends State<PersonalChat> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xFF1B1424), // Dark background
      appBar: AppBar(
        backgroundColor: Color(0xFF1B1424),
        elevation: 3,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.chatPerson.imageUrl),
              radius: 17.r,
            ),
            SizedBox(
              width: 10.w,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.chatPerson.name,
                  style: TextStyleClass.textSize18Bold(
                      color: KConstantColors.white),
                ),
                Text(
                  "Online",
                  style: TextStyleClass.textSize12Bold(color: Colors.green),
                ),
              ],
            ),
          ],
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_new_outlined,
            size: 24.sp,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Spacer(),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 16).r,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.all(12),
                    margin: EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      color: Color(0xFF2A2235),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "https://bit.ly/3JHS2WI",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                // Reaction emoji
                Padding(
                  padding: EdgeInsets.only(left: 12),
                  child: Text("❤️ 3", style: TextStyle(color: Colors.white)),
                ),
                // User Message (right aligned)
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: EdgeInsets.all(12),
                    margin: EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      color: Color(0xFF6A58FB),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "Done",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: EdgeInsets.all(12),
                    margin: EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      color: Color(0xFF6A58FB),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "Thank you!!",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),

                // Image message
              ],
            ),
          ),

          MessageBar(
            onSend: (message) => FirebaseFireStore().sendMessage(
                auth.currentUser!.uid,
                widget.chatPerson.firebaseUid,
                MessageModel(
                  senderID: auth.currentUser!.uid,
                  content: message,
                  sentAt: DateTime.now(),
                )),
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
          )
          // Bottom Input Field can go here (optional)
        ],
      ),
    );
  }
}
