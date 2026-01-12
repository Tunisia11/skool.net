import 'package:flutter/material.dart';

class ResourceModel {
  final String id;
  final String title;
  final String type; // 'pdf', 'link', etc.
  final String url;

  ResourceModel({
    required this.id,
    required this.title,
    required this.type,
    required this.url,
  });
}

class LessonModel {
  final String id;
  final String title;
  final String duration;
  final String videoUrl;
  final bool isCompleted;
  final List<ResourceModel> resources;

  LessonModel({
    required this.id,
    required this.title,
    required this.duration,
    required this.videoUrl,
    this.isCompleted = false,
    this.resources = const [],
  });
}

class ChapterModel {
  final String id;
  final String title;
  final String description;
  final int videoCount;
  final int exerciseCount;
  final double progress; // 0.0 to 1.0
  final bool isLocked;
  final List<LessonModel> lessons;

  ChapterModel({
    required this.id,
    required this.title,
    required this.description,
    required this.videoCount,
    required this.exerciseCount,
    required this.progress,
    this.isLocked = false,
    required this.lessons,
  });
}

class SubjectModel {
  final String id;
  final String name;
  final String icon; // Icon name or image path
  final Color color;
  final double progress; // 0.0 to 1.0
  final int chapterCount;
  final int videoCount;
  final List<String> targetGrades;
  final List<ChapterModel> chapters;

  SubjectModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.progress,
    required this.chapterCount,
    required this.videoCount,
    this.targetGrades = const [],
    required this.chapters,
  });

  // Get generic icon data based on string
  IconData get iconData {
    switch (icon.toLowerCase()) {
      case 'math':
      case 'mathematics':
        return Icons.functions;
      case 'physics':
        return Icons.science;
      case 'chemistry':
        return Icons.biotech;
      case 'biology':
        return Icons.eco;
      case 'arabic':
        return Icons.translate;
      case 'french':
        return Icons.language;
      case 'english':
        return Icons.public;
      case 'history':
      case 'geography':
        return Icons.map;
      case 'philosophy':
        return Icons.psychology;
      case 'computer':
      case 'informatics':
        return Icons.computer;
      default:
        return Icons.book;
    }
  }

  static List<SubjectModel> getFakeSubjects(String userGrade) {
    // Generate resources
    List<ResourceModel> generateResources() {
      return [
        ResourceModel(id: 'r1', title: 'ملخص الدرس PDF', type: 'pdf', url: '#'),
        ResourceModel(id: 'r2', title: 'تمارين تطبيقية', type: 'pdf', url: '#'),
      ];
    }

    // Generate lessons
    List<LessonModel> generateLessons(String chapterTitle) {
      return [
        LessonModel(
          id: 'l1',
          title: 'الفيديو الأول: المفاهيم الأساسية',
          duration: '15:20',
          videoUrl: 'https://vjs.zencdn.net/v/oceans.mp4',
          resources: generateResources(),
        ),
        LessonModel(
          id: 'l2',
          title: 'الفيديو الثاني: شرح معمق',
          duration: '22:45',
          videoUrl: 'https://vjs.zencdn.net/v/oceans.mp4',
          resources: generateResources(),
        ),
        LessonModel(
          id: 'l3',
          title: 'الفيديو الثالث: تطبيقات عملية',
          duration: '18:10',
          videoUrl: 'https://vjs.zencdn.net/v/oceans.mp4',
          resources: generateResources(),
        ),
      ];
    }

    // Generate some fake chapters
    List<ChapterModel> generateChapters(String subjectName) {
      return [
        ChapterModel(
          id: 'c1',
          title: 'المقدمة والأساسيات',
          description: 'نظرة عامة على أهم المفاهيم الأساسية والأدوات اللازمة لبدء الدراسة.',
          videoCount: 5,
          exerciseCount: 10,
          progress: 1.0,
          lessons: generateLessons('المقدمة والأساسيات'),
        ),
        ChapterModel(
          id: 'c2',
          title: 'المحور الأول: التعمق في المفاهيم',
          description: 'شرح مفصل للمحور الأول مع أمثلة تطبيقية وتمارين شاملة.',
          videoCount: 12,
          exerciseCount: 15,
          progress: 0.5,
          lessons: generateLessons('المحور الأول'),
        ),
        ChapterModel(
          id: 'c3',
          title: 'المحور الثاني: النظرية والتطبيق',
          description: 'الانتقال إلى الجانب العملي وكيفية حل المشكلات المعقدة.',
          videoCount: 8,
          exerciseCount: 12,
          progress: 0.0,
          lessons: generateLessons('المحور الثاني'),
        ),
        ChapterModel(
          id: 'c4',
          title: 'المحور الثالث: مراجعة شاملة',
          description: 'ملخص لكل ما سبق مع اختبارات تجريبية استعداداً للامتحانات.',
          videoCount: 10,
          exerciseCount: 20,
          progress: 0.0,
          isLocked: true,
          lessons: generateLessons('المحور الثالث'),
        ),
      ];
    }

    // Basic subjects for everyone
    final List<SubjectModel> subjects = [
      SubjectModel(
        id: 's1',
        name: 'الرياضيات',
        icon: 'math',
        color: Colors.blue,
        progress: 0.65,
        chapterCount: 12,
        videoCount: 48,
        targetGrades: [],
        chapters: generateChapters('الرياضيات'),
      ),
      SubjectModel(
        id: 's2',
        name: 'الفيزياء',
        icon: 'physics',
        color: Colors.purple,
        progress: 0.42,
        chapterCount: 10,
        videoCount: 35,
        targetGrades: [],
        chapters: generateChapters('الفيزياء'),
      ),
      SubjectModel(
        id: 's3',
        name: 'العلوم الطبيعية',
        icon: 'biology',
        color: Colors.green,
        progress: 0.15,
        chapterCount: 8,
        videoCount: 28,
        targetGrades: [],
        chapters: generateChapters('العلوم الطبيعية'),
      ),
      SubjectModel(
        id: 's4',
        name: 'العربية',
        icon: 'arabic',
        color: Colors.orange,
        progress: 0.80,
        chapterCount: 15,
        videoCount: 40,
        targetGrades: [],
        chapters: generateChapters('العربية'),
      ),
      SubjectModel(
        id: 's5',
        name: 'الفرنسية',
        icon: 'french',
        color: Colors.indigo,
        progress: 0.30,
        chapterCount: 9,
        videoCount: 25,
        targetGrades: [],
        chapters: generateChapters('الفرنسية'),
      ),
      SubjectModel(
        id: 's6',
        name: 'الإنجليزية',
        icon: 'english',
        color: Colors.red,
        progress: 0.55,
        chapterCount: 11,
        videoCount: 30,
        targetGrades: [],
        chapters: generateChapters('الإنجليزية'),
      ),
    ];

    // Add specialized subjects for Bac
    if (userGrade.contains('باكالوريا') || userGrade.contains('الثالثة ثانوي')) {
      subjects.addAll([
        SubjectModel(
          id: 's7',
          name: 'الفلسفة',
          icon: 'philosophy',
          color: Colors.brown,
          progress: 0.10,
          chapterCount: 6,
          videoCount: 18,
          targetGrades: ['باكالوريا'],
          chapters: generateChapters('الفلسفة'),
        ),
        SubjectModel(
          id: 's8',
          name: 'الإعلامية',
          icon: 'computer',
          color: Colors.teal,
          progress: 0.90,
          chapterCount: 7,
          videoCount: 20,
          targetGrades: ['باكالوريا'],
          chapters: generateChapters('الإعلامية'),
        ),
      ]);
    }

    return subjects;
  }
}
