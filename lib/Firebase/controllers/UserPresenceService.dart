import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class UserPresenceService with WidgetsBindingObserver {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  void initialize() {
    WidgetsBinding.instance.addObserver(this);
    _updateUserStatus('online');
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _updateUserStatus('offline');
  }

  void _updateUserStatus(String status) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'status': status,
        'lastSeen': DateTime.now(),
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _updateUserStatus('online');
      print("sssssssssssssssssssssssssssssssssssssonline");
    } else if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      _updateUserStatus('offline');
      print("sssssssssssssssssssssssssssssssssssssoffline");
    }
  }
}
