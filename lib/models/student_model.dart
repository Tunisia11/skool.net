import 'package:skool/models/learning_profile.dart';
import 'package:skool/models/user_model.dart';

class StudentModel extends UserModel {
  @override
  final String state;
  @override
  final String grade;
  @override
  final String? section;
  @override
  final String? bacSection;
  @override
  final double walletBalance;
  final int age;
  
  // E-learning specific
  final List<String> enrolledSubjectIds;
  final List<String> completedLessonIds;
  final LearningProfile? learningProfile;

  const StudentModel({
    required super.id,
    required super.email,
    required super.name,
    required super.role,
    required super.createdAt,
    super.phoneNumber,
    super.avatarUrl,
    required this.state,
    required this.grade,
    this.section,
    this.bacSection,
    required this.walletBalance,
    this.age = 0,
    this.enrolledSubjectIds = const [],
    this.completedLessonIds = const [],
    this.learningProfile,
  });

  @override
  bool get isBacStudent => grade.contains('Bac') || grade.contains('bak') || grade.contains('بكالوريا');
  @override
  String? get displaySection => bacSection ?? section;

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
      'state': state,
      'grade': grade,
      'section': section,
      'bacSection': bacSection,
      'walletBalance': walletBalance,
      'age': age,
      'enrolledSubjectIds': enrolledSubjectIds,
      'completedLessonIds': completedLessonIds,
      'learningProfile': learningProfile?.toJson(),
    };
  }

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      role: UserRole.student,
      createdAt: DateTime.parse(json['createdAt'] as String),
      phoneNumber: json['phoneNumber'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      state: json['state'] as String? ?? 'تونس', // Default fallback
      grade: json['grade'] as String? ?? 'غير محدد',
      section: json['section'] as String?,
      bacSection: json['bacSection'] as String?,
      walletBalance: (json['walletBalance'] as num?)?.toDouble() ?? 0.0,
      age: json['age'] as int? ?? 0,
      enrolledSubjectIds: (json['enrolledSubjectIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      completedLessonIds: (json['completedLessonIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      learningProfile: json['learningProfile'] != null
          ? LearningProfile.fromJson(json['learningProfile'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  List<Object?> get props => [
    ...super.props,
    state,
    grade,
    section,
    bacSection,
    walletBalance,
    age,
    enrolledSubjectIds,
    completedLessonIds,
    learningProfile,
  ];

  StudentModel copyWith({
    String? name,
    String? state,
    String? grade,
    String? section,
    String? bacSection,
    double? walletBalance,
    int? age,
    LearningProfile? learningProfile,
  }) {
    return StudentModel(
      id: id,
      email: email,
      role: role,
      createdAt: createdAt,
      name: name ?? this.name,
      state: state ?? this.state,
      grade: grade ?? this.grade,
      section: section ?? this.section,
      bacSection: bacSection ?? this.bacSection,
      walletBalance: walletBalance ?? this.walletBalance,
      age: age ?? this.age,
      learningProfile: learningProfile ?? this.learningProfile,
    );
  }
}
