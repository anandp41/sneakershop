class AdminData {
  final String adminName;
  final String password;

  AdminData({required this.adminName, required this.password});

  Map<String, dynamic> toMap() {
    return {
      'adminName': adminName,
      'password': password,
    };
  }

  factory AdminData.fromMap(Map<String, dynamic> map) {
    return AdminData(
      adminName: map['adminName'] ?? '',
      password: map['password'] ?? '',
    );
  }
}
