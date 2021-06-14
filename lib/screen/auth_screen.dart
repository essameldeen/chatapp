import 'dart:io';

import 'package:chatapp/widgets/auth_form.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  void _submitForm(String email, String password, String username, bool isLogin,
      File image, BuildContext ctx) async {
    UserCredential result;
    try {
      setState(() {
        _isLoading = true;
      });

      if (isLogin) {
        result = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        print(result.user);
      } else {
        result = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        final ref = FirebaseStorage.instance.ref().child("user_image").child(
            result.user.uid + ".jpg"); // reference of storage in firebase

        await ref.putFile(image);
        final urlUserImage = await ref.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(result.user.uid)
            .set({
          'email': email,
          'username': username,
          'imageUrl':urlUserImage,
        });
      }
    } on PlatformException catch (e) {
      setState(() {
        _isLoading = false;
      });

      var message = 'an error occurred, please check your credentials!';
      if (e.message != null) {
        message = e.message;
      }
      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitForm, _isLoading),
    );
  }
}
