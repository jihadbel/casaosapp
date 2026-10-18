import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../models/mock_data.dart';

class StorageBar extends StatelessWidget {
  const StorageBar({super.key});

  @override
  Widget build(BuildContext context) {
    const total = MockData.totalStorageGB;
    const photosW = (MockData.photosSizeGB / total);
    const videosW = (MockData.videosSizeGB / total);
    const docsW = (MockData.documentsSizeGB / total);
    const audioW = (MockData.audioSizeGB / total);
    const archivesW = (MockData.archivesSizeGB / total);
    const freeW = (MockData.freeStorageGB / total);

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'مساحة التخزين الخاصة',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 2),
                Text(
                  '${MockData.usedStorageGB.toStringAsFixed(1)} GB مستخدمة من أصل ${MockData.totalStorageGB.toInt()} GB',
                  style: TextStyle(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.primary.withOpacity(0.3)),
              ),
              child: Text(
                '${((MockData.usedStorageGB / total) * 100).toInt()}%',
                style: const TextStyle(
                  color: AppColors.primaryLight,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            height: 12,
            child: Row(
              children: [
                Expanded(flex: (photosW * 1000).toInt(), child: Container(color: AppColors.colorPhotos)),
                const SizedBox(width: 2),
                Expanded(flex: (videosW * 1000).toInt(), child: Container(color: AppColors.colorVideos)),
                const SizedBox(width: 2),
                Expanded(flex: (docsW * 1000).toInt(), child: Container(color: AppColors.colorDocuments)),
                const SizedBox(width: 2),
                Expanded(flex: (audioW * 1000).toInt(), child: Container(color: AppColors.colorAudio)),
                const SizedBox(width: 2),
                Expanded(flex: (archivesW * 1000).toInt(), child: Container(color: AppColors.colorArchives)),
                const SizedBox(width: 2),
                Expanded(
                  flex: (freeW * 1000).toInt(),
                  child: Container(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.cardLightDark
                        : AppColors.cardLightLight,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 14,
          runSpacing: 8,
          children: const [
            _LegendItem(color: AppColors.colorPhotos, label: 'صور (184 GB)'),
            _LegendItem(color: AppColors.colorVideos, label: 'فيديو (142 GB)'),
            _LegendItem(color: AppColors.colorDocuments, label: 'مستندات (35 GB)'),
            _LegendItem(color: AppColors.colorAudio, label: 'صوت (21 GB)'),
            _LegendItem(color: AppColors.colorArchives, label: 'أرشيف (30 GB)'),
          ],
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );
  }
}
