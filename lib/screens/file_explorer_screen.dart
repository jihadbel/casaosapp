import 'package:flutter/material.dart';
import '../core/models/file_item.dart';
import '../core/models/mock_data.dart';
import '../core/theme/app_colors.dart';
import '../core/widgets/glass_card.dart';
import '../core/widgets/file_action_sheet.dart';
import 'media_viewer_screen.dart';
import 'text_editor_screen.dart';

class FileExplorerScreen extends StatefulWidget {
  const FileExplorerScreen({super.key});

  @override
  State<FileExplorerScreen> createState() => _FileExplorerScreenState();
}

class _FileExplorerScreenState extends State<FileExplorerScreen> {
  final List<String> _breadcrumbs = ['Home'];
  bool _isGridView = false;
  String _searchQuery = '';
  FileCategory? _selectedCategory;
  final TextEditingController _searchController = TextEditingController();

  List<FileItem> get _filteredFiles {
    return MockData.rootFiles.where((file) {
      final matchesSearch =
          file.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == null ||
          file.category == _selectedCategory ||
          file.isDirectory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  void _showCreateFolderDialog() {
    final folderController = TextEditingController();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.cardDark : AppColors.cardLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Row(
          children: const [
            Icon(Icons.create_new_folder_rounded, color: AppColors.amber),
            SizedBox(width: 10),
            Text('إنشاء مجلد جديد'),
          ],
        ),
        content: TextField(
          controller: folderController,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'اسم المجلد',
            hintText: 'مثال: Backup_Files',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(minimumSize: const Size(90, 40)),
            onPressed: () {
              final name = folderController.text.trim();
              if (name.isNotEmpty) {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('تم إنشاء المجلد "$name" بنجاح'),
                    backgroundColor: AppColors.emerald,
                  ),
                );
              }
            },
            child: const Text('إنشاء'),
          ),
        ],
      ),
    );
  }

  void _showAddActionsMenu() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border(
            top: BorderSide(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.borderDark,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'إضافة ملفات ومجلدات',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.upload_file_rounded, color: AppColors.primary),
              ),
              title: const Text('رفع ملف من الجهاز'),
              subtitle: const Text('يدعم التجزئة والاستئناف للملفات الكبيرة'),
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تمت إضافة الملف إلى قائمة الرفع')),
                );
              },
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.cyan.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.camera_alt_rounded, color: AppColors.cyan),
              ),
              title: const Text('التقاط ورفع صورة / فيديو'),
              subtitle: const Text('مباشرة إلى مجلد Mobile_Uploads'),
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم رفع الصورة بنجاح إلى Mobile_Uploads')),
                );
              },
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.amber.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.create_new_folder_rounded, color: AppColors.amber),
              ),
              title: const Text('مجلد جديد'),
              subtitle: const Text('إنشاء مجلد معزول داخل دليلك الحالي'),
              onTap: () {
                Navigator.pop(ctx);
                _showCreateFolderDialog();
              },
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.indigo.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.note_add_rounded, color: AppColors.indigo),
              ),
              title: const Text('مستند نصي فارغ'),
              subtitle: const Text('إنشاء ملف جديد والفتح في المحرر'),
              onTap: () {
                Navigator.pop(ctx);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TextEditorScreen(
                      file: FileItem(
                        id: 'new-doc',
                        name: 'untitled_note.txt',
                        path: '/untitled_note.txt',
                        sizeInBytes: 0,
                        modifiedDate: DateTime.now(),
                        isDirectory: false,
                        category: FileCategory.code,
                      ),
                      initialContent: '',
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final files = _filteredFiles;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('مستعرض الملفات'),
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.view_list_rounded : Icons.grid_view_rounded),
            tooltip: _isGridView ? 'عرض كقائمة' : 'عرض كشبكة',
            onPressed: () {
              setState(() => _isGridView = !_isGridView);
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort_rounded),
            tooltip: 'ترتيب حسب',
            onSelected: (val) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('تم الترتيب حسب: $val')),
              );
            },
            itemBuilder: (ctx) => [
              const PopupMenuItem(value: 'الاسم (أ-ي)', child: Text('الاسم (أ-ي)')),
              const PopupMenuItem(value: 'تاريخ التعديل', child: Text('تاريخ التعديل')),
              const PopupMenuItem(value: 'الحجم', child: Text('الحجم')),
              const PopupMenuItem(value: 'النوع', child: Text('نوع الملف')),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('إضافة', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        onPressed: _showAddActionsMenu,
      ),
      body: Column(
        children: [
          // Breadcrumbs Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : AppColors.cardLight,
              border: Border(
                bottom: BorderSide(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
              ),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _breadcrumbs.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final crumb = entry.value;
                  final isLast = idx == _breadcrumbs.length - 1;

                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: isLast
                            ? null
                            : () {
                                setState(() {
                                  _breadcrumbs.removeRange(idx + 1, _breadcrumbs.length);
                                });
                              },
                        child: Text(
                          crumb,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: isLast ? FontWeight.bold : FontWeight.normal,
                            color: isLast
                                ? AppColors.primary
                                : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                          ),
                        ),
                      ),
                      if (!isLast)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Icon(
                            Icons.chevron_left_rounded,
                            size: 16,
                            color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                          ),
                        ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),

          // Search Bar & Filters
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: 'البحث في ملفات ومجلدات هذا الدليل...',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              ),
            ),
          ),

          // Category Chips Bar
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                _FilterChip(
                  label: 'الكل',
                  isSelected: _selectedCategory == null,
                  onSelected: () => setState(() => _selectedCategory = null),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'الصور',
                  isSelected: _selectedCategory == FileCategory.image,
                  icon: Icons.image_rounded,
                  onSelected: () => setState(() => _selectedCategory = FileCategory.image),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'المستندات',
                  isSelected: _selectedCategory == FileCategory.document,
                  icon: Icons.description_rounded,
                  onSelected: () => setState(() => _selectedCategory = FileCategory.document),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'الفيديو',
                  isSelected: _selectedCategory == FileCategory.video,
                  icon: Icons.movie_creation_rounded,
                  onSelected: () => setState(() => _selectedCategory = FileCategory.video),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'الصوت',
                  isSelected: _selectedCategory == FileCategory.audio,
                  icon: Icons.music_note_rounded,
                  onSelected: () => setState(() => _selectedCategory = FileCategory.audio),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'الأرشيف',
                  isSelected: _selectedCategory == FileCategory.archive,
                  icon: Icons.archive_rounded,
                  onSelected: () => setState(() => _selectedCategory = FileCategory.archive),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),

          // Items count header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${files.length} عنصر',
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryDark),
                ),
              ],
            ),
          ),

          // Files Listing (List or Grid)
          Expanded(
            child: files.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.search_off_rounded, size: 54, color: AppColors.textMutedDark),
                        SizedBox(height: 12),
                        Text('لا توجد ملفات مطابقة', style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  )
                : _isGridView
                    ? GridView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 6, 16, 80),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.95,
                        ),
                        itemCount: files.length,
                        itemBuilder: (context, index) {
                          final file = files[index];
                          return GlassCard(
                            padding: const EdgeInsets.all(12),
                            onTap: () => _handleItemClick(file),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const SizedBox(width: 24),
                                    Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: file.color.withOpacity(0.14),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(file.iconData, color: file.color, size: 26),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.more_vert_rounded, size: 18),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      onPressed: () => FileActionSheet.show(context, file: file),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  file.name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  file.isDirectory ? 'مجلد' : file.formattedSize,
                                  style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryDark),
                                ),
                              ],
                            ),
                          );
                        },
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 6, 16, 80),
                        itemCount: files.length,
                        itemBuilder: (context, index) {
                          final file = files[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: GlassCard(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              onTap: () => _handleItemClick(file),
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
                                          file.isDirectory
                                              ? 'مجلد • انقر للفتح'
                                              : '${file.formattedSize} • تعديل أمس',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: AppColors.textSecondaryDark,
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
                        },
                      ),
          ),
        ],
      ),
    );
  }

  void _handleItemClick(FileItem file) {
    if (file.isDirectory) {
      setState(() {
        _breadcrumbs.add(file.name);
      });
    } else if (file.category == FileCategory.image || file.category == FileCategory.video) {
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
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final IconData? icon;
  final VoidCallback onSelected;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    this.icon,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onSelected,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : (isDark ? AppColors.cardLightDark : AppColors.cardLightLight),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : (isDark ? AppColors.borderDark : AppColors.borderLight),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 15,
                color: isSelected
                    ? Colors.white
                    : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? Colors.white
                    : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
