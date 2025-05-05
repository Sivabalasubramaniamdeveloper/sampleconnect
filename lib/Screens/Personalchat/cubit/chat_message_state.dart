import '../../../Models/ChatModel.dart';

class ChatMessageState {
  String? message;
  ChatModel? data;

  ChatMessageState({this.message, this.data});

  factory ChatMessageState.fromJson(Map<String, dynamic> json) {
    return ChatMessageState(
      message: json['message'],
      data: json['data'] != null ? ChatModel.fromMap(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {};
    result['message'] = message;
    if (data != null) {
      result['data'] = data!.toMap();
    }
    return result;
  }
}

