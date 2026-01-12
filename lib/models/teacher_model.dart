import 'package:skool/models/user_model.dart';

class TeacherModel extends UserModel {
  final String subject;
  final String? bio;
  final int yearsOfExperience;
  final List<String> specializedGrades;
  final String? specialization;
  final bool isVerified;
  final double rating;

  const TeacherModel({
    required super.id,
    required super.email,
    required super.name,
    required super.role,
    required super.createdAt,
    super.phoneNumber,
    super.avatarUrl,
    required this.subject,
    this.bio,
    this.yearsOfExperience = 0,
    this.specializedGrades = const [],
    this.specialization,
    this.isVerified = false,
    this.rating = 0.0,
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
      'subject': subject,
      'bio': bio,
      'yearsOfExperience': yearsOfExperience,
      'specializedGrades': specializedGrades,
      'specialization': specialization,
      'isVerified': isVerified,
      'rating': rating,
    };
  }

  factory TeacherModel.fromJson(Map<String, dynamic> json) {
    return TeacherModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      role: UserRole.teacher,
      createdAt: DateTime.parse(json['createdAt'] as String),
      phoneNumber: json['phoneNumber'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      subject: json['subject'] as String? ?? 'غير محدد',
      bio: json['bio'] as String?,
      yearsOfExperience: json['yearsOfExperience'] as int? ?? 0,
      specializedGrades: (json['specializedGrades'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      specialization: json['specialization'] as String?,
      isVerified: json['isVerified'] as bool? ?? false,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
    );
  }

  @override
  List<Object?> get props => [
    ...super.props,
    subject,
    bio,
    yearsOfExperience,
    specializedGrades,
    specialization,
    isVerified,
    rating,
  ];
}
