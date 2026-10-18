class UserAccount {
  final String id;
  final String username;
  final bool isAdmin;
  bool isDisabled;
  final String homePath;
  final DateTime createdAt;

  UserAccount({
    required this.id,
    required this.username,
    required this.isAdmin,
    this.isDisabled = false,
    required this.homePath,
    required this.createdAt,
  });
}
