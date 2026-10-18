import 'package:flutter/material.dart';
import '../core/models/file_item.dart';
import '../core/models/mock_data.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/theme_controller.dart';
import '../core/widgets/glass_card.dart';
import '../core/widgets/storage_bar.dart';
import '../core/widgets/file_action_sheet.dart';
import 'media_viewer_screen.dart';
import 'text_editor_screen.dart';
import 'trash_screen.dart';
import 'admin_panel_screen.dart';

class DashboardScreen extends StatelessWidget {
  final Function(int)? onNavigateTab;

  const DashboardScreen({super.key, this.onNavigateTab});

  @override
  Widget build(BuildContext context) {
    final user = MockData.currentUser;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.cyan],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.cloud_queue_rounded, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'مرحباً، ${user.username}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 6),
                    if (user.isAdmin)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'Admin',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.primaryLight,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                Text(
                  user.homePath,
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
            tooltip: isDark ? 'التبديل إلى الوضع الفاتح' : 'التبديل إلى الوضع الداكن',
            onPressed: () => ThemeController.instance.toggleTheme(),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded),
            tooltip: 'سلة المحذوفات الخاصة',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TrashScreen()),
              );
            },
          ),
          if (user.isAdmin)
            IconButton(
              icon: const Icon(Icons.admin_panel_settings_outlined),
              tooltip: 'إدارة المستخدمين والنظام',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AdminPanelScreen()),
                );
              },
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // Storage Breakdown Card
          const GlassCard(
            padding: EdgeInsets.all(18),
            child: StorageBar(),
          ),
          const SizedBox(height: 20),

          // Quick Folders Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'المجلدات الذكية',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () => onNavigateTab?.call(1),
                child: const Text('عرض الكل'),
              ),
            ],
          ),
          const SizedBox(height: 8),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.05,
            ),
            itemCount: MockData.quickFolders.length,
            itemBuilder: (context, index) {
              final folder = MockData.quickFolders[index];
              return GlassCard(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                onTap: () {
                  if (folder.name == 'Photos' || folder.name == 'Videos') {
                    onNavigateTab?.call(2); // Gallery tab
                  } else {
                    onNavigateTab?.call(1); // Files tab
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      folder.name == 'Photos'
                          ? Icons.photo_library_rounded
                          : folder.name == 'Videos'
                              ? Icons.video_library_rounded
                              : folder.name == 'Music'
                                  ? Icons.music_note_rounded
                                  : folder.name == 'Mobile_Uploads'
                                      ? Icons.smartphone_rounded
                                      : folder.name == 'Archives'
                                          ? Icons.archive_rounded
                                          : Icons.folder_rounded,
                      color: folder.name == 'Photos'
                          ? AppColors.cyan
                          : folder.name == 'Videos'
                              ? AppColors.purple
                              : folder.name == 'Music'
                                  ? AppColors.emerald
                                  : folder.name == 'Mobile_Uploads'
                                      ? AppColors.primaryLight
                                      : folder.name == 'Archives'
                                          ? AppColors.amber
                                          : AppColors.primary,
                      size: 30,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      folder.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 24),

          // Recent Files Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'الملفات الأخيرة',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () => onNavigateTab?.call(1),
                child: const Text('المستعرض الكامل'),
              ),
            ],
          ),
          const SizedBox(height: 8),

          ...MockData.rootFiles.where((f) => !f.isDirectory).take(4).map((file) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: GlassCard(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                onTap: () {
                  if (file.category == FileCategory.image || file.category == FileCategory.video) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => MediaViewerScreen(file: file)),
                    );
                  } else if (file.category == FileCategory.code || file.category == FileCategory.document) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => TextEditorScreen(file: file)),
                    );
                  } else {
                    FileActionSheet.show(context, file: file);
                  }
                },
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: file.color.withOpacity(0.14),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(file.iconData, color: file.color, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            file.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            '${file.formattedSize} • منذ ساعتين',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_vert_rounded, size: 20),
                      onPressed: () => FileActionSheet.show(context, file: file),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
