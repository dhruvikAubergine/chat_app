import 'dart:async';

import 'package:chat_app/features/home/modals/user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/widgets.dart';

class UserProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final currentUserId = auth.FirebaseAuth.instance.currentUser!.uid;
  late StreamSubscription<QuerySnapshot> _userSubscription;
  List<UserProfile> usersList = [];

  void getUsers() {
    _userSubscription = _db.collection('users').snapshots().listen(
      (snapshot) {
        usersList = snapshot.docs.map((document) {
          final data = document.data()..putIfAbsent('id', () => document.id);
          return UserProfile.fromJson(data);
        }).toList();
        notifyListeners();
      },
    );
  }

  UserProfile getUserById(String id) {
    if (id != '') {
      return usersList.singleWhere((element) => element.id == id);
    }
    return const UserProfile();
  }

  Future<UserProfile> fetchCurrentUser(String id) async {
    UserProfile user;
    final docSnapshot = await _db.collection('users').doc(id).get();

    if (docSnapshot.exists) {
      user = UserProfile.fromJson(docSnapshot.data()!);
    } else {
      return const UserProfile();
    }
    return user;
  }

  Future<void> disposeStream() async {
    await _userSubscription.cancel();
  }
}
