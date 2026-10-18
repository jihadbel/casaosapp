import 'package:flutter/material.dart';
import '../core/models/file_item.dart';
import '../core/theme/app_colors.dart';

class TextEditorScreen extends StatefulWidget {
  final FileItem file;
  final String? initialContent;

  const TextEditorScreen({
    super.key,
    required this.file,
    this.initialContent,
  });

  @override
  State<TextEditorScreen> createState() => _TextEditorScreenState();
}

class _TextEditorScreenState extends State<TextEditorScreen> {
  late TextEditingController _contentController;
  bool _hasUnsavedChanges = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final defaultContent = widget.initialContent ??
        '''# CasaOS Configuration & Services
version: '3.8'

services:
  casaos-file-server:
    image: icewhale/casaos-user-service:latest
    container_name: casaos_private_files
    restart: unless-stopped
    environment:
      - CASAOS_STANDALONE=1
      - DATA_PATH=/ProgramData/CasaOS/files
      - MAX_UPLOAD_LIMIT=50GB
      - ENFORCE_USER_ISOLATION=true
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - /ProgramData/CasaOS:/DATA
      - /var/run/docker.sock:/var/run/docker.sock

# User settings cache policy
settings:
  smart_auto_sort: true
  recycle_bin_retention_days: 30
''';

    _contentController = TextEditingController(text: defaultContent);
    _contentController.addListener(() {
      if (!_hasUnsavedChanges) {
        setState(() => _hasUnsavedChanges = true);
      }
    });
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  void _saveFile() {
    setState(() => _isSaving = true);
    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) {
        setState(() {
          _isSaving = false;
          _hasUnsavedChanges = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: const [
                Icon(Icons.check_circle_rounded, color: AppColors.emerald),
                SizedBox(width: 10),
                Text('تم حفظ التعديلات وإرسالها إلى الخادم بنجاح'),
              ],
            ),
            backgroundColor: AppColors.cardLightDark,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final lines = _contentController.text.split('\n');

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  widget.file.name,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                if (_hasUnsavedChanges) ...[
                  const SizedBox(width: 6),
                  Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: AppColors.amber,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
            Text(
              widget.file.path,
              style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryDark),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(80, 36),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                backgroundColor: _hasUnsavedChanges ? AppColors.primary : AppColors.cardLightDark,
              ),
              icon: _isSaving
                  ? const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.save_rounded, size: 18),
              label: const Text('حفظ'),
              onPressed: _isSaving ? null : _saveFile,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: AppColors.bgDark,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Line numbers column
                  Container(
                    width: 44,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    color: AppColors.cardDark.withOpacity(0.5),
                    child: ListView.builder(
                      itemCount: lines.length,
                      itemBuilder: (context, index) {
                        return Text(
                          '${index + 1}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12,
                            color: AppColors.textMutedDark,
                            height: 1.45,
                          ),
                        );
                      },
                    ),
                  ),
                  // Code / Text editing body
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      child: TextField(
                        controller: _contentController,
                        maxLines: null,
                        expands: true,
                        keyboardType: TextInputType.multiline,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 13,
                          color: AppColors.textPrimaryDark,
                          height: 1.45,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          fillColor: Colors.transparent,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Bottom Status Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: const BoxDecoration(
              color: AppColors.cardDark,
              border: Border(top: BorderSide(color: AppColors.borderDark)),
            ),
            child: Row(
              children: [
                const Icon(Icons.code_rounded, size: 16, color: AppColors.textMutedDark),
                const SizedBox(width: 6),
                Text(
                  '${lines.length} سطر • ${_contentController.text.length} حرف',
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryDark),
                ),
                const Spacer(),
                const Text(
                  'UTF-8 • YAML/Text',
                  style: TextStyle(fontSize: 12, color: AppColors.textSecondaryDark),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
