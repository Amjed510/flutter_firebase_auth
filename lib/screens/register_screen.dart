import 'package:flutter/material.dart';
import '../services/auth_service.dart'; // <-- استيراد خدمة المصادقة

class RegisterScreen extends StatefulWidget {
  final AuthService authService;

  // استقبال الخدمة عند الانتقال لهذه الشاشة
  const RegisterScreen({required this.authService, super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  // (اختياري) يمكنك إضافة حقل لتأكيد كلمة المرور هنا
  final _confirmPasswordController = TextEditingController();
  String? _errorMessage;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose(); // إذا أضفته
    super.dispose();
  }

  // دالة التعامل مع عملية التسجيل فقط
  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    // (اختياري) التحقق من تطابق كلمتي المرور
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _errorMessage = 'كلمتا المرور غير متطابقتين';
      });
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final error = await widget.authService.createUserWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _errorMessage = error;
    });

    // إذا نجح التسجيل، أظهر رسالة واذهب لشاشة الدخول (أو ابق هنا حسب الرغبة)
    if (error == null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم إنشاء الحساب بنجاح! يمكنك الآن تسجيل الدخول.'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 4), // مدة أطول
        ),
      );
      // العودة إلى شاشة تسجيل الدخول بعد نجاح التسجيل
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    // يمكن استخدام نفس التدرج أو تغييره قليلاً للتفريق
    const registerGradient = LinearGradient(
      colors: [Color.fromARGB(255, 5, 92, 82), Colors.teal], // تدرج أخضر
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('إنشاء حساب جديد'),
          backgroundColor: Colors.teal.shade700, // لون مطابق للتدرج
          elevation: 0,
          // يوفر زر رجوع تلقائي بسبب استخدام Navigator.push
        ),
        body: Container(
          decoration: const BoxDecoration(gradient: registerGradient),
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
                    // --- حقول الإدخال ---
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
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
                            color: Colors.orangeAccent,
                            width: 2,
                          ),
                        ), // لون خطأ مختلف قليلاً
                        focusedErrorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.orangeAccent,
                            width: 2,
                          ),
                        ),
                        errorStyle: TextStyle(color: Colors.orangeAccent),
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
                        labelText: 'كلمة المرور',
                        hintText: '6 أحرف على الأقل', // تلميح مفيد
                        labelStyle: TextStyle(color: Colors.white70),
                        hintStyle: TextStyle(color: Colors.white54),
                        icon: Icon(
                          Icons.lock_outline,
                          color: Colors.white,
                        ), // أيقونة مختلفة قليلاً
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white54),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 2),
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.orangeAccent,
                            width: 2,
                          ),
                        ),
                        focusedErrorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.orangeAccent,
                            width: 2,
                          ),
                        ),
                        errorStyle: TextStyle(color: Colors.orangeAccent),
                      ),
                      obscureText: true,
                      style: const TextStyle(color: Colors.white),
                      textInputAction:
                          TextInputAction
                              .next, // أو .done إذا لم يكن هناك حقل تأكيد
                      validator: (value) {
                        // نفس المدقق
                        if (value == null || value.isEmpty)
                          return 'الرجاء إدخال كلمة المرور';
                        if (value.length < 6)
                          return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                        return null;
                      },
                    ),
                    // (اختياري) إضافة حقل تأكيد كلمة المرور
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration: const InputDecoration(
                        labelText: 'تأكيد كلمة المرور',
                        hintText: 'أعد إدخال كلمة المرور',
                        labelStyle: TextStyle(color: Colors.white70),
                        hintStyle: TextStyle(color: Colors.white54),
                        icon: Icon(Icons.lock_outline, color: Colors.white),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white54),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 2),
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.orangeAccent,
                            width: 2,
                          ),
                        ), // لون خطأ مختلف قليلاً
                        focusedErrorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.orangeAccent,
                            width: 2,
                          ),
                        ),
                        errorStyle: TextStyle(color: Colors.orangeAccent),
                      ),

                      obscureText: true,
                      style: const TextStyle(color: Colors.white),
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted:
                          (_) => _isLoading ? null : _handleRegister(),
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'الرجاء تأكيد كلمة المرور';
                        if (value != _passwordController.text)
                          return 'كلمتا المرور غير متطابقتين';
                        return null;
                      },
                    ),
                    // --- نهاية حقول الإدخال ---

                    // عرض رسالة الخطأ
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
                                    color: Colors.orangeAccent,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              )
                              : const SizedBox.shrink(),
                    ),
                    const SizedBox(height: 30),

                    // زر التسجيل ومؤشر التحميل
                    if (_isLoading)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                      )
                    else
                      ElevatedButton(
                        onPressed: _handleRegister,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.green.shade600, // لون أخضر للتسجيل
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
                        child: const Text('إنشاء الحساب'),
                      ),

                    // زر العودة لتسجيل الدخول
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed:
                          _isLoading
                              ? null
                              : () =>
                                  Navigator.of(
                                    context,
                                  ).pop(), // العودة للشاشة السابقة (Login)
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white.withOpacity(0.9),
                      ),
                      child: const Text('لديك حساب بالفعل؟ تسجيل الدخول'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
