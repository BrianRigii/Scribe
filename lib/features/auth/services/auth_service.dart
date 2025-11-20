import 'dart:developer';
import 'package:appwrite/models.dart' hide User;
import 'package:flutter/material.dart';
import 'package:scribe/core/appwrite_service.dart';
import 'package:scribe/core/database_service.dart';
import 'package:scribe/core/uuid.dart';
import 'package:scribe/features/auth/models/user.dart';

enum AuthStatus { unauthenticated, authenticated, loading }

class AuthService extends ChangeNotifier {
  final AppWriteService client;
  final DatabaseService database;

  AuthStatus status = AuthStatus.unauthenticated;
  User? get currentUser =>
      database.userBox.isNotEmpty ? database.userBox.getAt(0) : null;

  AuthService({required this.client, required this.database});

  // -----------------------------
  // CHECK INITIAL AUTH STATE
  // -----------------------------
  Future<void> checkAuthState() async {
    try {
      if (currentUser != null) {
        status = AuthStatus.authenticated;
      } else {
        status = AuthStatus.unauthenticated;
      }
    } catch (e) {
      status = AuthStatus.unauthenticated;
    }
  }

  // -----------------------------
  // SIGN UP
  // -----------------------------
  Future<void> signUp(String email, String password) async {
    try {
      status = AuthStatus.loading;
      notifyListeners();

      await client.account.create(
        userId: generateUuid(),
        email: email,
        password: password,
      );

      // Auto-login after signup
      await login(email, password);
    } catch (e) {
      status = AuthStatus.unauthenticated;
      notifyListeners();
      log("SignUp Error: $e");
      rethrow;
    }
  }

  // -----------------------------
  // LOGIN
  // -----------------------------
  Future<void> login(String email, String password) async {
    try {
      status = AuthStatus.loading;
      notifyListeners();

      Session session = await client.account.createEmailPasswordSession(
        email: email,
        password: password,
      );

      final user = await client.account.get();

      await database.userBox.clear(); // Clear previous user data
      await database.userBox.add(
        User.fromJson(user.toMap()),
      ); // Store current user

      status = AuthStatus.authenticated;
      notifyListeners();
    } catch (e) {
      status = AuthStatus.unauthenticated;
      notifyListeners();
      log("Login Error: $e");
      rethrow;
    }
  }

  // -----------------------------
  // FETCH CURRENT USER
  // -----------------------------
  // Future<void> fetchCurrentUser() async {
  //   try {
  //     final raw = await client.account.get();
  //     currentUser = User.fromJson(raw.toMap());
  //   } catch (e) {
  //     log("FetchCurrentUser Error: $e");
  //     currentUser = null;
  //   }
  // }

  // -----------------------------
  // LOGOUT
  // -----------------------------
  Future<void> logout() async {
    try {
      status = AuthStatus.loading;
      notifyListeners();

      await client.account.deleteSession(sessionId: 'current');

      await database.userBox.clear();
      status = AuthStatus.unauthenticated;

      notifyListeners();
    } catch (e) {
      log("Logout Error: $e");
      rethrow;
    }
  }
}
