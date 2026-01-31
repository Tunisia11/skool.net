import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ResourceModel {
  final String id;
  final String title;
  final String type; // 'pdf', 'link', 'video'
  final String url;

  ResourceModel({
    required this.id,
    required this.title,
    required this.type,
    required this.url,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'type': type,
    'url': url,
  };

  factory ResourceModel.fromJson(Map<String, dynamic> json) => ResourceModel(
    id: json['id'] ?? '',
    title: json['title'] ?? '',
    type: json['type'] ?? 'pdf',
    url: json['url'] ?? '',
  );
}

class LessonModel {
  final String id;
  final String title;
  final String duration;
  final String videoUrl;
  final bool isCompleted;
  final int order;
  final List<ResourceModel> resources;

  LessonModel({
    required this.id,
    required this.title,
    required this.duration,
    required this.videoUrl,
    this.isCompleted = false,
    this.order = 0,
    this.resources = const [],
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'duration': duration,
    'videoUrl': videoUrl,
    'isCompleted': isCompleted,
    'order': order,
    'resources': resources.map((r) => r.toJson()).toList(),
  };

  factory LessonModel.fromJson(Map<String, dynamic> json) => LessonModel(
    id: json['id'] ?? '',
    title: json['title'] ?? '',
    duration: json['duration'] ?? '0:00',
    videoUrl: json['videoUrl'] ?? '',
    isCompleted: json['isCompleted'] ?? false,
    order: json['order'] ?? 0,
    resources: (json['resources'] as List<dynamic>?)
        ?.map((r) => ResourceModel.fromJson(r as Map<String, dynamic>))
        .toList() ?? [],
  );
}

class ChapterModel {
  final String id;
  final String title;
  final String description;
  final int order;
  final bool isLocked;
  final List<LessonModel> lessons;

  ChapterModel({
    required this.id,
    required this.title,
    required this.description,
    this.order = 0,
    this.isLocked = false,
    this.lessons = const [],
  });

  int get videoCount => lessons.length;
  double get progress {
    if (lessons.isEmpty) return 0.0;
    final completed = lessons.where((l) => l.isCompleted).length;
    return completed / lessons.length;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'order': order,
    'isLocked': isLocked,
  };

  factory ChapterModel.fromJson(Map<String, dynamic> json, {List<LessonModel>? lessons}) => ChapterModel(
    id: json['id'] ?? '',
    title: json['title'] ?? '',
    description: json['description'] ?? '',
    order: json['order'] ?? 0,
    isLocked: json['isLocked'] ?? false,
    lessons: lessons ?? [],
  );

  ChapterModel copyWith({List<LessonModel>? lessons}) => ChapterModel(
    id: id,
    title: title,
    description: description,
    order: order,
    isLocked: isLocked,
    lessons: lessons ?? this.lessons,
  );
}

class SubjectModel {
  final String id;
  final String name;
  final String icon;
  final String colorHex;
  final List<String> targetGrades;
  final String createdBy;
  final DateTime createdAt;
  final List<ChapterModel> chapters;

  SubjectModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.colorHex,
    this.targetGrades = const [],
    required this.createdBy,
    required this.createdAt,
    this.chapters = const [],
  });

  Color get color {
    try {
      return Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
    } catch (e) {
      return Colors.blue;
    }
  }

  int get chapterCount => chapters.length;
  int get videoCount => chapters.fold(0, (sum, c) => sum + c.videoCount);
  double get progress {
    if (chapters.isEmpty) return 0.0;
    return chapters.fold(0.0, (sum, c) => sum + c.progress) / chapters.length;
  }

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

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'icon': icon,
    'colorHex': colorHex,
    'targetGrades': targetGrades,
    'createdBy': createdBy,
    'createdAt': Timestamp.fromDate(createdAt),
  };

  factory SubjectModel.fromJson(Map<String, dynamic> json, {List<ChapterModel>? chapters}) {
    DateTime createdAt;
    if (json['createdAt'] is Timestamp) {
      createdAt = (json['createdAt'] as Timestamp).toDate();
    } else if (json['createdAt'] is String) {
      createdAt = DateTime.parse(json['createdAt']);
    } else {
      createdAt = DateTime.now();
    }

    return SubjectModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      icon: json['icon'] ?? 'book',
      colorHex: json['colorHex'] ?? '#2196F3',
      targetGrades: List<String>.from(json['targetGrades'] ?? []),
      createdBy: json['createdBy'] ?? '',
      createdAt: createdAt,
      chapters: chapters ?? [],
    );
  }

  SubjectModel copyWith({List<ChapterModel>? chapters}) => SubjectModel(
    id: id,
    name: name,
    icon: icon,
    colorHex: colorHex,
    targetGrades: targetGrades,
    createdBy: createdBy,
    createdAt: createdAt,
    chapters: chapters ?? this.chapters,
  );

  // Color options for subject creation
  static List<Map<String, dynamic>> get colorOptions => [
    {'name': 'أزرق', 'hex': '#2196F3'},
    {'name': 'أخضر', 'hex': '#4CAF50'},
    {'name': 'بنفسجي', 'hex': '#9C27B0'},
    {'name': 'برتقالي', 'hex': '#FF9800'},
    {'name': 'أحمر', 'hex': '#F44336'},
    {'name': 'نيلي', 'hex': '#3F51B5'},
    {'name': 'سماوي', 'hex': '#00BCD4'},
    {'name': 'وردي', 'hex': '#E91E63'},
  ];

  // Icon options for subject creation
  static List<Map<String, dynamic>> get iconOptions => [
    {'name': 'رياضيات', 'value': 'math', 'icon': Icons.functions},
    {'name': 'فيزياء', 'value': 'physics', 'icon': Icons.science},
    {'name': 'كيمياء', 'value': 'chemistry', 'icon': Icons.biotech},
    {'name': 'أحياء', 'value': 'biology', 'icon': Icons.eco},
    {'name': 'عربية', 'value': 'arabic', 'icon': Icons.translate},
    {'name': 'فرنسية', 'value': 'french', 'icon': Icons.language},
    {'name': 'إنجليزية', 'value': 'english', 'icon': Icons.public},
    {'name': 'تاريخ/جغرافيا', 'value': 'history', 'icon': Icons.map},
    {'name': 'فلسفة', 'value': 'philosophy', 'icon': Icons.psychology},
    {'name': 'إعلامية', 'value': 'computer', 'icon': Icons.computer},
    {'name': 'أخرى', 'value': 'book', 'icon': Icons.book},
  ];
}
