/// Quiz questions data for the onboarding quiz.
/// Organized by grade groups: Primary, Middle, High School, and Bac.

enum QuizGroup { groupA, groupB, groupC, groupD }

class QuizQuestion {
  final String text;
  final String? subtitle;
  final List<String> options;
  final bool isMultiSelect;

  const QuizQuestion({
    required this.text,
    required this.options,
    this.subtitle,
    this.isMultiSelect = false,
  });
}

/// Returns the appropriate quiz group based on grade.
QuizGroup getQuizGroupForGrade(String grade) {
  if (grade.contains('ابتدائي')) {
    return QuizGroup.groupA;
  } else if (grade.contains('أساسي')) {
    return QuizGroup.groupB;
  } else if (grade.contains('باكالوريا') || grade.toLowerCase().contains('bac')) {
    return QuizGroup.groupD;
  } else if (grade.contains('ثانوي')) {
    return QuizGroup.groupC;
  }
  return QuizGroup.groupC; // Default
}

/// Returns quiz questions for a specific group.
List<QuizQuestion> getQuestionsForGroup(QuizGroup group) {
  switch (group) {
    case QuizGroup.groupA: // Primary
      return _primaryQuestions;
    case QuizGroup.groupB: // Middle
      return _middleQuestions;
    case QuizGroup.groupC: // High School
      return _highSchoolQuestions;
    case QuizGroup.groupD: // Bac
      return _bacQuestions;
  }
}

// Primary School Questions (Group A)
const _primaryQuestions = [
  QuizQuestion(
    text: 'عندما تدرس، ما الذي تجده صعبًا؟',
    subtitle: '(اختر ما يصل إلى 2)',
    isMultiSelect: true,
    options: ['لا أفهم الدرس', 'أنسى بسرعة', 'الواجبات المدرسية صعبة', 'لا أحب الدراسة', 'أشعر بالارتباك'],
  ),
  QuizQuestion(
    text: 'كيف تريد أن يساعدك التطبيق؟',
    options: ['شرح الدروس ببساطة', 'المساعدة في الواجبات', 'تمارين تدريبية', 'المراجعة قبل الامتحانات', 'جعل الدراسة ممتعة'],
  ),
  QuizQuestion(
    text: 'متى تدرس عادة؟',
    options: ['بعد المدرسة', 'في الليل', 'فقط قبل الامتحانات', 'بمساعدة أحد', 'لا أدرس حقًا'],
  ),
  QuizQuestion(
    text: 'ماذا تتمنى في المدرسة؟',
    options: ['درجات أفضل', 'فهم الدروس', 'الشعور بالثقة', 'إسعاد والدي', 'الاستمتاع بالمدرسة'],
  ),
];

// Middle School Questions (Group B)
const _middleQuestions = [
  QuizQuestion(
    text: 'ما هو الأصعب بالنسبة لك في المدرسة؟',
    subtitle: '(اختر ما يصل إلى 2)',
    isMultiSelect: true,
    options: ['فهم الدروس', 'حل التمارين', 'الحفظ', 'الخوف قبل الامتحانات', 'نقص الحماس'],
  ),
  QuizQuestion(
    text: 'ما الذي تحتاجه أكثر الآن؟',
    options: ['شروح أفضل', 'تمارين أكثر', 'ملخصات للمراجعة', 'التحضير للامتحانات', 'خطة دراسية واضحة'],
  ),
  QuizQuestion(
    text: 'كيف تدرس عادة؟',
    options: ['بانتظام', 'فقط قبل الامتحانات', 'عندما يضغط علي والدي', 'لوحدي', 'مع وجود مشتتات'],
  ),
  QuizQuestion(
    text: 'ما الذي تريد تحسينه؟',
    options: ['الدرجات', 'الثقة بالنفس', 'التنظيم', 'الفهم', 'نتائج الامتحانات'],
  ),
];

// High School Questions (Group C)
const _highSchoolQuestions = [
  QuizQuestion(
    text: 'ما الذي يعيق تقدمك أكثر؟',
    subtitle: '(اختر ما يصل إلى 2)',
    isMultiSelect: true,
    options: ['ضعف الأساسيات', 'كثرة الدروس', 'سوء التنظيم', 'الضغط والتوتر', 'نقص الحماس'],
  ),
  QuizQuestion(
    text: 'ماذا تتوقع من هذا التطبيق؟',
    options: ['تفسيرات واضحة', 'مراجعة منظمة', 'تمارين تشبه الامتحانات', 'مساعدة في إدارة الوقت', 'متابعة التقدم'],
  ),
  QuizQuestion(
    text: 'كيف تدرس عادة؟',
    options: ['وفق خطة', 'عشوائياً', 'في اللحظة الأخيرة', 'جلسات طويلة', 'جلسات قصيرة'],
  ),
  QuizQuestion(
    text: 'ما هو هدفك الرئيسي؟',
    options: ['تحسين الدرجات', 'التحضير للباكالوريا مبكراً', 'تقليل التوتر', 'إتقان المواد', 'أن أكون من الأوائل'],
  ),
];

// Bac Questions (Group D)
const _bacQuestions = [
  QuizQuestion(
    text: 'ما الذي يقلقك أكثر بخصوص الباكالوريا؟',
    subtitle: '(اختر ما يصل إلى 2)',
    isMultiSelect: true,
    options: ['ضيق الوقت', 'ضعف المكتسبات السابقة', 'كثرة المواد', 'الخوف والقلق', 'نقص التدريب'],
  ),
  QuizQuestion(
    text: 'ما المساعدة التي تحتاجها أكثر الآن؟',
    options: ['مراجعة مركزة للباكالوريا', 'تمارين مع الإصلاح', 'خطة شخصية', 'التحكم في التوتر', 'متابعة التقدم'],
  ),
  QuizQuestion(
    text: 'كيف تحضر للباكالوريا؟',
    options: ['يومياً', 'أسبوعياً', 'في الأشهر الأخيرة فقط', 'بدون خطة واضحة', 'دروس خصوصية + دراسة ذاتية'],
  ),
  QuizQuestion(
    text: 'ما هو هدفك في الباكالوريا؟',
    options: ['النجاح', 'الحصول على معدل جيد', 'التوجيه لاختصاص معين', 'الشعور بالثقة', 'بذل قصارى جهدي'],
  ),
];
