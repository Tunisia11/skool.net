import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skool/constants/app_colors.dart';
import 'package:skool/cubits/auth/auth_cubit.dart';
import 'package:skool/cubits/auth/auth_state.dart';
import 'package:skool/data/quiz_questions_data.dart';
import 'package:skool/models/learning_profile.dart';
import 'package:skool/models/student_model.dart';
import 'package:skool/widgets/auth_wrapper.dart';
import 'package:skool/widgets/onboarding/onboarding.dart';

class OnboardingQuizPage extends StatefulWidget {
  const OnboardingQuizPage({super.key});

  @override
  State<OnboardingQuizPage> createState() => _OnboardingQuizPageState();
}

class _OnboardingQuizPageState extends State<OnboardingQuizPage> {
  final PageController _pageController = PageController();
  int _currentQuestionIndex = 0;

  late List<QuizQuestion> _questions;
  bool _isLoading = true;

  // Answers
  final List<String> _q1Answers = [];
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
      final group = getQuizGroupForGrade(grade);
      _questions = getQuestionsForGroup(group);
    } else {
      _questions = getQuestionsForGroup(QuizGroup.groupC);
    }
    setState(() => _isLoading = false);
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
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
                child: SizedBox(
                  width: contentWidth,
                  child: Column(
                    children: [
                      QuizHeader(
                        currentQuestionIndex: _currentQuestionIndex,
                        totalQuestions: _questions.length,
                        onBackTap: _currentQuestionIndex > 0
                            ? _previousPage
                            : () => Navigator.pop(context),
                        onSkipTap: _finishQuiz,
                      ),
                      Expanded(
                        child: PageView.builder(
                          controller: _pageController,
                          physics: const NeverScrollableScrollPhysics(),
                          onPageChanged: (index) {
                            setState(() => _currentQuestionIndex = index);
                          },
                          itemCount: _questions.length,
                          itemBuilder: (context, index) {
                            final q = _questions[index];
                            if (q.isMultiSelect) {
                              return QuizMultiSelectQuestion(
                                question: q.text,
                                subtitle: q.subtitle,
                                options: q.options,
                                selectedOptions: _q1Answers,
                                onSelectionChanged: (val) {
                                  setState(() {
                                    if (_q1Answers.contains(val)) {
                                      _q1Answers.remove(val);
                                    } else if (_q1Answers.length < 2) {
                                      _q1Answers.add(val);
                                    }
                                  });
                                },
                              );
                            }
                            return QuizSingleSelectQuestion(
                              question: q.text,
                              subtitle: q.subtitle,
                              options: q.options,
                              selectedOption: _getAnswerForIndex(index),
                              onOptionSelected: (val) {
                                setState(() => _setAnswerForIndex(index, val));
                              },
                            );
                          },
                        ),
                      ),
                      BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, state) {
                          return QuizBottomBar(
                            currentQuestionIndex: _currentQuestionIndex,
                            totalQuestions: _questions.length,
                            isLoading: state is AuthLoading,
                            onPreviousTap: _previousPage,
                            onNextTap: _nextPage,
                          );
                        },
                      ),
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
}
