import 'package:flutter/material.dart';
import '../core/models/mock_data.dart';
import '../core/models/user_account.dart';
import '../core/theme/app_colors.dart';
import '../core/widgets/glass_card.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  late List<UserAccount> _users;

  @override
  void initState() {
    super.initState();
    _users = List.from(MockData.localUsers);
  }

  void _openCreateUserDialog() {
    final userController = TextEditingController();
    final passController = TextEditingController();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.cardDark : AppColors.cardLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Row(
          children: const [
            Icon(Icons.person_add_alt_1_rounded, color: AppColors.primary),
            SizedBox(width: 10),
            Text('إنشاء حساب مستخدم جديد'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ينشئ الخادم مجلداً وسلة خاصة تلقائياً للمستخدم الجديد.',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: userController,
              decoration: const InputDecoration(
                labelText: 'اسم الحساب (3-32 حرف)',
                hintText: 'مثال: omar أو designer',
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: passController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'كلمة المرور الأولية (12-72 بايت)',
                hintText: 'كلمة مرور قوية لا تقل عن 12 حرف',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(minimumSize: const Size(100, 42)),
            onPressed: () {
              final username = userController.text.trim();
              final password = passController.text;
              if (username.length < 3 || password.length < 12) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('اسم الحساب 3 أحرف فأكثر، وكلمة المرور 12 حرفاً فأكثر'),
                    backgroundColor: AppColors.rose,
                  ),
                );
                return;
              }
              Navigator.pop(ctx);
              setState(() {
                _users.add(
                  UserAccount(
                    id: 'usr-$username',
                    username: username,
                    isAdmin: false,
                    isDisabled: false,
                    homePath: 'C:\\ProgramData\\CasaOS\\files\\usr-$username',
                    createdAt: DateTime.now(),
                  ),
                );
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('تم إنشاء الحساب "$username" وتعيين مجلده بنجاح'),
                  backgroundColor: AppColors.emerald,
                ),
              );
            },
            child: const Text('إنشاء الحساب'),
          ),
        ],
      ),
    );
  }

  void _openResetPasswordDialog(UserAccount user) {
    final passController = TextEditingController();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.cardDark : AppColors.cardLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text('إعادة تعيين كلمة مرور: ${user.username}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'تغيير كلمة المرور يلغي كافة الجلسات الحالية المفتوحة لهذا المستخدم فوراً.',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'كلمة المرور الجديدة (12-72 حرف)',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(minimumSize: const Size(110, 42)),
            onPressed: () {
              if (passController.text.length < 12) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('كلمة المرور يجب أن لا تقل عن 12 حرفاً'),
                    backgroundColor: AppColors.rose,
                  ),
                );
                return;
              }
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('تم تحديث كلمة مرور "${user.username}" وإلغاء جلساته'),
                  backgroundColor: AppColors.emerald,
                ),
              );
            },
            child: const Text('حفظ التعيين'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة المستخدمين والنظام'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_rounded),
            tooltip: 'إضافة مستخدم',
            onPressed: _openCreateUserDialog,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        children: [
          // System Health Card
          GlassCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: AppColors.emerald,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'خادم كازاوس المستقل - يعمل تحت خدمة SYSTEM',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _MetricItem(
                      label: 'المعالج CPU',
                      value: '${MockData.cpuPercent}%',
                      color: AppColors.primary,
                      icon: Icons.memory_rounded,
                    ),
                    _MetricItem(
                      label: 'الذاكرة RAM',
                      value: '${MockData.ramUsedGB} / ${MockData.ramTotalGB.toInt()} GB',
                      color: AppColors.purple,
                      icon: Icons.developer_board_rounded,
                    ),
                    _MetricItem(
                      label: 'التشغيل المستمر',
                      value: MockData.serverUptime,
                      color: AppColors.emerald,
                      icon: Icons.timer_outlined,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Users Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'الحسابات المحلية (${_users.length})',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              TextButton.icon(
                icon: const Icon(Icons.add, size: 18),
                label: const Text('مستخدم جديد'),
                onPressed: _openCreateUserDialog,
              ),
            ],
          ),
          const SizedBox(height: 10),

          // User Accounts
          ..._users.map((usr) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GlassCard(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: (usr.isAdmin ? AppColors.primary : AppColors.cyan).withOpacity(0.14),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        usr.isAdmin ? Icons.shield_rounded : Icons.person_rounded,
                        color: usr.isAdmin ? AppColors.primary : AppColors.cyan,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                usr.username,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              const SizedBox(width: 8),
                              if (usr.isAdmin)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.18),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    'مسؤول النظام',
                                    style: TextStyle(
                                      color: AppColors.primaryLight,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              else if (usr.isDisabled)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.rose.withOpacity(0.18),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    'معطل',
                                    style: TextStyle(
                                      color: AppColors.rose,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              else
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.emerald.withOpacity(0.18),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    'نشط',
                                    style: TextStyle(
                                      color: AppColors.emerald,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            usr.homePath,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryDark),
                          ),
                        ],
                      ),
                    ),
                    // Action Popup Menu
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert_rounded),
                      onSelected: (val) {
                        if (val == 'reset') {
                          _openResetPasswordDialog(usr);
                        } else if (val == 'toggle') {
                          setState(() {
                            usr.isDisabled = !usr.isDisabled;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                usr.isDisabled
                                    ? 'تم تعطيل حساب "${usr.username}" وإلغاء جلساته'
                                    : 'تم تفعيل حساب "${usr.username}"',
                              ),
                            ),
                          );
                        }
                      },
                      itemBuilder: (ctx) => [
                        const PopupMenuItem(
                          value: 'reset',
                          child: Row(
                            children: [
                              Icon(Icons.lock_reset_rounded, size: 18),
                              SizedBox(width: 8),
                              Text('إعادة تعيين كلمة المرور'),
                            ],
                          ),
                        ),
                        if (!usr.isAdmin)
                          PopupMenuItem(
                            value: 'toggle',
                            child: Row(
                              children: [
                                Icon(
                                  usr.isDisabled ? Icons.check_circle_outline : Icons.block_rounded,
                                  size: 18,
                                  color: usr.isDisabled ? AppColors.emerald : AppColors.rose,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  usr.isDisabled ? 'تفعيل الحساب' : 'تعطيل الحساب',
                                  style: TextStyle(
                                    color: usr.isDisabled ? AppColors.emerald : AppColors.rose,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _MetricItem({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryDark),
        ),
      ],
    );
  }
}
