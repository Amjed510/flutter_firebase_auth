# flutter_firebase_auth_lab

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


## آلية العمل (How it Works)

يعتمد التطبيق على بنية واضحة لفصل الاهتمامات وإدارة حالة المصادقة بشكل تفاعلي. إليك شرح للتدفق الرئيسي:

1.  **التهيئة (`main.dart`):**
    *   يتم تهيئة Flutter Binding أولاً (`WidgetsFlutterBinding.ensureInitialized()`).
    *   يتم تهيئة Firebase باستخدام الإعدادات الخاصة بمنصتك (`Firebase.initializeApp`).
    *   يتم تشغيل التطبيق الرئيسي `MyApp`.

2.  **نقطة الدخول (`MyApp`):**
    *   يقوم `MyApp` بإعداد `MaterialApp` وتحديد السمة العامة للتطبيق.
    *   الأهم من ذلك، أنه يضبط `home` ليكون `AuthGate`.

3.  **بوابة المصادقة (`AuthGate`):**
    *   هذا هو المكون **المركزي** لإدارة حالة المصادقة.
    *   يستخدم `StreamBuilder` للاستماع بشكل مستمر إلى `authStateChanges` stream القادم من `AuthService`.
    *   `authStateChanges` stream يُصدر إما كائن `User` (إذا كان المستخدم مسجلاً دخوله) أو `null` (إذا لم يكن مسجلاً دخوله).

4.  **خدمة المصادقة (`AuthService`):**
    *   هذه الفئة هي **الوسيط الوحيد** بين واجهة المستخدم وخدمة Firebase Authentication.
    *   تحتوي على دالة `authStateChanges` stream المذكورة أعلاه.
    *   توفر دوال للعمليات الفعلية:
        *   `signInWithEmailAndPassword`: لمحاولة تسجيل الدخول.
        *   `createUserWithEmailAndPassword`: لمحاولة إنشاء حساب جديد.
        *   `signOut`: لتسجيل خروج المستخدم.
    *   تقوم بمعالجة الأخطاء القادمة من Firebase (`FirebaseAuthException`) وتحويلها إلى رسائل خطأ مفهومة لواجهة المستخدم.

5.  **التدفق بناءً على حالة المصادقة:**
    *   **إذا كان المستخدم غير مسجل الدخول (`authStateChanges` يصدر `null`):**
        *   `AuthGate` يعرض `LoginScreen`.
        *   يمكن للمستخدم إدخال بياناته في `LoginScreen` والضغط على "تسجيل الدخول".
        *   `LoginScreen` تستدعي `authService.signInWithEmailAndPassword`.
        *   إذا نجحت العملية، `authStateChanges` سيصدر كائن `User`، وسيقوم `AuthGate` تلقائيًا بالتبديل إلى `HomeScreen`.
        *   إذا فشلت، `AuthService` تعيد رسالة خطأ، وتقوم `LoginScreen` بعرضها.
        *   يمكن للمستخدم أيضًا الضغط على رابط "إنشاء حساب جديد" في `LoginScreen` للانتقال إلى `RegisterScreen` (باستخدام `Navigator.push`).
    *   **إذا كان المستخدم مسجل الدخول (`authStateChanges` يصدر `User`):**
        *   `AuthGate` يعرض `HomeScreen`.
        *   `HomeScreen` تعرض واجهة المستخدم الرئيسية بعد تسجيل الدخول (مثل رسالة ترحيب).
        *   يمكن للمستخدم الضغط على زر تسجيل الخروج في `AppBar`.
        *   `HomeScreen` تستدعي `authService.signOut`.
        *   `authStateChanges` سيصدر `null`، وسيقوم `AuthGate` تلقائيًا بالتبديل إلى `LoginScreen`.

6.  **شاشة التسجيل (`RegisterScreen`):**
    *   تسمح للمستخدم بإدخال بريد إلكتروني وكلمة مرور لإنشاء حساب.
    *   تستدعي `authService.createUserWithEmailAndPassword`.
    *   إذا نجحت، تعرض رسالة نجاح (`SnackBar`) وتعود إلى `LoginScreen` (باستخدام `Navigator.pop`) ليقوم المستخدم بتسجيل الدخول.
    *   إذا فشلت، تعرض رسالة الخطأ.

**المحصلة:** هذا النهج باستخدام `StreamBuilder` و `AuthGate` يجعل واجهة المستخدم **تفاعلية (Reactive)**. تتغير الواجهة تلقائيًا استجابةً لتغيرات حالة المصادقة دون الحاجة إلى عمليات انتقال يدوية معقدة بعد كل عملية تسجيل دخول أو خروج.