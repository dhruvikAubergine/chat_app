import 'package:chat_app/features/home/modals/user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/widgets.dart';

/// Provides properties for common data management like login session details.
class AppService extends ChangeNotifier {
  // Ensures end-users cannot initialize the class.
  AppService._();
  static AppService get instance => _instance;
  static final AppService _instance = AppService._();

  UserProfile? currentUser;

  String get userId => auth.FirebaseAuth.instance.currentUser!.uid;

  Future<void> updateCurrentUser(UserProfile user) async {
    if (currentUser == user) return;
    currentUser = user;
    notifyListeners();
  }
}
