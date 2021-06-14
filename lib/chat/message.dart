import 'package:chatapp/chat/message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Messages extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (ctx, chatSnapshot) {
          if (chatSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (chatSnapshot.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            reverse: true,
            itemCount: chatSnapshot.data.docs.length,
            itemBuilder: (_, index) {
              return MessageBubble(
                chatSnapshot.data.docs[index]['text'],
                chatSnapshot.data.docs[index]['userId'] == user.uid,
                chatSnapshot.data.docs[index]['userName'],
                chatSnapshot.data.docs[index]['userImage'],
                uniqKey: ValueKey(chatSnapshot.data.docs[index].id),
              );
            },
          );
        });
  }
}
