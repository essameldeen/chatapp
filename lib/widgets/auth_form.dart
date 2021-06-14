import 'dart:io';

import 'package:chatapp/widgets/picke_image.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final Function sumbmitForm;
  final bool isLoading;

  AuthForm(this.sumbmitForm, this.isLoading);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formkey = GlobalKey<FormState>();
  var _isLogin = true;
  String _username = "";
  String _email = "";
  String _password = "";
  File imagePicked;

  @override
  Widget build(BuildContext context) {
    void _submit() {
      final isValid = _formkey.currentState.validate();
      if (imagePicked == null && !_isLogin) {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text("please picked an image"),
            backgroundColor: Theme.of(context).errorColor,
          ),
        );
        return;
      }
      if (isValid) {
        FocusScope.of(context).unfocus(); // to close softkeyboard
        _formkey.currentState.save();

        widget.sumbmitForm(_email.trim(), _password.trim(), _username.trim(),
            _isLogin, imagePicked, context);
      }
    }

    void _selectedImage(File image) {
      imagePicked = image;
    }

    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_isLogin) PickedImage(_selectedImage),
                  TextFormField(
                    key: ValueKey('email'),
                    validator: (value) {
                      if (value.isEmpty || !value.contains('@')) {
                        return "please enter a valid email address";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'email',
                    ),
                    onSaved: (value) {
                      _email = value;
                    },
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey('username'),
                      onSaved: (value) {
                        _username = value;
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return "please enter username";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Username',
                      ),
                    ),
                  TextFormField(
                    key: ValueKey('password'),
                    onSaved: (value) {
                      _password = value;
                    },
                    validator: (value) {
                      if (value.isEmpty || value.length <= 5) {
                        return "please enter a Strong Password ";
                      }
                      return null;
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (widget.isLoading) CircularProgressIndicator(),
                  if (!widget.isLoading)
                    RaisedButton(
                      onPressed: _submit,
                      child: Text(_isLogin ? "LOGIN" : "SING UP"),
                    ),
                  if (!widget.isLoading)
                    FlatButton(
                        textColor: Theme.of(context).primaryColor,
                        onPressed: () {
                          setState(() {
                            _isLogin = !_isLogin;
                          });
                        },
                        child: Text(_isLogin
                            ? 'Create New Account?'
                            : "I have Account.")),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
