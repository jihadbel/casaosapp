import 'package:flutter/material.dart';
import '../core/models/mock_data.dart';
import '../core/models/transfer_task.dart';
import '../core/theme/app_colors.dart';
import 'dashboard_screen.dart';
import 'file_explorer_screen.dart';
import 'media_gallery_screen.dart';
import 'transfer_center_screen.dart';
import 'settings_screen.dart';

class MainShellScreen extends StatefulWidget {
  final int initialIndex;

  const MainShellScreen({super.key, this.initialIndex = 0});

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final activeTransfersCount = MockData.transferTasks
        .where((t) => t.status != TransferStatus.completed)
        .length;

    final screens = [
      DashboardScreen(onNavigateTab: _onTabTapped),
      const FileExplorerScreen(),
      const MediaGalleryScreen(),
      const TransferCenterScreen(),
      const SettingsScreen(),
    ];

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
              width: 1,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_rounded),
              label: 'الرئيسية',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.folder_outlined),
              activeIcon: Icon(Icons.folder_rounded),
              label: 'الملفات',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.photo_library_outlined),
              activeIcon: Icon(Icons.photo_library_rounded),
              label: 'المعرض',
            ),
            BottomNavigationBarItem(
              icon: Badge(
                isLabelVisible: activeTransfersCount > 0,
                backgroundColor: AppColors.primary,
                label: Text(
                  '$activeTransfersCount',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                child: const Icon(Icons.swap_vert_rounded),
              ),
              activeIcon: Badge(
                isLabelVisible: activeTransfersCount > 0,
                backgroundColor: AppColors.primary,
                label: Text(
                  '$activeTransfersCount',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                child: const Icon(Icons.swap_vertical_circle_rounded),
              ),
              label: 'النقل',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              activeIcon: Icon(Icons.settings_rounded),
              label: 'الإعدادات',
            ),
          ],
        ),
      ),
    );
  }
}
