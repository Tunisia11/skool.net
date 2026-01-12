import 'package:equatable/equatable.dart';
import 'package:skool/models/student_model.dart';
import 'package:skool/models/teacher_model.dart';
import 'package:skool/models/admin_model.dart';

enum UserRole {
  student,
  teacher,
  admin;

  String toJson() => name;

  static UserRole fromJson(String json) {
    return UserRole.values.firstWhere((e) => e.name == json);
  }
}

abstract class UserModel extends Equatable {
  final String id;
  final String email;
  final String name;
  final UserRole role;
  final DateTime createdAt;
  final String? phoneNumber;
  final String? avatarUrl;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    required this.createdAt,
    this.phoneNumber,
    this.avatarUrl,
  });

  Map<String, dynamic> toJson();

  static UserModel fromJson(Map<String, dynamic> json) {
    final role = UserRole.fromJson(json['role'] as String);
    
    switch (role) {
      case UserRole.student:
        return StudentModel.fromJson(json);
      case UserRole.teacher:
        return TeacherModel.fromJson(json);
      case UserRole.admin:
        return AdminModel.fromJson(json);
    }
  }

  @override
  List<Object?> get props => [id, email, name, role, createdAt, phoneNumber, avatarUrl];

  // Helper getters for backward compatibility with existing UI
  // These try to access student-specific fields if available
  String get fullName => name;
  
  String get state {
     if (this is StudentModel) return (this as StudentModel).state;
     return '';
  }

  String get grade {
     if (this is StudentModel) return (this as StudentModel).grade;
     return '';
  }

  String? get section {
     if (this is StudentModel) return (this as StudentModel).section;
     return null;
  }

  String? get bacSection {
     if (this is StudentModel) return (this as StudentModel).bacSection;
     return null;
  }

  double get walletBalance {
     if (this is StudentModel) return (this as StudentModel).walletBalance;
     return 0.0;
  }
  
  String get formattedBalance => '${walletBalance.toStringAsFixed(2)} TND';

  bool get isBacStudent {
     if (this is StudentModel) return (this as StudentModel).isBacStudent;
     return false;
  }

  String? get displaySection => bacSection ?? section;

  // Create a demo user for testing (restored for profile/offers pages)
  static UserModel getDemoUser() {
    return StudentModel(
      id: 'demo_user',
      email: 'demo@skool.com',
      name: 'محمد علي',
      role: UserRole.student,
      createdAt: DateTime.now(),
      state: 'تونس',
      grade: 'السنة الرابعة ثانوي',
      section: 'علوم تجريبية',
      walletBalance: 1250.0,
      phoneNumber: '98765432',
    );
  }
}
