import 'package:chat_bubbles/message_bars/message_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sampleconnect/Utils/Constants/TextStyle.dart';
import '../../../../Components/CommonFunctions.dart';
import '../../../../Models/UserModel.dart';
import '../Widgets/Messages.dart';

class PersonalChat extends StatefulWidget {
  final UserListModel chatPerson;
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
        backgroundColor: Theme.of(context).primaryColor,
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
                  capitalizeFirstLetter(widget.chatPerson.name),
                  style: TextStyleClass.textSize18Bold(
                      color: Theme.of(context).hintColor),
                ),
                Text(
                  widget.chatPerson.status == "online"
                      ? widget.chatPerson.status
                      : formatTimestampToTime(widget.chatPerson.lastSeen),
                  style: TextStyleClass.textSize12Bold(
                      color: widget.chatPerson.status == "online"
                          ? Colors.green
                          : Colors.red),
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
            color: Theme.of(context).hintColor,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Theme.of(context).hintColor,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).hintColor,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: ChatScreen(
        chatPerson: widget.chatPerson,
      ),
    );
  }
}
