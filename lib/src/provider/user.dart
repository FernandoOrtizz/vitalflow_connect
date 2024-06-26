import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// CurrentUser represents the current user of
class CurrentUser with ChangeNotifier {
  String _email = FirebaseAuth.instance.currentUser?.email ?? '';
  String get email => _email;

  List<Map<String, dynamic>> _allowedUsersToMonitor = [];
  List<Map<String, dynamic>> get allowedUsersToMonitor =>
      _allowedUsersToMonitor;

  CurrentUser(this._allowedUsersToMonitor);

  set email(String user) {
    _email = user;
    notifyListeners();
  }

  set allowedUsersToMonitor(List<Map<String, dynamic>> users) {
    _allowedUsersToMonitor = users;
    notifyListeners();
  }
}
