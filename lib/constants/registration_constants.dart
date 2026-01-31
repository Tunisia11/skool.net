class RegistrationConstants {
  // Tunisian States (Governorates)
  static const List<String> tunisianStates = [
    'تونس',
    'أريانة',
    'بن عروس',
    'منوبة',
    'نابل',
    'زغوان',
    'بنزرت',
    'باجة',
    'جندوبة',
    'الكاف',
    'سليانة',
    'القيروان',
    'القصرين',
    'سيدي بوزيد',
    'سوسة',
    'المنستير',
    'المهدية',
    'صفاقس',
    'قفصة',
    'توزر',
    'قبلي',
    'قابس',
    'مدنين',
    'تطاوين',
  ];

  // Tunisian Education System (Primary, Prep, and Secondary)
  static const List<String> grades = [
    'السنة الأولى ابتدائي',
    'السنة الثانية ابتدائي',
    'السنة الثالثة ابتدائي',
    'السنة الرابعة ابتدائي',
    'السنة الخامسة ابتدائي',
    'السنة السادسة ابتدائي',
    'السنة السابعة أساسي',
    'السنة الثامنة أساسي',
    'السنة التاسعة أساسي',
    'السنة الأولى ثانوي',
    'السنة الثانية ثانوي',
    'السنة الثالثة ثانوي',
    'السنة الرابعة ثانوي (باكالوريا)',
  ];

  // Sections for middle/high school
  static const List<String> sections = [
    'آداب',
    'رياضيات',
    'علوم تجريبية',
    'اقتصاد وتصرف',
    'علوم تقنية',
    'علوم الإعلامية',
    'رياضة',
  ];
  // Bac sections
  static const List<String> bacSections = [
    'آداب',
    'رياضيات',
    'علوم تجريبية',
    'اقتصاد وتصرف',
    'علوم تقنية',
    'علوم الإعلامية',
    'رياضة',
  ];

  // Gender options
  static const String genderMale = 'ذكر';
  static const String genderFemale = 'أنثى';

  // Labels
  static const String labelName = 'الاسم الكامل';
  static const String labelAge = 'العمر';
  static const String labelState = 'الولاية';
  static const String labelGrade = 'المستوى الدراسي';
  static const String labelSection = 'الشعبة (اختياري)';
  static const String labelBacSection = 'شعبة الباكالوريا';

  // Validation Messages
  static const String errorGenderRequired = 'الرجاء اختيار الجنس';
  static const String errorNameRequired = 'الرجاء إدخال الاسم الكامل';
  static const String errorAgeRequired = 'الرجاء إدخال العمر';
  static const String errorStateRequired = 'الرجاء اختيار الولاية';
  static const String errorGradeRequired = 'الرجاء اختيار المستوى الدراسي';
  static const String errorBacSectionRequired =
      'الرجاء اختيار شعبة الباكالوريا';

  // Step Titles
  static const String step1Title = 'اختر الجنس';
  static const String step1Subtitle = 'اختر جنس الطالب';
  static const String step2Title = 'ما اسمك؟';
  static const String step2Subtitle = 'أدخل اسمك الكامل';
  static const String step3Title = 'معلومات إضافية';
  static const String step3Subtitle = 'أكمل بياناتك للتسجيل';

  // Buttons
  static const String buttonNext = 'التالي';
  static const String buttonBack = 'رجوع';
  static const String buttonRegister = 'التسجيل';
}
