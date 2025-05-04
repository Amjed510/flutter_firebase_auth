import 'package:flutter/material.dart';
import '../services/auth_service.dart'; // استيراد الخدمة
import './register_screen.dart'; // <-- استيراد شاشة التسجيل الجديدة

class LoginScreen extends StatefulWidget {
  final AuthService authService;

  const LoginScreen({required this.authService, super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // دالة التعامل مع تسجيل الدخول فقط
  Future<void> _handleSignIn() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final error = await widget.authService.signInWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _errorMessage = error;
    });
    // AuthGate سيتولى الانتقال عند النجاح
  }

  // --- تم حذف دالة _handleRegister() ---

  @override
  Widget build(BuildContext context) {
    // التدرج اللوني لشاشة الدخول
    const loginGradient = LinearGradient(
      colors: [Color.fromARGB(255, 10, 74, 126), Colors.blue],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('تسجيل الدخول'), // تغيير العنوان
        backgroundColor: Colors.blue.shade700,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: loginGradient),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 30.0,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // --- حقول الإدخال (تبقى كما هي) ---
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      /* ... نفس الشكل السابق ... */
                      labelText: 'البريد الإلكتروني',
                      hintText: 'أدخل بريدك الإلكتروني',
                      labelStyle: TextStyle(color: Colors.white70),
                      hintStyle: TextStyle(color: Colors.white54),
                      icon: Icon(Icons.email, color: Colors.white),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white54),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2),
                      ),
                      errorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.redAccent,
                          width: 2,
                        ),
                      ),
                      focusedErrorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.redAccent,
                          width: 2,
                        ),
                      ),
                      errorStyle: TextStyle(color: Colors.redAccent),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: Colors.white),
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      // نفس المدقق
                      if (value == null || value.trim().isEmpty)
                        return 'الرجاء إدخال البريد الإلكتروني';
                      final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                      if (!emailRegex.hasMatch(value.trim()))
                        return 'صيغة البريد الإلكتروني غير صحيحة';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      /* ... نفس الشكل السابق ... */
                      labelText: 'كلمة المرور',
                      hintText: 'أدخل كلمة المرور',
                      labelStyle: TextStyle(color: Colors.white70),
                      hintStyle: TextStyle(color: Colors.white54),
                      icon: Icon(Icons.lock, color: Colors.white),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white54),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2),
                      ),
                      errorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.redAccent,
                          width: 2,
                        ),
                      ),
                      focusedErrorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.redAccent,
                          width: 2,
                        ),
                      ),
                      errorStyle: TextStyle(color: Colors.redAccent),
                    ),
                    obscureText: true,
                    style: const TextStyle(color: Colors.white),
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted:
                        (_) => _isLoading ? null : _handleSignIn(),
                    validator: (value) {
                      // نفس المدقق
                      if (value == null || value.isEmpty)
                        return 'الرجاء إدخال كلمة المرور';
                      if (value.length < 6)
                        return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                      return null;
                    },
                  ),
                  // --- نهاية حقول الإدخال ---

                  // عرض رسالة الخطأ (تبقى كما هي)
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: _errorMessage != null ? 1.0 : 0.0,
                    child:
                        _errorMessage != null
                            ? Padding(
                              padding: const EdgeInsets.only(
                                top: 15.0,
                                bottom: 5.0,
                              ),
                              child: Text(
                                _errorMessage!,
                                style: const TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )
                            : const SizedBox.shrink(),
                  ),
                  const SizedBox(height: 30),

                  // زر تسجيل الدخول ومؤشر التحميل
                  if (_isLoading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    )
                  else
                    ElevatedButton(
                      onPressed: _handleSignIn,
                      style: ElevatedButton.styleFrom(
                        // نفس النمط السابق
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Text('تسجيل الدخول'),
                    ),

                  // --- زر الانتقال إلى شاشة التسجيل ---
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed:
                        _isLoading
                            ? null
                            : () {
                              // الانتقال إلى شاشة التسجيل وتمرير الخدمة إليها
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder:
                                      (context) => RegisterScreen(
                                        authService: widget.authService,
                                      ),
                                ),
                              );
                            },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white.withOpacity(0.9),
                    ),
                    child: const Text('ليس لديك حساب؟ إنشاء حساب جديد'),
                  ),
                  // --- تم حذف زر تسجيل مستخدم جديد ---
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
