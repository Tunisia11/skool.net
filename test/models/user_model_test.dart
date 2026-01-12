import 'package:flutter_test/flutter_test.dart';
import 'package:skool/models/admin_model.dart';
import 'package:skool/models/student_model.dart';
import 'package:skool/models/teacher_model.dart';
import 'package:skool/models/user_model.dart';

void main() {
  group('UserModel Serialization', () {
    test('StudentModel serialization', () {
      final student = StudentModel(
        id: '123',
        email: 'student@test.com',
        name: 'Ali Student',
        role: UserRole.student,
        createdAt: DateTime(2023, 1, 1),
        state: 'Tunis',
        grade: 'Baccalaureate',
        walletBalance: 100.0,
      );

      final json = student.toJson();
      final fromJson = UserModel.fromJson(json);

      expect(fromJson, isA<StudentModel>());
      expect((fromJson as StudentModel).grade, 'Baccalaureate');
      expect(fromJson.email, 'student@test.com');
      expect(fromJson.role, UserRole.student);
    });

    test('TeacherModel serialization', () {
      final teacher = TeacherModel(
        id: '456',
        email: 'teacher@test.com',
        name: 'Mr. Smith',
        role: UserRole.teacher,
        createdAt: DateTime(2023, 1, 1),
        subject: 'Math',
        yearsOfExperience: 5,
      );

      final json = teacher.toJson();
      final fromJson = UserModel.fromJson(json);

      expect(fromJson, isA<TeacherModel>());
      expect((fromJson as TeacherModel).subject, 'Math');
      expect(fromJson.yearsOfExperience, 5);
    });

    test('AdminModel serialization', () {
      final admin = AdminModel(
        id: '789',
        email: 'admin@test.com',
        name: 'Admin User',
        role: UserRole.admin,
        createdAt: DateTime(2023, 1, 1),
        department: 'IT',
        permissions: ['read', 'write'],
      );

      final json = admin.toJson();
      final fromJson = UserModel.fromJson(json);

      expect(fromJson, isA<AdminModel>());
      expect((fromJson as AdminModel).department, 'IT');
      expect(fromJson.permissions, contains('read'));
    });
  });
}
