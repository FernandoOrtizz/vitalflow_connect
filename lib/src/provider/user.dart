import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CurrentUser extends ChangeNotifier {
  UserCredential? _currentUser;

  UserCredential? get currentUser => _currentUser;

  set currentUser(UserCredential? user) {
    _currentUser = user;
    notifyListeners();
  }
}
