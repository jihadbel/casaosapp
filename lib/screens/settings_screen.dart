import 'package:flutter/material.dart';
import '../core/models/mock_data.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/theme_controller.dart';
import '../core/widgets/glass_card.dart';
import 'splash_discovery_screen.dart';
import 'admin_panel_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _biometricEnabled = true;
  bool _secureScreenEnabled = false;
  bool _autoSyncPhotos = true;
  bool _syncWifiOnly = true;
  bool _syncChargingOnly = false;
  String _cacheSize = '142 MB';

  void _showChangePasswordDialog() {
    final oldPassController = TextEditingController();
    final newPassController = TextEditingController();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.cardDark : AppColors.cardLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Row(
          children: const [
            Icon(Icons.lock_reset_rounded, color: AppColors.primary),
            SizedBox(width: 10),
            Text('تغيير كلمة المرور الخاصة بك'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: oldPassController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'كلمة المرور الحالية'),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: newPassController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'كلمة المرور الجديدة (12-72 حرف)',
                hintText: 'يجب أن لا تقل عن 12 حرفاً',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(minimumSize: const Size(100, 40)),
            onPressed: () {
              if (newPassController.text.length < 12) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('كلمة المرور يجب أن لا تقل عن 12 حرفاً وفق معايير الخادم'),
                    backgroundColor: AppColors.rose,
                  ),
                );
                return;
              }
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم تغيير كلمة المرور بنجاح وحفظها في الخادم'),
                  backgroundColor: AppColors.emerald,
                ),
              );
            },
            child: const Text('حفظ التغيير'),
          ),
        ],
      ),
    );
  }

  void _confirmLogout() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.cardDark : AppColors.cardLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Row(
          children: const [
            Icon(Icons.logout_rounded, color: AppColors.rose),
            SizedBox(width: 10),
            Text('تسجيل الخروج؟'),
          ],
        ),
        content: Text(
          'سيتم إلغاء الجلسة المشفرة ومسح الذاكرة المؤقتة للملفات المحفوظة محلياً لضمان الخصوصية.',
          style: TextStyle(
            fontSize: 13,
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.rose,
              minimumSize: const Size(110, 42),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const SplashDiscoveryScreen()),
                (route) => false,
              );
            },
            child: const Text('خروج ومسح الجلسة'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = MockData.currentUser;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeController = ThemeController.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعدادات والحساب'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // Profile Card
          GlassCard(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.primary, AppColors.cyan],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          user.username.substring(0, 1).toUpperCase(),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                user.username,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.18),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  user.isAdmin ? 'مسؤول النظام' : 'مستخدم محلي',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryLight,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user.homePath,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.password_rounded, size: 18),
                        label: const Text('تغيير كلمة المرور'),
                        onPressed: _showChangePasswordDialog,
                      ),
                    ),
                    if (user.isAdmin) ...[
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.indigo),
                          icon: const Icon(Icons.admin_panel_settings_rounded, size: 18),
                          label: const Text('لوحة المسؤول'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const AdminPanelScreen()),
                            );
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Theme Selector Section (الوضع الفاتح والداكن)
          _buildSectionTitle('مظهر التطبيق والسمة (Theme)'),
          GlassCard(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                        color: AppColors.primary,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'سمة الواجهة',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        Text(
                          themeController.themeMode == ThemeMode.light
                              ? 'الوضع الفاتح (الافتراضي)'
                              : themeController.themeMode == ThemeMode.dark
                                  ? 'الوضع الداكن'
                                  : 'تلقائي (حسب نظام الجهاز)',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _ThemeOptionTile(
                        icon: Icons.light_mode_rounded,
                        label: 'الوضع الفاتح\n(الافتراضي)',
                        isSelected: themeController.themeMode == ThemeMode.light,
                        onTap: () {
                          setState(() {
                            themeController.setThemeMode(ThemeMode.light);
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _ThemeOptionTile(
                        icon: Icons.dark_mode_rounded,
                        label: 'الوضع الداكن\n(Dark)',
                        isSelected: themeController.themeMode == ThemeMode.dark,
                        onTap: () {
                          setState(() {
                            themeController.setThemeMode(ThemeMode.dark);
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _ThemeOptionTile(
                        icon: Icons.brightness_auto_rounded,
                        label: 'تلقائي\n(النظام)',
                        isSelected: themeController.themeMode == ThemeMode.system,
                        onTap: () {
                          setState(() {
                            themeController.setThemeMode(ThemeMode.system);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Security & Biometrics Section
          _buildSectionTitle('الأمان والحماية المحلية'),
          GlassCard(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.fingerprint_rounded, color: AppColors.emerald),
                  title: const Text('قفل التطبيق بالبصمة البيومترية'),
                  subtitle: const Text('المطالبة بالبصمة عند فتح التطبيق أو العودة إليه'),
                  value: _biometricEnabled,
                  onChanged: (val) => setState(() => _biometricEnabled = val),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.security_rounded, color: AppColors.primary),
                  title: const Text('حماية الشاشة من الالتقاط'),
                  subtitle: const Text('منع لقطات الشاشة وتسجيل الفيديو داخل التطبيق'),
                  value: _secureScreenEnabled,
                  onChanged: (val) => setState(() => _secureScreenEnabled = val),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Camera Roll Sync Section
          _buildSectionTitle('المزامنة التلقائية لصور الهاتف'),
          GlassCard(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.cloud_upload_rounded, color: AppColors.cyan),
                  title: const Text('النسخ الاحتياطي التلقائي للكاميرا'),
                  subtitle: const Text('رفع الصور ومقاطع الفيديو الجديدة إلى /Mobile_Uploads'),
                  value: _autoSyncPhotos,
                  onChanged: (val) => setState(() => _autoSyncPhotos = val),
                ),
                if (_autoSyncPhotos) ...[
                  const Divider(height: 1),
                  SwitchListTile(
                    secondary: const Icon(Icons.wifi_rounded, color: AppColors.amber),
                    title: const Text('المزامنة على شبكات Wi-Fi فقط'),
                    subtitle: const Text('تجنب استهلاك باقة بيانات الجوال'),
                    value: _syncWifiOnly,
                    onChanged: (val) => setState(() => _syncWifiOnly = val),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    secondary: const Icon(Icons.power_rounded, color: AppColors.purple),
                    title: const Text('المزامنة أثناء الشحن فقط'),
                    subtitle: const Text('الحفاظ على طاقة بطارية الهاتف'),
                    value: _syncChargingOnly,
                    onChanged: (val) => setState(() => _syncChargingOnly = val),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Server Connection & Cache
          _buildSectionTitle('الخادم والتخزين المؤقت'),
          GlassCard(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.dns_rounded, color: AppColors.primary),
                  title: const Text('خادم CasaOS المتصل'),
                  subtitle: const Text('http://192.168.1.150:80 • إصدار مستقل'),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.emerald.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'متصل',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.emerald,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.cleaning_services_rounded, color: AppColors.amber),
                  title: const Text('الذاكرة المؤقتة (Cache)'),
                  subtitle: Text('$_cacheSize ملفات معاينة مخزنة لتسريع التصفح'),
                  trailing: TextButton(
                    onPressed: () {
                      setState(() => _cacheSize = '0 MB');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('تم مسح الذاكرة المؤقتة بنجاح')),
                      );
                    },
                    child: const Text('مسح الكاش'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Logout Action
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.rose.withOpacity(0.12),
              foregroundColor: AppColors.rose,
              side: BorderSide(color: AppColors.rose.withOpacity(0.3)),
            ),
            icon: const Icon(Icons.logout_rounded),
            label: const Text('تسجيل الخروج من الحساب'),
            onPressed: _confirmLogout,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, right: 4),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }
}

class _ThemeOptionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeOptionTile({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.15)
              : (isDark ? AppColors.cardLightDark : AppColors.cardLightLight),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : (isDark ? AppColors.borderDark : AppColors.borderLight),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
              size: 24,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? AppColors.primary
                    : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
