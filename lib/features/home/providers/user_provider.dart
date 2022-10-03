import 'dart:async';
import 'dart:developer';

import 'package:chat_app/features/home/modals/user_profile.dart';
import 'package:chat_app/services/app_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/widgets.dart';

class UserProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final currentUserId = auth.FirebaseAuth.instance.currentUser!.uid;
  late StreamSubscription<QuerySnapshot> _userSubscription;
  List<UserProfile> usersList = [];

  void getUsers() {
    _userSubscription = _db
        .collection('users')
        .where('id', isNotEqualTo: AppService.instance.currentUser?.id)
        .snapshots()
        .listen(
      (snapshot) {
        usersList = snapshot.docs.map((document) {
          final data = document.data()..putIfAbsent('id', () => document.id);
          return UserProfile.fromJson(data);
        }).toList();
        for (final element in usersList) {
          log(element.toString());
        }
        notifyListeners();
      },
    );
  }

  UserProfile getUserById(String id) {
    if (id != currentUserId && id != '') {
      return usersList.singleWhere((element) => element.id == id);
    }
    return const UserProfile();
  }

  void disposeStream() {
    _userSubscription.cancel();
  }
}
