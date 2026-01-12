import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skool/constants/app_colors.dart';
import 'package:skool/cubits/auth/auth_cubit.dart';
import 'package:skool/cubits/auth/auth_state.dart';
import 'package:skool/models/learning_profile.dart';
import 'package:skool/models/student_model.dart';
import 'package:skool/screens/dashboard_page.dart';
import 'package:skool/widgets/auth_wrapper.dart';

class OnboardingQuizPage extends StatefulWidget {
  const OnboardingQuizPage({super.key});

  @override
  State<OnboardingQuizPage> createState() => _OnboardingQuizPageState();
}

class _OnboardingQuizPageState extends State<OnboardingQuizPage> {
  final PageController _pageController = PageController();
  int _currentQuestionIndex = 0;

  // Data
  late List<_QuizQuestion> _questions;
  bool _isLoading = true;

  // Answers
  final List<String> _q1Answers = []; // Multi-select
  String _q2Answer = '';
  String _q3Answer = '';
  String _q4Answer = '';

  @override
  void initState() {
    super.initState();
    _initQuiz();
  }

  void _initQuiz() {
    final state = context.read<AuthCubit>().state;
    if (state is AuthAuthenticated && state.user is StudentModel) {
      final student = state.user as StudentModel;
      final grade = student.grade ?? '';
      _questions = _getQuestionsForGrade(grade);
    } else {
      // Fallback for testing or error
      _questions = _getQuestionsForGroup(QuizGroup.groupC);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _nextPage() {
    if (_currentQuestionIndex < _questions.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finishQuiz();
    }
  }

  void _previousPage() {
    if (_currentQuestionIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _finishQuiz() async {
    final state = context.read<AuthCubit>().state;
    if (state is AuthAuthenticated && state.user is StudentModel) {
      final student = state.user as StudentModel;

      final profile = LearningProfile(
        studyPainPoints: _q1Answers,
        learningStyle: _q2Answer,
        studyBehavior: _q3Answer,
        primaryGoal: _q4Answer,
        // Default empty for unused fields from previous schema
        selfPerception: '',
        dailyStudyTime: '',
        mainMotivation: '',
        expectedOutcome: '',
        motivationTrigger: '',
      );

      final updatedStudent = student.copyWith(learningProfile: profile);

      await context.read<AuthCubit>().updateUserProfile(updatedStudent);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.primary,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const AuthWrapper()),
            (route) => false,
          );
        } else if (state is AuthError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth > 800;
            final contentWidth = isDesktop ? 600.0 : constraints.maxWidth;

            return SafeArea(
              child: Center(
                child: Container(
                  width: contentWidth,
                  // On desktop, add some margin/padding or shadow if desired, but centering is main goal
                  child: Column(
                    children: [
                       _buildHeader(),
                       Expanded(
                         child: PageView.builder(
                           controller: _pageController,
                           physics: const NeverScrollableScrollPhysics(),
                           onPageChanged: (index) {
                             setState(() {
                               _currentQuestionIndex = index;
                             });
                           },
                           itemCount: _questions.length,
                           itemBuilder: (context, index) {
                             final q = _questions[index];
                             if (q.isMultiSelect) {
                               return _buildMultiSelectQuestion(
                                 question: q.text,
                                 subtitle: q.subtitle,
                                 options: q.options,
                                 selectedOptions: _q1Answers,
                                 onSelectionChanged: (val) {
                                   setState(() {
                                     if (_q1Answers.contains(val)) {
                                       _q1Answers.remove(val);
                                     } else {
                                       if (_q1Answers.length < 2) {
                                         _q1Answers.add(val);
                                       }
                                     }
                                   });
                                 },
                               );
                             } else {
                               return _buildSingleSelectQuestion(
                                 question: q.text,
                                 subtitle: q.subtitle,
                                 options: q.options,
                                 selectedOption: _getAnswerForIndex(index),
                                 onOptionSelected: (val) {
                                   setState(() {
                                     _setAnswerForIndex(index, val);
                                   });
                                 },
                               );
                             }
                           },
                         ),
                       ),
                       _buildBottomBar(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
  
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               IconButton(
                 onPressed: _currentQuestionIndex > 0 ? _previousPage : () => Navigator.pop(context),
                 icon: Container(
                   padding: const EdgeInsets.all(8),
                   decoration: BoxDecoration(
                     shape: BoxShape.circle,
                     border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                   ),
                   child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                 ),
               ),
               Text(
                 'اختبار البروفايل',
                 style: GoogleFonts.cairo(
                   fontSize: 18,
                   fontWeight: FontWeight.bold,
                   color: Colors.white,
                 ),
               ),
                TextButton(
                  onPressed: _finishQuiz, 
                  child: Text(
                    'تخطي',
                    style: GoogleFonts.cairo(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'السؤال ${_currentQuestionIndex + 1}',
                style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.bold),
              ),
               Text(
                '${_currentQuestionIndex + 1} / ${_questions.length}',
                style: GoogleFonts.cairo(color: Colors.white.withValues(alpha: 0.7)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (_currentQuestionIndex + 1) / _questions.length,
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              color: AppColors.secondary, // Amber/Yellow
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildBottomBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Row(
        children: [
           if (_currentQuestionIndex > 0)
             Expanded(
               flex: 1,
               child: OutlinedButton(
                 onPressed: _previousPage,
                 style: OutlinedButton.styleFrom(
                   foregroundColor: Colors.white,
                   side: BorderSide(color: Colors.white.withValues(alpha: 0.5)),
                   padding: const EdgeInsets.symmetric(vertical: 16),
                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                 ),
                 child: Text('السابق', style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
               ),
             )
           else 
            const Spacer(flex: 1),
            
           const SizedBox(width: 16),
           
           // Hint/Idea Button (Placeholder)
            Container(
             height: 48, width: 48,
             decoration: BoxDecoration(
               color: Colors.white.withValues(alpha: 0.2),
               shape: BoxShape.circle,
             ),
             child: const Icon(Icons.lightbulb_outline, color: Colors.white),
           ),
           
           const SizedBox(width: 16),

           Expanded(
             flex: 2,
             child: BlocBuilder<AuthCubit, AuthState>(
               builder: (context, state) {
                 final isLoading = state is AuthLoading;
                 return ElevatedButton(
                   onPressed: isLoading ? null : _nextPage,
                   style: ElevatedButton.styleFrom(
                     backgroundColor: Colors.white,
                     foregroundColor: AppColors.primary,
                     padding: const EdgeInsets.symmetric(vertical: 16),
                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                   ),
                   child: isLoading 
                     ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                     : Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           Text(
                               _currentQuestionIndex == _questions.length - 1 ? 'إنهاء' : 'التالي', 
                               style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 16)
                           ),
                           const SizedBox(width: 8),
                           const Icon(Icons.arrow_forward, size: 18),
                         ],
                       ),
                 );
               },
             ),
           ),
        ],
      ),
    );
  }

  String _getAnswerForIndex(int index) {
    if (index == 1) return _q2Answer;
    if (index == 2) return _q3Answer;
    if (index == 3) return _q4Answer;
    return '';
  }

  void _setAnswerForIndex(int index, String value) {
    if (index == 1) _q2Answer = value;
    if (index == 2) _q3Answer = value;
    if (index == 3) _q4Answer = value;
  }

  // --- UI Builders ---

  Widget _buildSingleSelectQuestion({
    required String question,
    required List<String> options,
    required String selectedOption,
    required ValueChanged<String> onOptionSelected,
    String? subtitle,
  }) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text(
              question,
              style: GoogleFonts.cairo(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white, // White text
                height: 1.3,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: GoogleFonts.cairo(fontSize: 14, color: Colors.white.withValues(alpha: 0.7)),
              ),
            ],
            const SizedBox(height: 20),
            Text(
               'اختر إجابتك',
               style: GoogleFonts.cairo(color: Colors.white.withValues(alpha: 0.6), fontSize: 14),
            ),
            const SizedBox(height: 16),
            ...options.asMap().entries.map((entry) {
              final index = entry.key;
              final option = entry.value;
              final isSelected = selectedOption == option;
              final letter = String.fromCharCode(65 + index); // A, B, C...

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GestureDetector(
                  onTap: () => onOptionSelected(option),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white, // Always white bg
                      borderRadius: BorderRadius.circular(20), // Rounded corners
                      border: isSelected ? Border.all(color: AppColors.secondary, width: 3) : null,
                    ),
                    child: Row(
                      children: [
                        Text(
                          '$letter.',
                          style: GoogleFonts.cairo(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            option,
                            style: GoogleFonts.cairo(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        if (isSelected)
                           const Icon(Icons.check_circle, color: AppColors.secondary),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildMultiSelectQuestion({
    required String question,
    required List<String> options,
    required List<String> selectedOptions,
    required ValueChanged<String> onSelectionChanged,
    String? subtitle,
  }) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
             Text(
              question,
              style: GoogleFonts.cairo(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1.3,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: GoogleFonts.cairo(fontSize: 14, color: Colors.white.withValues(alpha: 0.7)),
              ),
            ],
            const SizedBox(height: 20),
            Text(
               'اختر إجابتك (يمكنك اختيار أكثر من واحدة)',
               style: GoogleFonts.cairo(color: Colors.white.withValues(alpha: 0.6), fontSize: 14),
            ),
            const SizedBox(height: 16),
            ...options.asMap().entries.map((entry) {
              final index = entry.key;
              final option = entry.value;
              final isSelected = selectedOptions.contains(option);
              final letter = String.fromCharCode(65 + index);

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GestureDetector(
                  onTap: () => onSelectionChanged(option),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    decoration: BoxDecoration(
                       color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                       border: isSelected ? Border.all(color: AppColors.secondary, width: 3) : null,
                    ),
                    child: Row(
                      children: [
                         Text(
                          '$letter.',
                          style: GoogleFonts.cairo(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            option,
                            style: GoogleFonts.cairo(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                         if (isSelected)
                           const Icon(Icons.check_circle, color: AppColors.secondary),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  // --- Logic for Groups ---

  List<_QuizQuestion> _getQuestionsForGrade(String grade) {
    if (grade.contains('ابتدائي')) {
      return _getQuestionsForGroup(QuizGroup.groupA);
    } else if (grade.contains('أساسي')) {
      return _getQuestionsForGroup(QuizGroup.groupB);
    } else if (grade.contains('باكالوريا') ||
        grade.toLowerCase().contains('bac')) {
      return _getQuestionsForGroup(QuizGroup.groupD);
    } else if (grade.contains('ثانوي')) {
      // 1st or 2nd secondary
      return _getQuestionsForGroup(QuizGroup.groupC);
    }
    // Default
    return _getQuestionsForGroup(QuizGroup.groupC);
  }

  List<_QuizQuestion> _getQuestionsForGroup(QuizGroup group) {
    switch (group) {
      case QuizGroup.groupA: // Primary
        return [
          _QuizQuestion(
            text: 'عندما تدرس، ما الذي تجده صعبًا؟',
            subtitle: '(اختر ما يصل إلى 2)',
            isMultiSelect: true,
            options: [
              'لا أفهم الدرس',
              'أنسى بسرعة',
              'الواجبات المدرسية صعبة',
              'لا أحب الدراسة',
              'أشعر بالارتباك',
            ],
          ),
          _QuizQuestion(
            text: 'كيف تريد أن يساعدك التطبيق؟',
            options: [
              'شرح الدروس ببساطة',
              'المساعدة في الواجبات',
              'تمارين تدريبية',
              'المراجعة قبل الامتحانات',
              'جعل الدراسة ممتعة',
            ],
          ),
          _QuizQuestion(
            text: 'متى تدرس عادة؟',
            options: [
              'بعد المدرسة',
              'في الليل',
              'فقط قبل الامتحانات',
              'بمساعدة أحد',
              'لا أدرس حقًا',
            ],
          ),
          _QuizQuestion(
            text: 'ماذا تتمنى في المدرسة؟',
            options: [
              'درجات أفضل',
              'فهم الدروس',
              'الشعور بالثقة',
              'إسعاد والدي',
              'الاستمتاع بالمدرسة',
            ],
          ),
        ];

      case QuizGroup.groupB: // Middle
        return [
          _QuizQuestion(
            text: 'ما هو الأصعب بالنسبة لك في المدرسة؟',
            subtitle: '(اختر ما يصل إلى 2)',
            isMultiSelect: true,
            options: [
              'فهم الدروس',
              'حل التمارين',
              'الحفظ',
              'الخوف قبل الامتحانات',
              'نقص الحماس',
            ],
          ),
          _QuizQuestion(
            text: 'ما الذي تحتاجه أكثر الآن؟',
            options: [
              'شروح أفضل',
              'تمارين أكثر',
              'ملخصات للمراجعة',
              'التحضير للامتحانات',
              'خطة دراسية واضحة',
            ],
          ),
          _QuizQuestion(
            text: 'كيف تدرس عادة؟',
            options: [
              'بانتظام',
              'فقط قبل الامتحانات',
              'عندما يضغط علي والدي',
              'لوحدي',
              'مع وجود مشتتات',
            ],
          ),
          _QuizQuestion(
            text: 'ما الذي تريد تحسينه؟',
            options: [
              'الدرجات',
              'الثقة بالنفس',
              'التنظيم',
              'الفهم',
              'نتائج الامتحانات',
            ],
          ),
        ];

      case QuizGroup.groupC: // High School
        return [
          _QuizQuestion(
            text: 'ما الذي يعيق تقدمك أكثر؟',
            subtitle: '(اختر ما يصل إلى 2)',
            isMultiSelect: true,
            options: [
              'ضعف الأساسيات',
              'كثرة الدروس',
              'سوء التنظيم',
              'الضغط والتوتر',
              'نقص الحماس',
            ],
          ),
          _QuizQuestion(
            text: 'ماذا تتوقع من هذا التطبيق؟',
            options: [
              'تفسيرات واضحة',
              'مراجعة منظمة',
              'تمارين تشبه الامتحانات',
              'مساعدة في إدارة الوقت',
              'متابعة التقدم',
            ],
          ),
          _QuizQuestion(
            text: 'كيف تدرس عادة؟',
            options: [
              'وفق خطة',
              'عشوائياً',
              'في اللحظة الأخيرة',
              'جلسات طويلة',
              'جلسات قصيرة',
            ],
          ),
          _QuizQuestion(
            text: 'ما هو هدفك الرئيسي؟',
            options: [
              'تحسين الدرجات',
              'التحضير للباكالوريا مبكراً',
              'تقليل التوتر',
              'إتقان المواد',
              'أن أكون من الأوائل',
            ],
          ),
        ];

      case QuizGroup.groupD: // Bac
        return [
          _QuizQuestion(
            text: 'ما الذي يقلقك أكثر بخصوص الباكالوريا؟',
            subtitle: '(اختر ما يصل إلى 2)',
            isMultiSelect: true,
            options: [
              'ضيق الوقت',
              'ضعف المكتسبات السابقة',
              'كثرة المواد',
              'الخوف والقلق',
              'نقص التدريب',
            ],
          ),
          _QuizQuestion(
            text: 'ما المساعدة التي تحتاجها أكثر الآن؟',
            options: [
              'مراجعة مركزة للباكالوريا',
              'تمارين مع الإصلاح',
              'خطة شخصية',
              'التحكم في التوتر',
              'متابعة التقدم',
            ],
          ),
          _QuizQuestion(
            text: 'كيف تحضر للباكالوريا؟',
            options: [
              'يومياً',
              'أسبوعياً',
              'في الأشهر الأخيرة فقط',
              'بدون خطة واضحة',
              'دروس خصوصية + دراسة ذاتية',
            ],
          ),
          _QuizQuestion(
            text: 'ما هو هدفك في الباكالوريا؟',
            options: [
              'النجاح',
              'الحصول على معدل جيد',
              'التوجيه لاختصاص معين',
              'الشعور بالثقة',
              'بذل قصارى جهدي',
            ],
          ),
        ];
    }
  }
}

enum QuizGroup { groupA, groupB, groupC, groupD }

class _QuizQuestion {
  final String text;
  final String? subtitle;
  final List<String> options;
  final bool isMultiSelect;

  _QuizQuestion({
    required this.text,
    required this.options,
    this.subtitle,
    this.isMultiSelect = false,
  });
}
