
import 'package:equatable/equatable.dart';

class LearningProfile extends Equatable {
  // Q1: What is the hardest part of studying for you? (Multi-select, up to 2)
  final List<String> studyPainPoints;

  // Q2: When you study, what usually happens?
  final String studyBehavior;

  // Q3: Which of these sounds most like you?
  final String selfPerception;

  // Q4: What do you want this app to help you with most?
  final String primaryGoal;

  // Q5: How do you prefer to learn?
  final String learningStyle;

  // Q6: How much time can you realistically study per day?
  final String dailyStudyTime;

  // Q7: What is your main goal right now?
  final String mainMotivation;

  // Q8: If this app works perfectly for you, what would change?
  final String expectedOutcome;

  // Q9: What motivates you most?
  final String motivationTrigger;

  const LearningProfile({
    this.studyPainPoints = const [],
    this.studyBehavior = '',
    this.selfPerception = '',
    this.primaryGoal = '',
    this.learningStyle = '',
    this.dailyStudyTime = '',
    this.mainMotivation = '',
    this.expectedOutcome = '',
    this.motivationTrigger = '',
  });

  LearningProfile copyWith({
    List<String>? studyPainPoints,
    String? studyBehavior,
    String? selfPerception,
    String? primaryGoal,
    String? learningStyle,
    String? dailyStudyTime,
    String? mainMotivation,
    String? expectedOutcome,
    String? motivationTrigger,
  }) {
    return LearningProfile(
      studyPainPoints: studyPainPoints ?? this.studyPainPoints,
      studyBehavior: studyBehavior ?? this.studyBehavior,
      selfPerception: selfPerception ?? this.selfPerception,
      primaryGoal: primaryGoal ?? this.primaryGoal,
      learningStyle: learningStyle ?? this.learningStyle,
      dailyStudyTime: dailyStudyTime ?? this.dailyStudyTime,
      mainMotivation: mainMotivation ?? this.mainMotivation,
      expectedOutcome: expectedOutcome ?? this.expectedOutcome,
      motivationTrigger: motivationTrigger ?? this.motivationTrigger,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'studyPainPoints': studyPainPoints,
      'studyBehavior': studyBehavior,
      'selfPerception': selfPerception,
      'primaryGoal': primaryGoal,
      'learningStyle': learningStyle,
      'dailyStudyTime': dailyStudyTime,
      'mainMotivation': mainMotivation,
      'expectedOutcome': expectedOutcome,
      'motivationTrigger': motivationTrigger,
    };
  }

  factory LearningProfile.fromJson(Map<String, dynamic> json) {
    return LearningProfile(
      studyPainPoints: (json['studyPainPoints'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      studyBehavior: json['studyBehavior'] as String? ?? '',
      selfPerception: json['selfPerception'] as String? ?? '',
      primaryGoal: json['primaryGoal'] as String? ?? '',
      learningStyle: json['learningStyle'] as String? ?? '',
      dailyStudyTime: json['dailyStudyTime'] as String? ?? '',
      mainMotivation: json['mainMotivation'] as String? ?? '',
      expectedOutcome: json['expectedOutcome'] as String? ?? '',
      motivationTrigger: json['motivationTrigger'] as String? ?? '',
    );
  }

  @override
  List<Object?> get props => [
        studyPainPoints,
        studyBehavior,
        selfPerception,
        primaryGoal,
        learningStyle,
        dailyStudyTime,
        mainMotivation,
        expectedOutcome,
        motivationTrigger,
      ];
}
