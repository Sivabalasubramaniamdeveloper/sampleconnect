import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sampleconnect/Models/UserModel.dart';
import '../../../Components/CustomToast/CustomToast.dart';
import 'user_list_state.dart';

class UserListCubit extends Cubit<UserListState> {
  UserListCubit() : super(UserListState());
  final _db = FirebaseFirestore.instance;

  Future<void> listenToChat() async {
    _db.collection('users').snapshots().listen(
      (snapshot) {
        final docs = snapshot.docs;
        if (docs.isNotEmpty) {
          print("docs.length");
          print(docs.first.data());
          final usersList =
              docs.map((doc) => UserListModel.fromMap(doc.data())).toList();

          emit(UserListState(
            message: 'success',
            data: usersList,
          ));
        } else {
          emit(UserListState(
            message: 'No users found',
            data: [],
          ));
        }
      },
      onError: (error) {
        emit(UserListState(
          message: "Failed to load users",
          data: [],
        ));
      },
    );
  }

  Future<void> insertUser(UserListModel user, String firebaseUid) async {
    try {
      DocumentSnapshot document =
          await _db.collection('users').doc(firebaseUid).get();
      if (document.exists) {
        return;
      } else {
        final userMap = user.toMap();
        await _db.collection('users').doc(user.firebaseUid).set(userMap);
      }
    } catch (err) {
      showErrorToast("Failed to insert user");
      throw FirebaseAuthException(
        code: 'Insert user failed',
        message: 'Failed to insert user: $err',
      );
    }
  }
}
