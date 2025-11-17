import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:scribe/core/appwrite_service.dart';
import 'package:scribe/core/uuid.dart';
import 'package:scribe/features/auth/models/user.dart';

enum AuthStatus { unauthenticated, authenticated, loading }

class AuthService extends ChangeNotifier {
  final AppWriteService client;

  AuthStatus status = AuthStatus.unauthenticated;
  User? currentUser;

  AuthService({required this.client});

  // -----------------------------
  // CHECK INITIAL AUTH STATE
  // -----------------------------
  Future<void> checkAuthState() async {
    try {
      await fetchCurrentUser();

      if (currentUser != null) {
        status = AuthStatus.authenticated;
      } else {
        status = AuthStatus.unauthenticated;
      }
      notifyListeners();
    } catch (e) {
      status = AuthStatus.unauthenticated;
      currentUser = null;
      notifyListeners();
      log("CheckAuthState Error: $e");
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

      await client.account.createEmailPasswordSession(
        email: email,
        password: password,
      );

      await fetchCurrentUser();

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
  Future<void> fetchCurrentUser() async {
    try {
      final raw = await client.account.get();
      currentUser = User.fromJson(raw.toMap());
    } catch (e) {
      log("FetchCurrentUser Error: $e");
      currentUser = null;
    }
  }

  // -----------------------------
  // LOGOUT
  // -----------------------------
  Future<void> logout() async {
    try {
      status = AuthStatus.loading;
      notifyListeners();

      await client.account.deleteSession(sessionId: 'current');

      currentUser = null;
      status = AuthStatus.unauthenticated;

      notifyListeners();
    } catch (e) {
      log("Logout Error: $e");
      rethrow;
    }
  }
}
