import 'dart:async';
import 'dart:developer' as dev;

import 'package:chat_app/features/home/modals/conversation.dart';
import 'package:chat_app/features/home/modals/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/widgets.dart';

class ChatsProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final userId = auth.FirebaseAuth.instance.currentUser!.uid;

  late StreamSubscription<QuerySnapshot> _conversationSubscription;

  List<Conversation> conversations = [];
  List<Message> chats = [];

  void getConversations() {
    try {
      _conversationSubscription = _db
          .collection('chats')
          // .orderBy('lastMessage.timestamp', descending: true)
          .where(
            'users',
            arrayContains: auth.FirebaseAuth.instance.currentUser!.uid,
          )
          .snapshots()
          .listen(
        (snapshot) {
          conversations = snapshot.docs.map((document) {
            final data = document.data()..putIfAbsent('id', () => document.id);
            return Conversation.fromJson(data);
          }).toList();
          notifyListeners();
        },
      );
    } catch (error) {
      dev.log(error.toString());
    }
  }

  // void getChats(String convoId) {
  //   try {
  //     _chatSubscription = _db
  //         .collection('chats')
  //         .doc(convoId)
  //         .collection(convoId)
  //         .orderBy('timestamp', descending: true)
  //         .snapshots()
  //         .listen((snapshot) {
  //       chats = snapshot.docs.map((document) {
  //         final data = document.data()..putIfAbsent('id', () => document.id);
  //         return Message.fromJson(data);
  //       }).toList();
  //       notifyListeners();
  //     });
  //   } catch (error) {
  //     dev.log(error.toString());
  //   }
  // }

  // Future<UserProfile> getUserById(String id) async {
  //   UserProfile user;
  //   final docSnapshot = await _db.collection('users').doc(id).get();
  //   //     .then((value) => user = UserProfile.fromJson(value.data()!));
  //   // return user;

  //   if (docSnapshot.exists) {
  //     user = UserProfile.fromJson(docSnapshot.data()!);
  //   } else {
  //     return const UserProfile();
  //   }
  //   return user;
  // }

  void updateMessageRead(String convoId, String messageId) {
    _db.collection('chats').doc(convoId).collection(convoId).doc(messageId).set(
      {'read': true},
      SetOptions(merge: true),
    );
    _db.collection('chats').doc(convoId).update(
      {'lastMessage.read': true},
    );
  }

  void sendMessage(
    String convoId,
    String uid,
    String pid,
    String content,
    String timestamp,
  ) {
    _db.collection('chats').doc(convoId).set({
      'lastMessage': {
        'idFrom': uid,
        'idTo': pid,
        'timestamp': timestamp,
        'content': content,
        'read': false
      },
      'users': [uid, pid]
    }).then((dynamic success) {
      final messageDoc = _db
          .collection('chats')
          .doc(convoId)
          .collection(convoId)
          .doc(timestamp);
      _db.runTransaction((transaction) async {
        transaction.set(messageDoc, {
          'idFrom': uid,
          'idTo': pid,
          'timestamp': timestamp,
          'content': content,
          'read': false
        });
      });
    });
  }

  Future<void> disposeStream() async {
    await _conversationSubscription.cancel();
  }
}
