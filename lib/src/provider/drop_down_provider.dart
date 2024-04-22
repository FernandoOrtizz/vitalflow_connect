import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DorpDownProvider with ChangeNotifier {
  String dropDownEmail = FirebaseAuth.instance.currentUser?.email ?? '';
}
