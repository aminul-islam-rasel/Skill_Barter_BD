import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../domain/entities/user_entity.dart';
import '../../../../core/constants/app_constants.dart';

abstract class AuthRemoteDataSource {
  Future<UserEntity?> getCurrentUser();
  Future<UserEntity> signInWithEmail(String email, String password);
  Future<UserEntity> signUpWithEmail(
    String name,
    String email,
    String password,
  );
  Future<UserEntity> signInWithGoogle();
  Future<void> signOut();
  Stream<UserEntity?> get authStateChanges;
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FirebaseFirestore _firestore;

  AuthRemoteDataSourceImpl()
    : _firebaseAuth = FirebaseAuth.instance,
      _googleSignIn = GoogleSignIn(),
      _firestore = FirebaseFirestore.instance;

  @override
  Future<UserEntity?> getCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;

    try {
      return await _getUserFromFirestore(user.uid);
    } catch (e) {
      // If user data doesn't exist in Firestore, create from Firebase Auth data
      return _createUserFromFirebaseAuth(user);
    }
  }

  @override
  Future<UserEntity> signInWithEmail(String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user == null) {
        throw Exception('Sign in failed');
      }

      // Try to get user from Firestore
      try {
        final userEntity = await _getUserFromFirestore(credential.user!.uid);
        if (userEntity != null) {
          return userEntity;
        }
      } catch (e) {
        // Continue to create user if not found
      }

      // If user doesn't exist in Firestore, create from Firebase Auth
      return _createUserFromFirebaseAuth(credential.user!);
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      throw Exception('Sign in failed: ${e.toString()}');
    }
  }

  @override
  Future<UserEntity> signUpWithEmail(
    String name,
    String email,
    String password,
  ) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user == null) {
        throw Exception('Sign up failed');
      }

      final user = UserEntity(
        id: credential.user!.uid,
        name: name,
        email: email,
        location: '',
        bio: '',
        creditBalance: AppConstants.defaultCreditBalance,
        trustScore: 0.0,
        ratingAverage: 0.0,
        totalSessions: 0,
        createdAt: DateTime.now(),
      );

      await _saveUserToFirestore(user);
      return user;
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      throw Exception('Sign up failed: ${e.toString()}');
    }
  }

  @override
  Future<UserEntity> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Google sign in was cancelled');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );
      if (userCredential.user == null) {
        throw Exception('Google sign in failed');
      }

      final firebaseUser = userCredential.user!;

      // Try to get existing user from Firestore
      try {
        final existingUser = await _getUserFromFirestore(firebaseUser.uid);
        if (existingUser != null) {
          return existingUser;
        }
      } catch (e) {
        // Continue to create user if not found
      }

      // Create new user
      final user = UserEntity(
        id: firebaseUser.uid,
        name: firebaseUser.displayName ?? 'User',
        email: firebaseUser.email ?? '',
        profilePhoto: firebaseUser.photoURL,
        location: '',
        bio: '',
        creditBalance: AppConstants.defaultCreditBalance,
        trustScore: 0.0,
        ratingAverage: 0.0,
        totalSessions: 0,
        createdAt: DateTime.now(),
      );

      await _saveUserToFirestore(user);
      return user;
    } catch (e) {
      if (e is FirebaseAuthException) {
        rethrow;
      }
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    await Future.wait([_firebaseAuth.signOut(), _googleSignIn.signOut()]);
  }

  @override
  Stream<UserEntity?> get authStateChanges {
    return _firebaseAuth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;
      try {
        return await _getUserFromFirestore(firebaseUser.uid);
      } catch (e) {
        return _createUserFromFirebaseAuth(firebaseUser);
      }
    });
  }

  Future<UserEntity?> _getUserFromFirestore(String uid) async {
    final doc = await _firestore
        .collection(AppConstants.usersCollection)
        .doc(uid)
        .get();
    if (!doc.exists) return null;
    return UserEntity(
      id: doc.id,
      name: doc.get('name') ?? '',
      email: doc.get('email') ?? '',
      profilePhoto: doc.get('profile_photo'),
      location: doc.get('location') ?? '',
      bio: doc.get('bio') ?? '',
      creditBalance: doc.get('credit_balance') ?? 0,
      trustScore: (doc.get('trust_score') ?? 0).toDouble(),
      ratingAverage: (doc.get('rating_average') ?? 0).toDouble(),
      totalSessions: doc.get('total_sessions') ?? 0,
      createdAt:
          (doc.get('created_at') as Timestamp?)?.toDate() ?? DateTime.now(),
      isAdmin: doc.get('is_admin') ?? false,
      isSuspended: doc.get('is_suspended') ?? false,
    );
  }

  Future<void> _saveUserToFirestore(UserEntity user) async {
    await _firestore.collection(AppConstants.usersCollection).doc(user.id).set({
      'name': user.name,
      'email': user.email,
      'profile_photo': user.profilePhoto,
      'location': user.location,
      'bio': user.bio,
      'credit_balance': user.creditBalance,
      'trust_score': user.trustScore,
      'rating_average': user.ratingAverage,
      'total_sessions': user.totalSessions,
      'created_at': Timestamp.fromDate(user.createdAt),
      'is_admin': user.isAdmin,
      'is_suspended': user.isSuspended,
    });
  }

  UserEntity _createUserFromFirebaseAuth(User firebaseUser) {
    return UserEntity(
      id: firebaseUser.uid,
      name:
          firebaseUser.displayName ??
          firebaseUser.email?.split('@').first ??
          'User',
      email: firebaseUser.email ?? '',
      profilePhoto: firebaseUser.photoURL,
      location: '',
      bio: '',
      creditBalance: AppConstants.defaultCreditBalance,
      trustScore: 0.0,
      ratingAverage: 0.0,
      totalSessions: 0,
      createdAt: DateTime.now(),
    );
  }
}
