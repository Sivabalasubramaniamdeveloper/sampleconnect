import '../../../Models/UserModel.dart';

class UserListState {
  String? message;
  List<UserListModel>? data;

  UserListState({this.message, this.data});

  UserListState.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = (json['data'] as List)
          .map((item) => UserListModel.fromMap(item))
          .toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {};
    result['message'] = message;
    if (data != null) {
      result['data'] = data!.map((user) => user.toMap()).toList();
    }
    return result;
  }
}


