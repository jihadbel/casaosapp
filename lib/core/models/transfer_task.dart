enum TransferType { upload, download }

enum TransferStatus { queued, running, paused, completed, failed }

class TransferTask {
  final String id;
  final String fileName;
  final String path;
  final TransferType type;
  final int totalBytes;
  int transferredBytes;
  double speedInMBs;
  TransferStatus status;

  TransferTask({
    required this.id,
    required this.fileName,
    required this.path,
    required this.type,
    required this.totalBytes,
    this.transferredBytes = 0,
    this.speedInMBs = 0.0,
    this.status = TransferStatus.queued,
  });

  double get progress => totalBytes > 0 ? (transferredBytes / totalBytes).clamp(0.0, 1.0) : 0.0;

  String get formattedSpeed => '${speedInMBs.toStringAsFixed(1)} MB/s';

  String get formattedTransferred {
    final mbTrans = (transferredBytes / (1024 * 1024)).toStringAsFixed(1);
    final mbTotal = (totalBytes / (1024 * 1024)).toStringAsFixed(1);
    return '$mbTrans / $mbTotal MB';
  }
}
