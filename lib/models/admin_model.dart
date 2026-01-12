import 'package:skool/models/user_model.dart';

class AdminModel extends UserModel {
  final List<String> permissions;
  final String department;

  const AdminModel({
    required super.id,
    required super.email,
    required super.name,
    required super.role,
    required super.createdAt,
    super.phoneNumber,
    super.avatarUrl,
    this.permissions = const [],
    this.department = 'General',
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'phoneNumber': phoneNumber,
      'avatarUrl': avatarUrl,
      'permissions': permissions,
      'department': department,
    };
  }

  factory AdminModel.fromJson(Map<String, dynamic> json) {
    return AdminModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      role: UserRole.admin,
      createdAt: DateTime.parse(json['createdAt'] as String),
      phoneNumber: json['phoneNumber'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      permissions: (json['permissions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      department: json['department'] as String? ?? 'General',
    );
  }

  @override
  List<Object?> get props => [...super.props, permissions, department];
}
