import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:skool/models/admin_model.dart';
import 'package:skool/models/student_model.dart';
import 'package:skool/models/teacher_model.dart';
import 'package:skool/models/user_model.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRepository({FirebaseAuth? firebaseAuth, FirebaseFirestore? firestore})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
      _firestore = firestore ?? FirebaseFirestore.instance;

  // Stream of authenticated user changes
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // Get current user ID
  String? get currentUserId => _firebaseAuth.currentUser?.uid;

  // Sign Up
  Future<UserModel> register({
    required String email,
    required String password,
    required Map<String, dynamic> userData,
    required UserRole role,
  }) async {
    try {
      // 1. Create user in Firebase Auth
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user!.uid;

      // 2. Prepare user data model
      userData['id'] = uid;
      userData['email'] = email;
      userData['role'] = role.toJson();
      userData['createdAt'] = DateTime.now().toIso8601String();

      UserModel user;
      switch (role) {
        case UserRole.student:
          user = StudentModel.fromJson(userData);
          break;
        case UserRole.teacher:
          user = TeacherModel.fromJson(userData);
          break;
        case UserRole.admin:
          user = AdminModel.fromJson(userData);
          break;
      }

      // 3. Save to Firestore
      await _firestore.collection('users').doc(uid).set(user.toJson());

      return user;
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Update User Profile
  Future<void> updateUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.id).update(user.toJson());
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<List<UserModel>> getAllUsers() async {
    try {
      final snapshot = await _firestore.collection('users').get();
      return snapshot.docs.map((doc) => UserModel.fromJson(doc.data())).toList();
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Login
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      // 1. Sign in with Firebase Auth
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user!.uid;

      // 2. Fetch user data from Firestore
      final doc = await _firestore.collection('users').doc(uid).get();

      if (!doc.exists) {
        throw Exception('User data not found');
      }

      // 3. Convert to UserModel
      return UserModel.fromJson(doc.data()!);
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Logout
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  // Get current user data
  Future<UserModel?> getCurrentUser() async {
    try {
      final uid = currentUserId;
      if (uid == null) return null;

      final doc = await _firestore.collection('users').doc(uid).get();
      if (!doc.exists) return null;

      return UserModel.fromJson(doc.data()!);
    } catch (e) {
      return null;
    }
  }

  // Reset Password
  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Helper to handle Firebase exceptions
  Exception _handleAuthException(dynamic e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'user-not-found':
          return AuthException('المستخدم غير موجود');
        case 'wrong-password':
          return AuthException('كلمة المرور غير صحيحة');
        case 'email-already-in-use':
          return AuthException('البريد الإلكتروني مستخدم بالفعل');
        case 'invalid-email':
          return AuthException('البريد الإلكتروني غير صالح');
        case 'weak-password':
          return AuthException('كلمة المرور ضعيفة جدًا');
        default:
          return AuthException('حدث خطأ في المصادقة: ${e.message}');
      }
    }
    return AuthException('حدث خطأ غير متوقع: $e');
  }
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}
