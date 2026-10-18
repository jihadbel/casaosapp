import 'dart:async';
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/theme_controller.dart';
import '../core/widgets/glass_card.dart';
import 'login_screen.dart';

class SplashDiscoveryScreen extends StatefulWidget {
  const SplashDiscoveryScreen({super.key});

  @override
  State<SplashDiscoveryScreen> createState() => _SplashDiscoveryScreenState();
}

class _SplashDiscoveryScreenState extends State<SplashDiscoveryScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  Timer? _scanTimer;
  final TextEditingController _hostController =
      TextEditingController(text: '192.168.1.150');
  final TextEditingController _portController =
      TextEditingController(text: '80');
  bool _useHttps = false;
  bool _isScanning = true;
  bool _isConnecting = false;

  final List<Map<String, dynamic>> _discoveredServers = [
    {
      'name': 'CasaOS Home Cloud',
      'host': '192.168.1.150',
      'port': '80',
      'os': 'Windows Standalone',
      'status': 'Online',
    },
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);

    // Simulate network discovery scan
    _scanTimer = Timer(const Duration(milliseconds: 2200), () {
      if (mounted) {
        setState(() {
          _isScanning = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _scanTimer?.cancel();
    _pulseController.dispose();
    _hostController.dispose();
    _portController.dispose();
    super.dispose();
  }

  void _proceedToLogin(String host, String port, bool https) {
    setState(() => _isConnecting = true);
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() => _isConnecting = false);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => LoginScreen(
              serverHost: host,
              serverPort: port,
              isHttps: https,
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              // App Brand Header
              Center(
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.cyan],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.35),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.cloud_done_rounded,
                    color: Colors.white,
                    size: 38,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'CasaOS Cloud',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'سحابتك الخاصة المعزولة داخل شبكتك المنزلية',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
              ),
              const SizedBox(height: 28),

              // Discovery Card
              GlassCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        AnimatedBuilder(
                          animation: _pulseController,
                          builder: (context, child) {
                            return Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _isScanning
                                    ? AppColors.primary.withOpacity(
                                        0.4 + (_pulseController.value * 0.6))
                                    : AppColors.emerald,
                                boxShadow: [
                                  BoxShadow(
                                    color: (_isScanning
                                            ? AppColors.primary
                                            : AppColors.emerald)
                                        .withOpacity(0.5),
                                    blurRadius: 8,
                                    spreadRadius:
                                        _isScanning ? _pulseController.value * 3 : 1,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 10),
                        Text(
                          _isScanning
                              ? 'جارٍ فحص الشبكة المحلية عن خوادم CasaOS...'
                              : 'الخوادم المكتشفة في الشبكة',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        if (_isScanning)
                          const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        else
                          IconButton(
                            icon: const Icon(Icons.refresh_rounded, size: 20),
                            onPressed: () {
                              setState(() => _isScanning = true);
                              Future.delayed(const Duration(seconds: 2), () {
                                if (mounted) setState(() => _isScanning = false);
                              });
                            },
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Discovered list
                    ..._discoveredServers.map((srv) {
                      return Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.cardLightDark
                              : AppColors.cardLightLight,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.dns_rounded,
                                color: AppColors.primary,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    srv['name'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${srv['host']}:${srv['port']} • ${srv['os']}',
                                    style: TextStyle(
                                      color: isDark
                                          ? AppColors.textSecondaryDark
                                          : AppColors.textSecondaryLight,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(70, 36),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 14),
                              ),
                              onPressed: _isConnecting
                                  ? null
                                  : () => _proceedToLogin(
                                        srv['host'],
                                        srv['port'],
                                        false,
                                      ),
                              child: _isConnecting
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text('اتصال'),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Manual Connection Card
              GlassCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'أو الاتصال اليدوي بعنوان الخادم',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _hostController,
                      decoration: const InputDecoration(
                        labelText: 'عنوان IP أو اسم المضيف (Host)',
                        hintText: 'مثال: 192.168.1.150 أو my-casaos.local',
                        prefixIcon: Icon(Icons.link_rounded),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: _portController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'المنفذ (Port)',
                              hintText: '80 أو 443',
                              prefixIcon: Icon(Icons.numbers_rounded),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          flex: 3,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _useHttps = !_useHttps;
                                if (_useHttps && _portController.text == '80') {
                                  _portController.text = '443';
                                } else if (!_useHttps &&
                                    _portController.text == '443') {
                                  _portController.text = '80';
                                }
                              });
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 12),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppColors.cardLightDark
                                    : AppColors.cardLightLight,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _useHttps
                                      ? AppColors.primary
                                      : (isDark
                                          ? AppColors.borderDark
                                          : AppColors.borderLight),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    _useHttps
                                        ? Icons.lock_rounded
                                        : Icons.lock_open_rounded,
                                    size: 18,
                                    color: _useHttps
                                        ? AppColors.emerald
                                        : AppColors.textMutedDark,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'HTTPS مشفر',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: _useHttps
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.bolt_rounded),
                      label: const Text('اختبار والاتصال بالخادم'),
                      onPressed: () => _proceedToLogin(
                        _hostController.text.trim(),
                        _portController.text.trim(),
                        _useHttps,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'نسخة الخادم المستقلة CasaOS Standalone Multi-User\nمحمي بنظام الصلاحيات وعزل المجلدات الخاصة',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textMutedDark,
                  fontSize: 12,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
