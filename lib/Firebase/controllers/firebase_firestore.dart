import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sampleconnect/Components/CommonFunctions.dart';
import 'package:sampleconnect/Screens/ChatList/Presentation/chat_list.dart';

import '../../Components/CustomToast/CustomToast.dart';
import '../../Models/ChatModel.dart';
import '../../Models/MessageModel.dart';
import '../../Models/UserModel.dart';

class FirebaseFireStore {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> insertUser(UserModel user, String firebaseUid) async {
    try {
      DocumentSnapshot document =
          await db.collection('users').doc(firebaseUid).get();
      if (document.exists) {
        return;
      } else {
        final userMap = user.toMap();
        await db.collection('users').doc(user.firebaseUid).set(userMap);
      }
    } catch (err) {
      showErrorToast("Failed to insert user");
      throw FirebaseAuthException(
        code: 'Insert user failed',
        message: 'Failed to insert user: $err',
      );
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUsers() {
    return db.collection('users').snapshots();
  }

  Future<void> createChat(String uuid1, String uuid2) async {
    String chatId = generateChatID(uuid1, uuid2);
    try {
      DocumentSnapshot document =
          await db.collection('messages').doc(chatId).get();
      if (document.exists) {
        return;
      } else {
        final chatMap =
            ChatModel(id: chatId, participants: [uuid1, uuid2], messages: [])
                .toMap();
        await db.collection('messages').doc(chatId).set(chatMap);
      }
    } catch (err) {
      showErrorToast("Failed to Store message");
      throw FirebaseAuthException(
        code: 'Failed to Store message',
        message: 'Failed to Store message: $err',
      );
    }
  }

  Future<void> sendMessage(
      String uuid1, String uuid2, MessageModel message) async {
    String chatId = generateChatID(uuid1, uuid2);
    try {
      final document = db.collection('messages').doc(chatId);
      await document.update({
        "messages": FieldValue.arrayUnion([message.toMap()])
      });
    } catch (err) {
      showErrorToast("Failed to Sent message");
      throw FirebaseAuthException(
        code: 'Failed to Sent message',
        message: 'Failed to Sent message: $err',
      );
    }
  }

  Future<void> lastMessage(String uuid1, String uuid2) async {
    String chatId = generateChatID(uuid1, uuid2);
    try {
      final document = db.collection('messages').doc(chatId);

      document.snapshots().listen((snapshot) {
        if (snapshot.exists) {
          final data = snapshot.data() as Map<String, dynamic>;
          final List<dynamic> messages = data['messages'] ?? [];

          if (messages.isNotEmpty) {
            // Convert the last message map to MessageModel
            final lastMessageMap = messages.last as Map<String, dynamic>;
            final lastMessage = MessageModel.fromMap(lastMessageMap);

            print('Last message content: ${lastMessage.content}');
            print('Sent by: ${lastMessage.senderID}');
            print('At: ${lastMessage.sentAt}');

          } else {
            print('No messages yet.');
          }
        } else {
          print('No chat document found.');
        }
      });
    } catch (err) {
      showErrorToast("Failed to load last message");
      throw FirebaseAuthException(
        code: 'failed-to-load-message',
        message: 'Failed to load last message: $err',
      );
    }
  }


  Future<bool> checkChatExist(String uuid1, String uuid2) async {
    String chatId = generateChatID(uuid1, uuid2);
    final result = await db.collection('messages').doc(chatId).get();
    if (result.exists) {
      return true;
    } else {
      return false;
    }
  }
}
