import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // <-- استيراد ضروري لتهيئة Firebase
import 'screens/auth_gate.dart'; // <-- استيراد AuthGate فقط

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase Auth (Refactored)', // تغيير العنوان قليلاً
      theme: ThemeData(
        // يمكنك الاحتفاظ ببعض التخصيصات العامة هنا
        // أو جعلها بسيطة جداً والسماح لكل شاشة بتحديد نمطها
        // استخدام السمة الفاتحة كنقطة بداية
        brightness: Brightness.light,
        primarySwatch: Colors.blue, // العودة لـ primarySwatch إذا فضلت
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blue,
        ), // يمكن استخدامه بدلاً من seedColor
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3:
            false, // العودة إلى Material 2 إذا كان هو أساس تصميمك الأصلي
        // يمكنك تحديد أنماط عامة هنا إذا أردت
        // appBarTheme: AppBarTheme(...)
        // elevatedButtonTheme: ElevatedButtonThemeData(...)
        // inputDecorationTheme: InputDecorationTheme(...)
      ),
      // نقطة البداية هي AuthGate دائماً
      home: const AuthGate(),
      debugShowCheckedModeBanner: false,
    );
  }
}
