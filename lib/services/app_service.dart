import 'package:chat_app/features/home/modals/user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';

/// Provides properties for common data management like login session details.
class AppService extends ChangeNotifier {
  // Ensures end-users cannot initialize the class.
  AppService._();
  static AppService get instance => _instance;
  static final AppService _instance = AppService._();

  UserProfile? currentUser;

  final Box storageBox = Hive.box('App Service Box');

  String get userId => auth.FirebaseAuth.instance.currentUser!.uid;

  void initialize() {
    final UserProfile? user;
    user = storageBox.get('current_user') as UserProfile?;
    if (user != null) currentUser = user;
  }

  Future<void> updateCurrentUser(UserProfile user) async {
    if (currentUser == user) return;
    currentUser = user;
    await storageBox.put('current_user', user);
    notifyListeners();
  }

  Future<void> terminate() async {
    currentUser = null;
    await storageBox.clear();
  }
}
