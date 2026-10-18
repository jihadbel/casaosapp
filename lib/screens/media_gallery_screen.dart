import 'package:flutter/material.dart';
import '../core/models/file_item.dart';
import '../core/models/mock_data.dart';
import '../core/theme/app_colors.dart';
import 'media_viewer_screen.dart';

class MediaGalleryScreen extends StatefulWidget {
  const MediaGalleryScreen({super.key});

  @override
  State<MediaGalleryScreen> createState() => _MediaGalleryScreenState();
}

class _MediaGalleryScreenState extends State<MediaGalleryScreen> {
  int _selectedTab = 0; // 0: Timeline, 1: Albums

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('معرض الوسائط'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_photo_alternate_rounded),
            tooltip: 'رفع صور جديدة',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم فتح منتقي الصور للرفع إلى مجلد Photos')),
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Row(
              children: [
                Expanded(
                  child: _GalleryTabPill(
                    label: 'الجدول الزمني (Timeline)',
                    isSelected: _selectedTab == 0,
                    onTap: () => setState(() => _selectedTab = 0),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _GalleryTabPill(
                    label: 'الألبومات والمجلدات',
                    isSelected: _selectedTab == 1,
                    onTap: () => setState(() => _selectedTab = 1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: _selectedTab == 0 ? _buildTimelineView() : _buildAlbumsView(),
    );
  }

  Widget _buildTimelineView() {
    final items = MockData.galleryItems;

    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        // Section: Today
        _buildSectionHeader('اليوم - 18 أكتوبر 2026', '${items.take(2).length} وسائط'),
        _buildPhotoGrid(items.take(2).toList()),

        // Section: Yesterday
        _buildSectionHeader('أمس - 17 أكتوبر 2026', '${items.skip(2).take(2).length} وسائط'),
        _buildPhotoGrid(items.skip(2).take(2).toList()),

        // Section: Earlier this week
        _buildSectionHeader('هذا الأسبوع', '${items.skip(4).length} وسائط'),
        _buildPhotoGrid(items.skip(4).toList()),
      ],
    );
  }

  Widget _buildSectionHeader(String title, String count) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          Text(
            count,
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryDark),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoGrid(List<FileItem> items) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
        childAspectRatio: 1.0,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final isVideo = item.category == FileCategory.video;

        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => MediaViewerScreen(file: item)),
            );
          },
          borderRadius: BorderRadius.circular(10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (item.previewThumbnail != null)
                  Image.network(
                    item.previewThumbnail!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: AppColors.cardLightDark,
                      child: Icon(item.iconData, color: item.color),
                    ),
                  )
                else
                  Container(
                    color: AppColors.cardLightDark,
                    child: Icon(item.iconData, color: item.color),
                  ),

                // Video overlay tag
                if (isVideo)
                  Positioned(
                    bottom: 6,
                    left: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.play_arrow_rounded, color: Colors.white, size: 14),
                          SizedBox(width: 2),
                          Text(
                            '02:15',
                            style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAlbumsView() {
    final albums = [
      {'name': 'الصور الشخصية (Photos)', 'count': '420 عنصر', 'icon': Icons.photo_library_rounded, 'color': AppColors.cyan},
      {'name': 'مقاطع الفيديو (Videos)', 'count': '85 فيديو', 'icon': Icons.video_library_rounded, 'color': AppColors.purple},
      {'name': 'مزامنة الهاتف (Mobile_Uploads)', 'count': '1,240 صورة', 'icon': Icons.cloud_sync_rounded, 'color': AppColors.primary},
      {'name': 'المفضلة (Favorites)', 'count': '62 عنصر', 'icon': Icons.favorite_rounded, 'color': AppColors.rose},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: albums.length,
      itemBuilder: (context, index) {
        final album = albums[index];
        final color = album['color'] as Color;
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () => setState(() => _selectedTab = 0),
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : AppColors.cardLight,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(album['icon'] as IconData, color: color, size: 26),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          album['name'] as String,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          album['count'] as String,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _GalleryTabPill extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _GalleryTabPill({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected
                ? Colors.white
                : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
          ),
        ),
      ),
    );
  }
}
