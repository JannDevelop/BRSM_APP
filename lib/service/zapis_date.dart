import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';




class UserData {
  String nomer;
  String name;
  String lastname;
  String fathername;

  UserData({
    required this.nomer,
    required this.name,
    required this.lastname,
    required this.fathername,
  });

  Map<String, dynamic> toMap() {
    return {
      'nomer': nomer,
      'name': name,
      'lastname': lastname,
      'fathername': fathername,
    };
  }
}


Future<void> saveUserData({
  required String nomer,
  required String name,
  required String lastname,
  required String fathername,
}) async {
  User? firebaseUser = FirebaseAuth.instance.currentUser;

  if (firebaseUser != null) {
    UserData userData = UserData(
      nomer: nomer,
      name: name,
      lastname: lastname,
      fathername: fathername,
    );

    await FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser.uid)
        .set({
      ...userData.toMap(),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}

