import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class AuthService {
  Future<bool> signInWithEmail({
    required String email,
    required String password,
    required BuildContext context
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      return true;
    }
      on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'user-not-found') {
        message = 'Пользователь с таким email не найден.';
      } else if (e.code == 'wrong-password') {
        message = 'Неверный пароль.';
      } else {
        message = 'Ошибка авторизации: ${e.message}';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );

      return false;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Произошла ошибка: $e')),
      );
      return false;
    }
  }
}