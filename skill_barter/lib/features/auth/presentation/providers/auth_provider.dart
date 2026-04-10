import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/user_entity.dart';
import '../../data/datasources/auth_remote_datasource.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthState {
  final AuthStatus status;
  final UserEntity? user;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
  });

  AuthState copyWith({
    AuthStatus? status,
    UserEntity? user,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class AuthProvider extends StateNotifier<AuthState> {
  final AuthRemoteDataSource _dataSource;

  AuthProvider({AuthRemoteDataSource? dataSource})
    : _dataSource = dataSource ?? AuthRemoteDataSourceImpl(),
      super(const AuthState());

  Future<void> checkAuthStatus() async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final user = await _dataSource.getCurrentUser();
      if (user != null) {
        state = state.copyWith(status: AuthStatus.authenticated, user: user);
      } else {
        state = state.copyWith(status: AuthStatus.unauthenticated);
      }
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: e.toString(),
      );
    }
  }

  Future<bool> signInWithEmail(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    try {
      final user = await _dataSource.signInWithEmail(email, password);
      state = state.copyWith(status: AuthStatus.authenticated, user: user);
      return true;
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'No account found with this email';
          break;
        case 'wrong-password':
          message = 'Incorrect password';
          break;
        case 'invalid-email':
          message = 'Please enter a valid email address';
          break;
        case 'user-disabled':
          message = 'This account has been disabled';
          break;
        case 'too-many-requests':
          message = 'Too many failed attempts. Please try again later';
          break;
        case 'network-request-failed':
          message = 'No internet connection';
          break;
        default:
          message = 'Login failed: ${e.message}';
      }
      state = state.copyWith(status: AuthStatus.error, errorMessage: message);
      return false;
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'An error occurred. Please try again.',
      );
      return false;
    }
  }

  Future<bool> signUpWithEmail(
    String name,
    String email,
    String password,
  ) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    try {
      final user = await _dataSource.signUpWithEmail(name, email, password);
      state = state.copyWith(status: AuthStatus.authenticated, user: user);
      return true;
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'email-already-in-use':
          message = 'This email is already registered';
          break;
        case 'weak-password':
          message = 'Password should be at least 6 characters';
          break;
        case 'invalid-email':
          message = 'Please enter a valid email address';
          break;
        case 'operation-not-allowed':
          message = 'Email/password sign up is not enabled';
          break;
        case 'network-request-failed':
          message = 'No internet connection';
          break;
        default:
          message = 'Registration failed: ${e.message}';
      }
      state = state.copyWith(status: AuthStatus.error, errorMessage: message);
      return false;
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'An error occurred. Please try again.',
      );
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    try {
      final user = await _dataSource.signInWithGoogle();
      state = state.copyWith(status: AuthStatus.authenticated, user: user);
      return true;
    } catch (e) {
      String message = e.toString();
      if (message.contains('platform_exception')) {
        message = 'Google sign-in failed. Please try again.';
      }
      state = state.copyWith(status: AuthStatus.error, errorMessage: message);
      return false;
    }
  }

  Future<bool> resetPassword(String email) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      state = state.copyWith(status: AuthStatus.unauthenticated);
      return true;
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'No account found with this email';
          break;
        case 'invalid-email':
          message = 'Please enter a valid email address';
          break;
        case 'network-request-failed':
          message = 'No internet connection';
          break;
        default:
          message = 'Failed to send reset email';
      }
      state = state.copyWith(status: AuthStatus.error, errorMessage: message);
      return false;
    }
  }

  Future<void> signOut() async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      await _dataSource.signOut();
      state = state.copyWith(status: AuthStatus.unauthenticated, user: null);
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  void clearError() {
    state = state.copyWith(
      errorMessage: null,
      status: AuthStatus.unauthenticated,
    );
  }
}

final authProvider = StateNotifierProvider<AuthProvider, AuthState>((ref) {
  return AuthProvider();
});
