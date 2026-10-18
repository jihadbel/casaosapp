import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/theme_controller.dart';
import '../core/widgets/glass_card.dart';
import '../core/models/mock_data.dart';
import '../core/models/user_account.dart';
import 'splash_discovery_screen.dart';
import 'main_shell_screen.dart';

class LoginScreen extends StatefulWidget {
  final String serverHost;
  final String serverPort;
  final bool isHttps;

  const LoginScreen({
    super.key,
    required this.serverHost,
    required this.serverPort,
    required this.isHttps,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController =
      TextEditingController(text: 'admin');
  final TextEditingController _passwordController =
      TextEditingController(text: 'CasaOS@Admin2026!');
  bool _obscurePassword = true;
  bool _rememberMe = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى إدخال اسم المستخدم وكلمة المرور'),
          backgroundColor: AppColors.rose,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Simulate login API call to POST /api/auth/session
    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) {
        setState(() => _isLoading = false);

        // Configure mock user state based on username
        final isAdmin = username.toLowerCase() == 'admin';
        MockData.currentUser = UserAccount(
          id: isAdmin ? 'usr-admin' : 'usr-$username',
          username: username,
          isAdmin: isAdmin,
          homePath: 'C:\\ProgramData\\CasaOS\\files\\$username',
          createdAt: DateTime(2026, 10, 15),
        );

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MainShellScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scheme = widget.isHttps ? 'https' : 'http';
    final serverUrl = '$scheme://${widget.serverHost}:${widget.serverPort}';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: isDark ? 'التبديل إلى الوضع الفاتح' : 'التبديل إلى الوضع الداكن',
            icon: Icon(
              isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
            onPressed: () {
              ThemeController.instance.toggleTheme();
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Server Status Pill
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardLightDark : AppColors.cardLightLight,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: AppColors.emerald.withOpacity(0.4),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.emerald,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        serverUrl,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => const SplashDiscoveryScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'تغيير',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.primaryLight,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Lock icon & Title
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lock_person_rounded,
                    color: AppColors.primary,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'تسجيل الدخول إلى حسابك',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'يتم عزل ملفاتك وسلتك وإعداداتك بالكامل داخل حسابك',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondaryDark,
                  ),
                ),
                const SizedBox(height: 30),

                // Login Form Card
                GlassCard(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    children: [
                      TextField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                          labelText: 'اسم المستخدم (Username)',
                          prefixIcon: Icon(Icons.person_rounded),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'كلمة المرور (Password)',
                          prefixIcon: const Icon(Icons.key_rounded),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_rounded
                                  : Icons.visibility_off_rounded,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            activeColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            onChanged: (val) {
                              setState(() => _rememberMe = val ?? true);
                            },
                          ),
                          const Text(
                            'تذكر تسجيل الدخول في هذا الجهاز',
                            style: TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _isLoading ? null : _handleLogin,
                        child: _isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('دخول إلى السحابة'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Quick Demo Account Switcher
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.cardLightDark.withOpacity(0.5)
                        : AppColors.cardLightLight,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isDark ? AppColors.borderDark : AppColors.borderLight,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'حسابات التجربة السريعة:',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? AppColors.textMutedDark : AppColors.textSecondaryLight,
                        ),
                      ),
                      ActionChip(
                        label: const Text('admin (مسؤول)'),
                        avatar: const Icon(Icons.shield_rounded, size: 16),
                        onPressed: () {
                          setState(() {
                            _usernameController.text = 'admin';
                            _passwordController.text = 'CasaOS@Admin2026!';
                          });
                        },
                      ),
                      ActionChip(
                        label: const Text('ahmed (مستخدم)'),
                        avatar: const Icon(Icons.person_rounded, size: 16),
                        onPressed: () {
                          setState(() {
                            _usernameController.text = 'ahmed';
                            _passwordController.text = 'UserSecretPass123!';
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
