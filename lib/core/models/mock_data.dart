import 'file_item.dart';
import 'transfer_task.dart';
import 'user_account.dart';

class MockData {
  // Current logged in user state
  static UserAccount currentUser = UserAccount(
    id: 'u-admin-01',
    username: 'admin',
    isAdmin: true,
    homePath: r'C:\ProgramData\CasaOS\files\admin',
    createdAt: DateTime(2026, 10, 15),
  );

  // Storage Stats (in GB)
  static const double totalStorageGB = 1000.0; // 1 TB
  static const double usedStorageGB = 412.5;
  static const double freeStorageGB = 587.5;
  
  static const double photosSizeGB = 184.2;
  static const double videosSizeGB = 142.0;
  static const double documentsSizeGB = 34.8;
  static const double audioSizeGB = 21.5;
  static const double archivesSizeGB = 30.0;

  // System utilization
  static const int cpuPercent = 16;
  static const double ramUsedGB = 2.1;
  static const double ramTotalGB = 8.0;
  static const String serverUptime = '14d 6h 22m';
  static const String serverVersion = 'CasaOS v0.4.5 (Standalone Multi-User)';

  // Quick folders
  static final List<FileItem> quickFolders = [
    FileItem(
      id: 'f-photos',
      name: 'Photos',
      path: '/Photos',
      sizeInBytes: 0,
      modifiedDate: DateTime.now().subtract(const Duration(minutes: 45)),
      isDirectory: true,
      category: FileCategory.folder,
    ),
    FileItem(
      id: 'f-videos',
      name: 'Videos',
      path: '/Videos',
      sizeInBytes: 0,
      modifiedDate: DateTime.now().subtract(const Duration(hours: 3)),
      isDirectory: true,
      category: FileCategory.folder,
    ),
    FileItem(
      id: 'f-docs',
      name: 'Documents',
      path: '/Documents',
      sizeInBytes: 0,
      modifiedDate: DateTime.now().subtract(const Duration(days: 1)),
      isDirectory: true,
      category: FileCategory.folder,
    ),
    FileItem(
      id: 'f-music',
      name: 'Music',
      path: '/Music',
      sizeInBytes: 0,
      modifiedDate: DateTime.now().subtract(const Duration(days: 3)),
      isDirectory: true,
      category: FileCategory.folder,
    ),
    FileItem(
      id: 'f-mobile',
      name: 'Mobile_Uploads',
      path: '/Mobile_Uploads',
      sizeInBytes: 0,
      modifiedDate: DateTime.now().subtract(const Duration(minutes: 10)),
      isDirectory: true,
      category: FileCategory.folder,
    ),
    FileItem(
      id: 'f-archives',
      name: 'Archives',
      path: '/Archives',
      sizeInBytes: 0,
      modifiedDate: DateTime.now().subtract(const Duration(days: 5)),
      isDirectory: true,
      category: FileCategory.folder,
    ),
  ];

  // Files in Root Explorer
  static final List<FileItem> rootFiles = [
    ...quickFolders,
    FileItem(
      id: 'doc-1',
      name: 'Annual_Financial_Report_2026.pdf',
      path: '/Annual_Financial_Report_2026.pdf',
      sizeInBytes: 8400000, // 8.4 MB
      modifiedDate: DateTime.now().subtract(const Duration(hours: 2)),
      isDirectory: false,
      extension: 'pdf',
      category: FileCategory.document,
    ),
    FileItem(
      id: 'img-1',
      name: 'Server_Architecture_Diagram.png',
      path: '/Server_Architecture_Diagram.png',
      sizeInBytes: 3600000,
      modifiedDate: DateTime.now().subtract(const Duration(hours: 5)),
      isDirectory: false,
      extension: 'png',
      category: FileCategory.image,
      previewThumbnail: 'https://images.unsplash.com/photo-1558494949-ef010cbdcc31?w=400',
    ),
    FileItem(
      id: 'code-1',
      name: 'docker-compose.yaml',
      path: '/docker-compose.yaml',
      sizeInBytes: 4200,
      modifiedDate: DateTime.now().subtract(const Duration(days: 1)),
      isDirectory: false,
      extension: 'yaml',
      category: FileCategory.code,
    ),
    FileItem(
      id: 'zip-1',
      name: 'Project_Backup_Oct_2026.zip',
      path: '/Project_Backup_Oct_2026.zip',
      sizeInBytes: 1540000000, // 1.54 GB
      modifiedDate: DateTime.now().subtract(const Duration(days: 2)),
      isDirectory: false,
      extension: 'zip',
      category: FileCategory.archive,
    ),
    FileItem(
      id: 'vid-1',
      name: 'Camera_Office_Recording_1080p.mp4',
      path: '/Camera_Office_Recording_1080p.mp4',
      sizeInBytes: 450000000, // 450 MB
      modifiedDate: DateTime.now().subtract(const Duration(days: 3)),
      isDirectory: false,
      extension: 'mp4',
      category: FileCategory.video,
    ),
    FileItem(
      id: 'aud-1',
      name: 'Podcast_Episode_42_Audio.mp3',
      path: '/Podcast_Episode_42_Audio.mp3',
      sizeInBytes: 32000000, // 32 MB
      modifiedDate: DateTime.now().subtract(const Duration(days: 4)),
      isDirectory: false,
      extension: 'mp3',
      category: FileCategory.audio,
    ),
  ];

