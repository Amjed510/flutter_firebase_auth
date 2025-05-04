import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart'; // لاستخدام print في وضع الـ debug فقط

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // للوصول السهل إلى النسخة الحالية (إذا احتجت إليها في مكان آخر)
  FirebaseAuth get firebaseAuthInstance => _firebaseAuth;

  // Stream لمراقبة تغييرات حالة المصادقة للمستخدم
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // دالة تسجيل الدخول
  Future<String?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return null; // نجاح، لا يوجد خطأ
    } on FirebaseAuthException catch (e) {
      // ترجمة أخطاء Firebase إلى رسائل مفهومة للمستخدم
      return _mapFirebaseAuthExceptionToMessage(e);
    } catch (e) {
      if (kDebugMode) {
        // طباعة الأخطاء العامة فقط في وضع التصحيح
        print('General SignIn Error: $e');
      }
      return 'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.';
    }
  }

  // دالة تسجيل مستخدم جديد
  Future<String?> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return null; // نجاح، لا يوجد خطأ
    } on FirebaseAuthException catch (e) {
      // ترجمة أخطاء Firebase إلى رسائل مفهومة للمستخدم
      return _mapFirebaseAuthExceptionToMessage(e);
    } catch (e) {
      if (kDebugMode) {
        print('General SignUp Error: $e');
      }
      return 'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.';
    }
  }

  // دالة تسجيل الخروج
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      if (kDebugMode) {
        print("Error signing out: $e");
      }
      // يمكنك التعامل مع الخطأ هنا إذا أردت، مثل إظهار رسالة للمستخدم
      // throw Exception('Failed to sign out'); // أو رمي استثناء إذا كان الأمر خطيراً
    }
  }

  // دالة مساعدة لترجمة استثناءات Firebase Auth
  String _mapFirebaseAuthExceptionToMessage(FirebaseAuthException e) {
    if (kDebugMode) {
      print('Firebase Auth Error Code: ${e.code}');
    }
    switch (e.code) {
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'البريد الإلكتروني أو كلمة المرور غير صحيحة.';
      case 'email-already-in-use':
        return 'هذا البريد الإلكتروني مستخدم بالفعل.';
      case 'weak-password':
        return 'كلمة المرور ضعيفة جدًا (يجب أن تكون 6 أحرف على الأقل).';
      case 'invalid-email':
        return 'صيغة البريد الإلكتروني غير صالحة.';
      case 'operation-not-allowed':
        return 'تسجيل الدخول بكلمة المرور غير مفعل في Firebase.';
      case 'network-request-failed':
        return 'فشل طلب الشبكة. تحقق من اتصالك بالإنترنت.';
      // أضف حالات أخرى حسب الحاجة
      default:
        return 'حدث خطأ أثناء المصادقة (${e.code}). حاول مرة أخرى.';
    }
  }
}
