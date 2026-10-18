import 'package:flutter/material.dart';
import '../core/models/mock_data.dart';
import '../core/models/transfer_task.dart';
import '../core/theme/app_colors.dart';
import '../core/widgets/glass_card.dart';

class TransferCenterScreen extends StatefulWidget {
  const TransferCenterScreen({super.key});

  @override
  State<TransferCenterScreen> createState() => _TransferCenterScreenState();
}

class _TransferCenterScreenState extends State<TransferCenterScreen> {
  int _selectedTab = 0; // 0: Active, 1: Completed
  late List<TransferTask> _tasks;

  @override
  void initState() {
    super.initState();
    _tasks = List.from(MockData.transferTasks);
  }

  void _toggleTaskStatus(TransferTask task) {
    setState(() {
      if (task.status == TransferStatus.running) {
        task.status = TransferStatus.paused;
        task.speedInMBs = 0.0;
      } else if (task.status == TransferStatus.paused) {
        task.status = TransferStatus.running;
        task.speedInMBs = 6.2;
      }
    });
  }

  void _cancelTask(TransferTask task) {
    setState(() {
      _tasks.remove(task);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم إلغاء عملية "${task.fileName}"')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeTasks = _tasks.where((t) => t.status != TransferStatus.completed).toList();
    final completedTasks = _tasks.where((t) => t.status == TransferStatus.completed).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('مركز مهام النقل'),
        actions: [
          if (_selectedTab == 0 && activeTasks.isNotEmpty) ...[
            TextButton(
              onPressed: () {
                setState(() {
                  for (var t in activeTasks) {
                    t.status = TransferStatus.paused;
                    t.speedInMBs = 0.0;
                  }
                });
              },
              child: const Text('إيقاف الكل', style: TextStyle(color: AppColors.amber)),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  for (var t in activeTasks) {
                    t.status = TransferStatus.running;
                    t.speedInMBs = 7.5;
                  }
                });
              },
              child: const Text('استئناف الكل', style: TextStyle(color: AppColors.emerald)),
            ),
          ],
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Row(
              children: [
                Expanded(
                  child: _TransferTabPill(
                    label: 'العمليات الجارية (${activeTasks.length})',
                    isSelected: _selectedTab == 0,
                    onTap: () => setState(() => _selectedTab = 0),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _TransferTabPill(
                    label: 'المكتملة (${completedTasks.length})',
                    isSelected: _selectedTab == 1,
                    onTap: () => setState(() => _selectedTab = 1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: _selectedTab == 0
          ? _buildActiveTasksView(activeTasks)
          : _buildCompletedTasksView(completedTasks),
    );
  }

  Widget _buildActiveTasksView(List<TransferTask> tasks) {
    if (tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.done_all_rounded, size: 54, color: AppColors.emerald),
            SizedBox(height: 12),
            Text(
              'لا توجد عمليات نقل جارية حالياً',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 4),
            Text(
              'كافة عمليات الرفع والتنزيل مكتملة',
              style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 13),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        final isUpload = task.type == TransferType.upload;
        final isRunning = task.status == TransferStatus.running;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GlassCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: (isUpload ? AppColors.primary : AppColors.cyan).withOpacity(0.14),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        isUpload ? Icons.upload_rounded : Icons.download_rounded,
                        color: isUpload ? AppColors.primary : AppColors.cyan,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task.fileName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            task.path,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryDark),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        isRunning ? Icons.pause_circle_outline_rounded : Icons.play_circle_outline_rounded,
                        color: isRunning ? AppColors.amber : AppColors.emerald,
                      ),
                      onPressed: () => _toggleTaskStatus(task),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: AppColors.rose, size: 20),
                      onPressed: () => _cancelTask(task),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Progress Bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: task.progress,
                    backgroundColor: AppColors.cardLightDark,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isRunning ? (isUpload ? AppColors.primary : AppColors.cyan) : AppColors.amber,
                    ),
                    minHeight: 6,
                  ),
                ),
                const SizedBox(height: 10),

                // Stats footer
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${(task.progress * 100).toInt()}% • ${task.formattedTransferred}',
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryDark),
                    ),
                    Row(
                      children: [
                        if (isRunning) ...[
                          const Icon(Icons.speed_rounded, size: 14, color: AppColors.emerald),
                          const SizedBox(width: 4),
                          Text(
                            task.formattedSpeed,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.emerald,
                            ),
                          ),
                        ] else
                          const Text(
                            'متوقف مؤقتاً',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.amber,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCompletedTasksView(List<TransferTask> tasks) {
    if (tasks.isEmpty) {
      return const Center(child: Text('لا توجد مهام مكتملة مؤخراً'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        final isUpload = task.type == TransferType.upload;
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: GlassCard(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.emerald.withOpacity(0.14),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.check_circle_rounded, color: AppColors.emerald, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.fileName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${isUpload ? "تم الرفع" : "تم التنزيل"} • ${task.formattedTransferred.split(' / ').last}',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('فتح الملف: ${task.fileName}')),
                    );
                  },
                  child: const Text('فتح'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TransferTabPill extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TransferTabPill({
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
