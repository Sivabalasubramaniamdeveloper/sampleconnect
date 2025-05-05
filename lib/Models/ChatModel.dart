import 'MessageModel.dart';

class ChatModel {
  final String id;
  final List<dynamic> participants;
  final List<MessageModel> messages;

  ChatModel({
    required this.id,
    required this.participants,
    required this.messages,
  });

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      id: map['id'] as String,
      participants: map['participants'] as List<dynamic>,
      messages: map['messages'] as List<MessageModel>,
    );
  }

  // Method to convert ChatModel to JSON
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'participants': participants,
      'messages': messages,
    };
  }
}
