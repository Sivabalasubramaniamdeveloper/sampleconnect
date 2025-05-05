import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sampleconnect/Models/ChatModel.dart';
import 'package:sampleconnect/Models/MessageModel.dart';
import 'package:sampleconnect/Screens/Personalchat/cubit/chat_message_state.dart';
import '../../../Components/CommonFunctions.dart';

class ChatMessageCubit extends Cubit<ChatMessageState> {
  ChatMessageCubit() : super(ChatMessageState());
  final _db = FirebaseFirestore.instance;

  Future<void> loadMessages(String uuid1, String uuid2) async {
    String chatId = generateChatID(uuid1, uuid2);
    _db.collection('messages').doc(chatId).snapshots().listen(
      (snapshot) {
        final docs = snapshot.data();
        var pay = {
          "id": chatId,
          "messages": (docs?['messages'] as List)
              .map((message) => MessageModel.fromMap(message))
              .toList(),
          "participants": [uuid1, uuid2]
        };
        emit(
            ChatMessageState(message: "success", data: ChatModel.fromMap(pay)));
      },
      onError: (error) {
        emit(ChatMessageState(
          message: "Failed to load users",
          data: ChatModel(id: '2', participants: [], messages: []),
        ));
      },
    );
  }

  Future<MessageModel?> loadMessagesLastMessage(String uuid1, String uuid2) async {
    String chatId = generateChatID(uuid1, uuid2);

    try {
      final snapshot = await _db.collection('messages').doc(chatId).get();
      final docs = snapshot.data();

      if (docs == null || (docs['messages'] as List).isEmpty) {
        return null;
      } else {
        return MessageModel.fromMap((docs['messages'] as List).last);
      }
    } catch (error) {
      print('Error fetching last message: $error');
      return null;
    }
  }

}
