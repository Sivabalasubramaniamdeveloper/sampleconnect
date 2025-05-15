import 'package:chat_bubbles/message_bars/message_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sampleconnect/Utils/Constants/TextStyle.dart';
import '../../../../Components/CommonFunctions.dart';
import '../../../../Models/UserModel.dart';
import '../../../UserList/cubit/user_list_cubit.dart';
import '../../../UserList/cubit/user_list_state.dart';
import '../Widgets/Messages.dart';

class PersonalChat extends StatefulWidget {
  final String chatPerson;
  const PersonalChat({super.key, required this.chatPerson});

  @override
  State<PersonalChat> createState() => _PersonalChatState();
}

class _PersonalChatState extends State<PersonalChat> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserListCubit, UserListState>(
      builder: (context, state) {
        if (state.data != null && state.data!.isNotEmpty) {
          final user = state.data!.firstWhere(
              (user) => user.firebaseUid == widget.chatPerson);

          return Scaffold(
            // backgroundColor: Color(0xFF1B1424), // Dark background
            appBar: AppBar(
              backgroundColor: Theme.of(context).primaryColor,
              elevation: 3,
              title: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(user.imageUrl),
                    radius: 17.r,
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        capitalizeFirstLetter(user.name),
                        style: TextStyleClass.textSize18Bold(
                            color: Theme.of(context).hintColor),
                      ),
                      Text(
                        user.status == "online"
                            ? user.status
                            : formatTimestampToTime(user.lastSeen),
                        style: TextStyleClass.textSize12Bold(
                            color: user.status == "online"
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
              chatPerson: user,
            ),
          );
        } else if (state.message == "Failed to load users") {
          return const Center(child: Text("Something went wrong"));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
