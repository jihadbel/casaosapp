import 'package:flutter/material.dart';
import '../core/models/file_item.dart';
import '../core/models/mock_data.dart';
import '../core/theme/app_colors.dart';
import '../core/widgets/glass_card.dart';

class TrashScreen extends StatefulWidget {
  const TrashScreen({super.key});

  @override
  State<TrashScreen> createState() => _TrashScreenState();
}

class _TrashScreenState extends State<TrashScreen> {
  late List<FileItem> _items;

  @override
  void initState() {
    super.initState();
    _items = List.from(MockData.trashItems);
  }

  void _restoreItem(FileItem item) {
    setState(() {
      _items.remove(item);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تمت استعادة "${item.name}" إلى مساره الأصلي'),
        backgroundColor: AppColors.emerald,
      ),
    );
  }

  void _deletePermanently(FileItem item) {
    setState(() {
      _items.remove(item);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم حذف "${item.name}" نهائياً من الخادم'),
        backgroundColor: AppColors.rose,
      ),
    );
  }

  void _confirmEmptyTrash() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.cardDark : AppColors.cardLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Row(
          children: const [
            Icon(Icons.warning_amber_rounded, color: AppColors.rose, size: 28),
            SizedBox(width: 10),
            Text('تفريغ السلة نهائياً؟'),
          ],
        ),
        content: Text(
          'سيتم حذف كافة الملفات والمجلدات الموجودة في سلة المحذوفات نهائياً ولا يمكن استعادتها مرة أخرى.',
          style: TextStyle(
            fontSize: 14,
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.rose,
              minimumSize: const Size(110, 42),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              setState(() => _items.clear());
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم تفريغ سلة المحذوفات بالكامل'),
                  backgroundColor: AppColors.rose,
                ),
              );
            },
            child: const Text('تفريغ الآن'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('سلة المحذوفات الخاصة'),
        actions: [
          if (_items.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: TextButton.icon(
                style: TextButton.styleFrom(foregroundColor: AppColors.rose),
                icon: const Icon(Icons.delete_sweep_rounded, size: 20),
                label: const Text('تفريغ السلة'),
                onPressed: _confirmEmptyTrash,
              ),
            ),
        ],
      ),
      body: _items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.cardLightDark,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.delete_outline_rounded,
                      size: 40,
                      color: AppColors.textMutedDark,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'سلة المحذوفات فارغة',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'الملفات التي تنقلها للسلة تظهر هنا ومحمية من باقي المستخدمين',
                    style: TextStyle(fontSize: 13, color: AppColors.textSecondaryDark),
                  ),
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              children: [
                // Info banner
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.shield_outlined, color: AppColors.primary, size: 20),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'هذه السلة خاصة بحسابك فقط، لا يمكن للمستخدمين الآخرين رؤيتها.',
                          style: TextStyle(fontSize: 12, color: AppColors.primaryLight),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Trash items
                ..._items.map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: GlassCard(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: item.color.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(item.iconData, color: item.color, size: 22),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${item.formattedSize} • حذف منذ يومين',
                                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryDark),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            tooltip: 'استعادة',
                            icon: const Icon(Icons.restore_from_trash_rounded, color: AppColors.emerald),
                            onPressed: () => _restoreItem(item),
                          ),
                          IconButton(
                            tooltip: 'حذف نهائي',
                            icon: const Icon(Icons.close_rounded, color: AppColors.rose),
                            onPressed: () => _deletePermanently(item),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
    );
  }
}
