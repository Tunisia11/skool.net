class LiveLesson {
  final String id;
  final String title;
  final String subject;
  final String teacher;
  final DateTime dateTime;
  final int durationMinutes;
  final String level; // e.g., "السنة الرابعة ثانوي"
  final String type; // "live", "recorded", "upcoming"
  final int participants; // number of participants
  final bool isPopular;

  final String? replayUrl;

  LiveLesson({
    required this.id,
    required this.title,
    required this.subject,
    required this.teacher,
    required this.dateTime,
    required this.durationMinutes,
    required this.level,
    required this.type,
    required this.participants,
    this.isPopular = false,
    this.replayUrl,
  });

  // Helper to get formatted time string
  String get timeString {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  // Helper to get date string in Arabic
  String get dateString {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final lessonDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (lessonDate == today) {
      return 'اليوم';
    } else if (lessonDate == tomorrow) {
      return 'غدًا';
    } else {
      final weekdays = ['الأحد', 'الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت'];
      return weekdays[dateTime.weekday % 7];
    }
  }

  // Sample data generator
  static List<LiveLesson> getFakeLessons() {
    final now = DateTime.now();
    
    return [
      // Past Recorded Lessons (Replays)
      LiveLesson(
        id: 'rec1',
        title: 'مراجعة شاملة للميكانيك - الجزء الأول',
        subject: 'الفيزياء',
        teacher: 'الأستاذ أحمد بن سالم',
        dateTime: now.subtract(const Duration(days: 1, hours: 2)),
        durationMinutes: 90,
        level: 'السنة الرابعة ثانوي',
        type: 'recorded',
        participants: 450,
        isPopular: true,
        replayUrl: '#',
      ),
      LiveLesson(
        id: 'rec2',
        title: 'شرح قصيدة إرادة الحياة',
        subject: 'العربية',
        teacher: 'الأستاذ يوسف الكريم',
        dateTime: now.subtract(const Duration(days: 2, hours: 4)),
        durationMinutes: 60,
        level: 'السنة الثالثة ثانوي',
        type: 'recorded',
        participants: 320,
        replayUrl: '#',
      ),
      LiveLesson(
        id: 'rec3',
        title: 'الدوال الأسية واللوغاريتمية',
        subject: 'الرياضيات',
        teacher: 'الأستاذة سارة الهاني',
        dateTime: now.subtract(const Duration(days: 3)),
        durationMinutes: 120,
        level: 'السنة الرابعة ثانوي',
        type: 'recorded',
        participants: 510,
        isPopular: true,
        replayUrl: '#',
      ),

      // Upcoming Lessons (No 'live' status currently)
      LiveLesson(
        id: '1',
        title: 'مراجعة شاملة للميكانيك - الجزء الثاني',
        subject: 'الفيزياء',
        teacher: 'الأستاذ أحمد بن سالم',
        dateTime: DateTime(now.year, now.month, now.day, 18, 0), // Today later
        durationMinutes: 90,
        level: 'السنة الرابعة ثانوي',
        type: 'upcoming',
        participants: 0,
        isPopular: true,
      ),
      LiveLesson(
        id: '2',
        title: 'حل تمارين المعادلات التفاضلية',
        subject: 'الرياضيات',
        teacher: 'الأستاذة سارة الهاني',
        dateTime: DateTime(now.year, now.month, now.day + 1, 16, 30),
        durationMinutes: 60,
        level: 'السنة الرابعة ثانوي',
        type: 'upcoming',
        participants: 0,
        isPopular: false,
      ),
      LiveLesson(
        id: '4',
        title: 'الكيمياء العضوية',
        subject: 'الكيمياء',
        teacher: 'الأستاذة ليلى المنصوري',
        dateTime: DateTime(now.year, now.month, now.day + 2, 10, 0),
        durationMinutes: 75,
        level: 'السنة الرابعة ثانوي',
        type: 'upcoming',
        participants: 0,
        isPopular: true,
      ),
    ];
  }
}
