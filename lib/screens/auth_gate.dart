import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart'; // <-- استيراد خدمة المصادقة
import './login_screen.dart'; // <-- استيراد شاشة تسجيل الدخول
import 'home_screen.dart'; // <-- استيراد شاشة النجاح

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    // يمكنك إنشاء نسخة هنا أو استخدام مدير حالة مثل Provider/Riverpod
    final authService = AuthService();

    return StreamBuilder<User?>(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        // انتظار البيانات
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // المستخدم مسجل الدخول
        if (snapshot.hasData) {
          // تمرير الخدمة للشاشة التالية إذا كانت بحاجتها (مثل تسجيل الخروج)
          return HomeScreen(authService: authService);
        }

        // المستخدم غير مسجل الدخول
        return LoginScreen(authService: authService);
      },
    );
  }
}
