import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum FileCategory {
  folder,
  image,
  video,
  audio,
  document,
  archive,
  code,
  other,
}

class FileItem {
  final String id;
  final String name;
  final String path;
  final int sizeInBytes;
  final DateTime modifiedDate;
  final bool isDirectory;
  final String? extension;
  final FileCategory category;
  final String? previewThumbnail;

  const FileItem({
    required this.id,
    required this.name,
    required this.path,
    required this.sizeInBytes,
    required this.modifiedDate,
    required this.isDirectory,
    this.extension,
    required this.category,
    this.previewThumbnail,
  });

  String get formattedSize {
    if (isDirectory) return '';
    if (sizeInBytes < 1024) return '$sizeInBytes B';
    if (sizeInBytes < 1024 * 1024) return '${(sizeInBytes / 1024).toStringAsFixed(1)} KB';
    if (sizeInBytes < 1024 * 1024 * 1024) return '${(sizeInBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(sizeInBytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

  IconData get iconData {
    if (isDirectory) return Icons.folder_rounded;
    switch (category) {
      case FileCategory.image:
        return Icons.image_rounded;
      case FileCategory.video:
        return Icons.movie_creation_rounded;
      case FileCategory.audio:
        return Icons.music_note_rounded;
      case FileCategory.document:
        return Icons.description_rounded;
      case FileCategory.archive:
        return Icons.archive_rounded;
      case FileCategory.code:
        return Icons.code_rounded;
      default:
        return Icons.insert_drive_file_rounded;
    }
  }

  Color get color {
    if (isDirectory) return AppColors.amber;
    switch (category) {
      case FileCategory.image:
        return AppColors.cyan;
      case FileCategory.video:
        return AppColors.purple;
      case FileCategory.audio:
        return AppColors.emerald;
      case FileCategory.document:
        return AppColors.primary;
      case FileCategory.archive:
        return AppColors.amber;
      case FileCategory.code:
        return AppColors.indigo;
      default:
        return AppColors.textMutedDark;
    }
  }
}
