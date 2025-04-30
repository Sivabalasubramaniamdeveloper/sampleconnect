class MessageModel {
  final String senderID;
  final String content;
  final DateTime sentAt;

  MessageModel({
    required this.senderID,
    required this.content,
    required this.sentAt,
  });

  // Factory method to create a MessageModel from JSON (Map)
  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      senderID: map['senderID'] as String,
      content: map['content'] as String,
      sentAt: DateTime.parse(map['sentAt'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderID': senderID,
      'content': content,
      'sentAt': sentAt.toIso8601String(),
    };
  }
}