  // Gallery Photos Timeline
  static final List<FileItem> galleryItems = [
    FileItem(
      id: 'g-1',
      name: 'IMG_20261018_142012.jpg',
      path: '/Photos/IMG_20261018_142012.jpg',
      sizeInBytes: 4200000,
      modifiedDate: DateTime.now().subtract(const Duration(hours: 1)),
      isDirectory: false,
      extension: 'jpg',
      category: FileCategory.image,
      previewThumbnail: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?w=600',
    ),
    FileItem(
      id: 'g-2',
      name: 'IMG_20261018_110530.jpg',
      path: '/Photos/IMG_20261018_110530.jpg',
      sizeInBytes: 5100000,
      modifiedDate: DateTime.now().subtract(const Duration(hours: 4)),
      isDirectory: false,
      extension: 'jpg',
      category: FileCategory.image,
      previewThumbnail: 'https://images.unsplash.com/photo-1519681393784-d120267933ba?w=600',
    ),
    FileItem(
      id: 'g-3',
      name: 'VID_20261017_201500.mp4',
      path: '/Videos/VID_20261017_201500.mp4',
      sizeInBytes: 85000000,
      modifiedDate: DateTime.now().subtract(const Duration(days: 1)),
      isDirectory: false,
      extension: 'mp4',
      category: FileCategory.video,
      previewThumbnail: 'https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?w=600',
    ),
    FileItem(
      id: 'g-4',
      name: 'Family_Dinner_Oct2026.jpg',
      path: '/Photos/Family_Dinner_Oct2026.jpg',
      sizeInBytes: 3900000,
      modifiedDate: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
      isDirectory: false,
      extension: 'jpg',
      category: FileCategory.image,
      previewThumbnail: 'https://images.unsplash.com/photo-1492691527719-9d1e07e534b4?w=600',
    ),
    FileItem(
      id: 'g-5',
      name: 'Nature_Trip_Mountain.jpg',
      path: '/Photos/Nature_Trip_Mountain.jpg',
      sizeInBytes: 6800000,
      modifiedDate: DateTime.now().subtract(const Duration(days: 2)),
      isDirectory: false,
      extension: 'jpg',
      category: FileCategory.image,
      previewThumbnail: 'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=600',
    ),
    FileItem(
      id: 'g-6',
      name: 'Drone_Sunset_4K.mp4',
      path: '/Videos/Drone_Sunset_4K.mp4',
      sizeInBytes: 240000000,
      modifiedDate: DateTime.now().subtract(const Duration(days: 3)),
      isDirectory: false,
      extension: 'mp4',
      category: FileCategory.video,
      previewThumbnail: 'https://images.unsplash.com/photo-1495616811223-4d98c6e9c869?w=600',
    ),
    FileItem(
      id: 'g-7',
      name: 'City_Night_Lights.jpg',
      path: '/Photos/City_Night_Lights.jpg',
      sizeInBytes: 4700000,
      modifiedDate: DateTime.now().subtract(const Duration(days: 5)),
      isDirectory: false,
      extension: 'jpg',
      category: FileCategory.image,
      previewThumbnail: 'https://images.unsplash.com/photo-1514565131-fce0801e5785?w=600',
    ),
    FileItem(
      id: 'g-8',
      name: 'Office_Setup_Workspace.jpg',
      path: '/Photos/Office_Setup_Workspace.jpg',
      sizeInBytes: 3200000,
      modifiedDate: DateTime.now().subtract(const Duration(days: 6)),
      isDirectory: false,
      extension: 'jpg',
      category: FileCategory.image,
      previewThumbnail: 'https://images.unsplash.com/photo-1527443224154-c4a3942d3acf?w=600',
    ),
  ];

