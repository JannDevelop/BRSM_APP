import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  static Future<bool> registerWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Регистрация прошла успешно!'),
          backgroundColor: Colors.green,
        ),
      );

      return true; // регистрация успешна
    } on FirebaseAuthException catch (e) {
      String message = 'Ошибка регистрации';
      if (e.code == 'email-already-in-use') {
        message = 'Пользователь с таким email уже существует';
      } else if (e.code == 'weak-password') {
        message = 'Слабый пароль, минимум 6 символов';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );

      return false; // регистрация неудачна
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка: $e'),
          backgroundColor: Colors.red,
        ),
      );

      return false;
    }
  }
}
