import 'package:flutter/material.dart';
import '../models/file_item.dart';
import '../theme/app_colors.dart';

class FileActionSheet extends StatelessWidget {
  final FileItem file;
  final VoidCallback? onDownload;
  final VoidCallback? onRename;
  final VoidCallback? onCopyMove;
  final VoidCallback? onEdit;
  final VoidCallback? onCompress;
  final VoidCallback? onTrash;
  final VoidCallback? onDeletePermanent;
  final VoidCallback? onProperties;

  const FileActionSheet({
    super.key,
    required this.file,
    this.onDownload,
    this.onRename,
    this.onCopyMove,
    this.onEdit,
    this.onCompress,
    this.onTrash,
    this.onDeletePermanent,
    this.onProperties,
  });

  static void show(
    BuildContext context, {
    required FileItem file,
    VoidCallback? onDownload,
    VoidCallback? onRename,
    VoidCallback? onCopyMove,
    VoidCallback? onEdit,
    VoidCallback? onCompress,
    VoidCallback? onTrash,
    VoidCallback? onDeletePermanent,
    VoidCallback? onProperties,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => FileActionSheet(
        file: file,
        onDownload: onDownload,
        onRename: onRename,
        onCopyMove: onCopyMove,
        onEdit: onEdit,
        onCompress: onCompress,
        onTrash: onTrash,
        onDeletePermanent: onDeletePermanent,
        onProperties: onProperties,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.cardDark : AppColors.cardLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(top: BorderSide(color: border)),
      ),
      padding: const EdgeInsets.only(bottom: 24, top: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 44,
            height: 4,
            decoration: BoxDecoration(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          // File preview header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: file.color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(file.iconData, color: file.color, size: 26),
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
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        file.isDirectory ? 'مجلد' : '${file.formattedSize} • ${file.extension?.toUpperCase() ?? "ملف"}',
                        style: TextStyle(
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 6),
          // Action list
          if (!file.isDirectory)
            _ActionTile(
              icon: Icons.download_rounded,
              title: 'تنزيل إلى الجهاز',
              color: AppColors.primary,
              onTap: () {
                Navigator.pop(context);
                onDownload?.call();
              },
            ),
          if (file.category == FileCategory.code || file.category == FileCategory.document)
            _ActionTile(
              icon: Icons.edit_note_rounded,
              title: 'فتح في محرر النصوص',
              color: AppColors.indigo,
              onTap: () {
                Navigator.pop(context);
                onEdit?.call();
              },
            ),
          _ActionTile(
            icon: Icons.drive_file_rename_outline_rounded,
            title: 'إعادة التسمية',
            color: AppColors.cyan,
            onTap: () {
              Navigator.pop(context);
              onRename?.call();
            },
          ),
          _ActionTile(
            icon: Icons.drive_file_move_rounded,
            title: 'نقل أو نسخ',
            color: AppColors.purple,
            onTap: () {
              Navigator.pop(context);
              onCopyMove?.call();
            },
          ),
          _ActionTile(
            icon: Icons.folder_zip_rounded,
            title: 'ضغط إلى Zip',
            color: AppColors.amber,
            onTap: () {
              Navigator.pop(context);
              onCompress?.call();
            },
          ),
          _ActionTile(
            icon: Icons.info_outline_rounded,
            title: 'التفاصيل والخصائص',
            color: AppColors.textSecondaryDark,
            onTap: () {
              Navigator.pop(context);
              onProperties?.call();
            },
          ),
          const Divider(height: 16),
          _ActionTile(
            icon: Icons.delete_outline_rounded,
            title: 'نقل إلى سلة المحذوفات',
            color: AppColors.rose,
            onTap: () {
              Navigator.pop(context);
              onTrash?.call();
            },
          ),
          _ActionTile(
            icon: Icons.delete_forever_rounded,
            title: 'حذف نهائي فوري',
            color: AppColors.rose,
            isDestructive: true,
            onTap: () {
              Navigator.pop(context);
              onDeletePermanent?.call();
            },
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;
  final bool isDestructive;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      visualDensity: VisualDensity.compact,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      leading: Container(
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: isDestructive ? FontWeight.w700 : FontWeight.w500,
          color: isDestructive ? AppColors.rose : null,
        ),
      ),
      onTap: onTap,
    );
  }
}
