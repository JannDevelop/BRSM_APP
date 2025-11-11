import 'package:firebase_auth/firebase_auth.dart';


Future<bool> resetPassword(String email) async {
  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    return true; // письмо отправлено успешно
  } catch (e) {
    print("Ошибка сброса пароля: $e");
    return false; // произошла ошибка
  }
}