  // Transfer Tasks (Uploads & Downloads)
  static final List<TransferTask> transferTasks = [
    TransferTask(
      id: 't-1',
      fileName: 'Ubuntu_24_04_Server_ISO.iso',
      path: '/Downloads/Ubuntu_24_04_Server_ISO.iso',
      type: TransferType.download,
      totalBytes: 2600000000, // 2.6 GB
      transferredBytes: 1820000000, // 70%
      speedInMBs: 8.4,
      status: TransferStatus.running,
    ),
    TransferTask(
      id: 't-2',
      fileName: 'Mobile_Backup_DCIM_Oct18.zip',
      path: '/Mobile_Uploads/Mobile_Backup_DCIM_Oct18.zip',
      type: TransferType.upload,
      totalBytes: 840000000,
      transferredBytes: 420000000, // 50%
      speedInMBs: 5.1,
      status: TransferStatus.running,
    ),
    TransferTask(
      id: 't-3',
      fileName: 'Conference_Keynote_Presentation.pptx',
      path: '/Documents/Conference_Keynote_Presentation.pptx',
      type: TransferType.upload,
      totalBytes: 45000000,
      transferredBytes: 45000000,
      speedInMBs: 0.0,
      status: TransferStatus.completed,
    ),
    TransferTask(
      id: 't-4',
      fileName: 'Database_Dump_Production.sql.gz',
      path: '/Archives/Database_Dump_Production.sql.gz',
      type: TransferType.download,
      totalBytes: 310000000,
      transferredBytes: 120000000,
      speedInMBs: 0.0,
      status: TransferStatus.paused,
    ),
  ];

  // Trash Items (.CasaOS-RecycleBin)
  static final List<FileItem> trashItems = [
    FileItem(
      id: 'tr-1',
      name: 'old_contract_draft_v1.docx',
      path: '/.CasaOS-RecycleBin/old_contract_draft_v1.docx',
      sizeInBytes: 1200000,
      modifiedDate: DateTime.now().subtract(const Duration(days: 2)),
      isDirectory: false,
      extension: 'docx',
      category: FileCategory.document,
    ),
    FileItem(
      id: 'tr-2',
      name: 'unwanted_screenshot_102.png',
      path: '/.CasaOS-RecycleBin/unwanted_screenshot_102.png',
      sizeInBytes: 2800000,
      modifiedDate: DateTime.now().subtract(const Duration(days: 4)),
      isDirectory: false,
      extension: 'png',
      category: FileCategory.image,
      previewThumbnail: 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=400',
    ),
    FileItem(
      id: 'tr-3',
      name: 'temp_debug_logs.txt',
      path: '/.CasaOS-RecycleBin/temp_debug_logs.txt',
      sizeInBytes: 54000,
      modifiedDate: DateTime.now().subtract(const Duration(days: 7)),
      isDirectory: false,
      extension: 'txt',
      category: FileCategory.code,
    ),
  ];

  // Local Accounts for Admin Control Panel
  static final List<UserAccount> localUsers = [
    UserAccount(
      id: 'usr-admin',
      username: 'admin',
      isAdmin: true,
      isDisabled: false,
      homePath: r'C:\ProgramData\CasaOS\files\admin',
      createdAt: DateTime(2026, 10, 15),
    ),
    UserAccount(
      id: 'usr-ahmed',
      username: 'ahmed',
      isAdmin: false,
      isDisabled: false,
      homePath: r'C:\ProgramData\CasaOS\files\usr-ahmed',
      createdAt: DateTime(2026, 10, 16),
    ),
    UserAccount(
      id: 'usr-sarah',
      username: 'sarah',
      isAdmin: false,
      isDisabled: true,
      homePath: r'C:\ProgramData\CasaOS\files\usr-sarah',
      createdAt: DateTime(2026, 10, 17),
    ),
    UserAccount(
      id: 'usr-guest',
      username: 'guest_user',
      isAdmin: false,
      isDisabled: false,
      homePath: r'C:\ProgramData\CasaOS\files\usr-guest',
      createdAt: DateTime(2026, 10, 18),
    ),
  ];
}
