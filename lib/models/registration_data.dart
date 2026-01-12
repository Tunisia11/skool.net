import 'package:skool/models/user_model.dart'; // For UserRole

class RegistrationData {
  final String? gender;
  final String? name;
  final String? age;
  final String? state;
  final String? grade;
  final String? section;
  final String? bacSection;
  
  // New auth fields
  final String? email;
  final String? phoneNumber;
  final String? password;
  final UserRole role;

  const RegistrationData({
    this.gender,
    this.name,
    this.age,
    this.state,
    this.grade,
    this.section,
    this.bacSection,
    this.email,
    this.phoneNumber,
    this.password,
    this.role = UserRole.student, // Default to student
  });

  bool get isBacGrade => grade == 'الثالثة ثانوي (باكالوريا)';
  
  bool get needsSection => grade != null && 
      (grade!.contains('أساسي') || grade!.contains('ثانوي'));

  bool isGenderValid() => gender != null && gender!.isNotEmpty;
  bool isNameValid() => name != null && name!.isNotEmpty;
  bool isAgeValid() => age != null && age!.isNotEmpty;
  bool isStateValid() => state != null && state!.isNotEmpty;
  bool isGradeValid() => grade != null && grade!.isNotEmpty;
  bool isBacSectionValid() => !isBacGrade || (bacSection != null && bacSection!.isNotEmpty);
  
  // New validators
  bool isEmailValid() => email != null && email!.contains('@');
  bool isPhoneNumberValid() => phoneNumber != null && phoneNumber!.length >= 8;
  bool isPasswordValid() => password != null && password!.length >= 6;

  bool isStep1Valid() => isGenderValid();
  bool isStep2Valid() => isNameValid() && isAgeValid();
  bool isStep3Valid() => isStateValid() && isGradeValid() && isBacSectionValid();
  bool isStep4Valid() => isEmailValid() && isPhoneNumberValid() && isPasswordValid();

  RegistrationData copyWith({
    String? gender,
    String? name,
    String? age,
    String? state,
    String? grade,
    String? section,
    String? bacSection,
    String? email,
    String? phoneNumber,
    String? password,
    UserRole? role,
  }) {
    return RegistrationData(
      gender: gender ?? this.gender,
      name: name ?? this.name,
      age: age ?? this.age,
      state: state ?? this.state,
      grade: grade ?? this.grade,
      section: section ?? this.section,
      bacSection: bacSection ?? this.bacSection,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
      role: role ?? this.role,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'gender': gender,
      'name': name,
      'age': int.tryParse(age ?? '') ?? 0, // Convert String age to int
      'state': state,
      'grade': grade,
      'section': section,
      'bacSection': bacSection,
      'email': email,
      'phoneNumber': phoneNumber,
      // Password excluded from Firestore data
    };
  }
}
