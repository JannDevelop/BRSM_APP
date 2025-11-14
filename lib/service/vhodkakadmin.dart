import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future <bool> isAdmin() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return false;

  final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

  if (!doc.exists) return false;

  final roles = List<String>.from(doc['roles'] ?? []);
  return roles.contains('admin');
}
