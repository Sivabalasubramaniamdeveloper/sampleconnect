import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../Components/CustomToast/CustomToast.dart';
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
}
