import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // لـ User
import '../services/auth_service.dart'; // لـ AuthService

// تمت إعادة التسمية إلى HomeScreen
class HomeScreen extends StatelessWidget {
  final AuthService authService;

  const HomeScreen({required this.authService, super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = authService.firebaseAuthInstance.currentUser;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme; // للوصول لألوان السمة

    return Directionality(
      textDirection: TextDirection.rtl, // تعيين اتجاه النص إلى اليمين
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'الصفحة الرئيسية', // عنوان مناسب للشاشة الرئيسية
            style: TextStyle(
              color: Colors.white,
              fontSize: 22, // حجم مناسب
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.blue.shade700, // لون أغمق قليلاً وأكثر هدوءاً
          centerTitle: true,
          // أيقونة المستخدم يمكن أن تفتح لاحقاً صفحة الملف الشخصي
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              // استخدام دائرة لعرض الحرف الأول من الإيميل
              backgroundColor: Colors.white54,
              child: Text(
                user?.email?.substring(0, 1).toUpperCase() ?? 'U',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                ),
              ),
            ),
            // child: Icon(Icons.account_circle, color: Colors.white, size: 30),
          ),
          actions: [
            IconButton(
              tooltip: 'تسجيل الخروج',
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () async {
                await authService.signOut();
                // AuthGate يتولى الباقي
              },
            ),
          ],
        ),
        // استخدام لون خلفية أكثر نعومة من الأبيض الناصع
        backgroundColor: Colors.grey[100],
        body: ListView(
          // استخدام ListView للسماح بالتمرير إذا زاد المحتوى
          padding: const EdgeInsets.all(16.0), // إضافة Padding حول المحتوى
          children: [
            // --- قسم الترحيب ---
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      // ترحيب شخصي أكثر
                      'أهلاً بعودتك، ${user?.displayName ?? user?.email?.split('@')[0] ?? 'مستخدم'}!',
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'نحن سعداء برؤيتك مرة أخرى. إليك بعض التحديثات السريعة:',
                      style: textTheme.bodyMedium?.copyWith(
                        color: Colors.black54,
                      ),
                    ),
                    if (user?.email != null) ...[
                      // عرض الإيميل بشكل أقل بروزاً إذا أردت
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(
                            Icons.email_outlined,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 8),
                          Text(
                            user!.email!,
                            style: textTheme.bodySmall?.copyWith(
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // --- قسم الميزات (مثال باستخدام ListTile) ---
            Text(
              "اختصارات سريعة",
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              clipBehavior:
                  Clip.antiAlias, // لمنع العناصر الداخلية من تجاوز الحواف الدائرية
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.dashboard_customize_outlined,
                      color: colorScheme.primary,
                    ),
                    title: const Text('لوحة التحكم الرئيسية'),
                    subtitle: const Text('عرض ملخص الأنشطة والإحصائيات'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                    onTap: () {
                      /* انتقل إلى لوحة التحكم */
                    },
                  ),
                  const Divider(
                    height: 1,
                    indent: 16,
                    endIndent: 16,
                  ), // فاصل بصري
                  ListTile(
                    leading: Icon(
                      Icons.settings_outlined,
                      color: Colors.orange.shade700,
                    ),
                    title: const Text('الإعدادات'),
                    subtitle: const Text('تخصيص تفضيلات التطبيق'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                    onTap: () {
                      /* انتقل إلى الإعدادات */
                    },
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  ListTile(
                    leading: Icon(
                      Icons.help_outline,
                      color: Colors.green.shade600,
                    ),
                    title: const Text('المساعدة والدعم'),
                    subtitle: const Text('ابحث عن إجابات لأسئلتك'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                    onTap: () {
                      /* انتقل إلى المساعدة */
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // --- قسم آخر (مثال باستخدام Grid أو محتوى مخصص) ---
            Text(
              "المحتوى المميز",
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AspectRatio(
                      // للحفاظ على نسبة العرض للارتفاع للصورة
                      aspectRatio: 16 / 9,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey[300], // لون نائب للصورة
                          image: const DecorationImage(
                            image: NetworkImage(
                              'https://via.placeholder.com/350x150/007bff/ffffff?text=Flutter+Image',
                            ), // استبدل بصورة حقيقية
                            fit: BoxFit.cover,
                            // يمكنك إضافة معالج أخطاء للصورة هنا
                          ),
                        ),
                        // يمكنك وضع نص أو أيقونة فوق الصورة إذا أردت
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "عنوان المحتوى المميز",
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "هذا وصف قصير للمحتوى المميز الذي يمكن للمستخدم التفاعل معه أو قراءته.",
                      style: textTheme.bodyMedium?.copyWith(
                        color: Colors.black54,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    Align(
                      // لوضع الزر على اليمين
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          /* إجراء ما */
                        },
                        child: const Text("اعرف المزيد"),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // يمكنك إضافة المزيد من الأقسام والودجتس هنا
          ],
        ),
        // يمكنك إضافة BottomNavigationBar هنا إذا لزم الأمر لاحقاً
        // bottomNavigationBar: BottomNavigationBar(...)
      ),
    );
  }
}
