import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skool/models/subject_model.dart';

class SubjectRepository {
  final FirebaseFirestore _firestore;

  SubjectRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference get _subjectsCollection => _firestore.collection('subjects');

  // ==================== SUBJECTS ====================

  /// Get all subjects with their chapters and lessons
  Future<List<SubjectModel>> getAllSubjects() async {
    try {
      final snapshot = await _subjectsCollection.orderBy('createdAt', descending: true).get();
      final subjects = <SubjectModel>[];
      
      for (final doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        
        // Fetch chapters for this subject
        final chapters = await getChapters(doc.id);
        subjects.add(SubjectModel.fromJson(data, chapters: chapters));
      }
      
      return subjects;
    } catch (e) {
      throw Exception('فشل في تحميل المواد: $e');
    }
  }

  /// Get subjects for a specific grade
  Future<List<SubjectModel>> getSubjectsForGrade(String grade) async {
    try {
      final snapshot = await _subjectsCollection
          .where('targetGrades', arrayContains: grade)
          .orderBy('createdAt', descending: true)
          .get();
      
      final subjects = <SubjectModel>[];
      for (final doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        final chapters = await getChapters(doc.id);
        subjects.add(SubjectModel.fromJson(data, chapters: chapters));
      }
      
      return subjects;
    } catch (e) {
      throw Exception('فشل في تحميل المواد: $e');
    }
  }

  /// Stream of all subjects (for real-time updates)
  Stream<List<SubjectModel>> subjectsStream() {
    return _subjectsCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
      final subjects = <SubjectModel>[];
      for (final doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        final chapters = await getChapters(doc.id);
        subjects.add(SubjectModel.fromJson(data, chapters: chapters));
      }
      return subjects;
    });
  }

  /// Create a new subject
  Future<String> createSubject(SubjectModel subject) async {
    try {
      final docRef = await _subjectsCollection.add(subject.toJson());
      return docRef.id;
    } catch (e) {
      throw Exception('فشل في إنشاء المادة: $e');
    }
  }

  /// Update an existing subject
  Future<void> updateSubject(SubjectModel subject) async {
    try {
      await _subjectsCollection.doc(subject.id).update(subject.toJson());
    } catch (e) {
      throw Exception('فشل في تحديث المادة: $e');
    }
  }

  /// Delete a subject and all its chapters/lessons
  Future<void> deleteSubject(String subjectId) async {
    try {
      // First delete all chapters and their lessons
      final chapters = await _subjectsCollection.doc(subjectId).collection('chapters').get();
      for (final chapter in chapters.docs) {
        final lessons = await chapter.reference.collection('lessons').get();
        for (final lesson in lessons.docs) {
          await lesson.reference.delete();
        }
        await chapter.reference.delete();
      }
      // Then delete the subject
      await _subjectsCollection.doc(subjectId).delete();
    } catch (e) {
      throw Exception('فشل في حذف المادة: $e');
    }
  }

  // ==================== CHAPTERS ====================

  /// Get all chapters for a subject
  Future<List<ChapterModel>> getChapters(String subjectId) async {
    try {
      final snapshot = await _subjectsCollection
          .doc(subjectId)
          .collection('chapters')
          .orderBy('order')
          .get();
      
      final chapters = <ChapterModel>[];
      for (final doc in snapshot.docs) {
        final data = doc.data();
        data['id'] = doc.id;
        final lessons = await getLessons(subjectId, doc.id);
        chapters.add(ChapterModel.fromJson(data, lessons: lessons));
      }
      
      return chapters;
    } catch (e) {
      return [];
    }
  }

  /// Create a new chapter
  Future<String> createChapter(String subjectId, ChapterModel chapter) async {
    try {
      final docRef = await _subjectsCollection
          .doc(subjectId)
          .collection('chapters')
          .add(chapter.toJson());
      return docRef.id;
    } catch (e) {
      throw Exception('فشل في إنشاء الفصل: $e');
    }
  }

  /// Update a chapter
  Future<void> updateChapter(String subjectId, ChapterModel chapter) async {
    try {
      await _subjectsCollection
          .doc(subjectId)
          .collection('chapters')
          .doc(chapter.id)
          .update(chapter.toJson());
    } catch (e) {
      throw Exception('فشل في تحديث الفصل: $e');
    }
  }

  /// Delete a chapter and all its lessons
  Future<void> deleteChapter(String subjectId, String chapterId) async {
    try {
      final lessons = await _subjectsCollection
          .doc(subjectId)
          .collection('chapters')
          .doc(chapterId)
          .collection('lessons')
          .get();
      
      for (final lesson in lessons.docs) {
        await lesson.reference.delete();
      }
      
      await _subjectsCollection
          .doc(subjectId)
          .collection('chapters')
          .doc(chapterId)
          .delete();
    } catch (e) {
      throw Exception('فشل في حذف الفصل: $e');
    }
  }

  // ==================== LESSONS ====================

  /// Get all lessons for a chapter
  Future<List<LessonModel>> getLessons(String subjectId, String chapterId) async {
    try {
      final snapshot = await _subjectsCollection
          .doc(subjectId)
          .collection('chapters')
          .doc(chapterId)
          .collection('lessons')
          .orderBy('order')
          .get();
      
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return LessonModel.fromJson(data);
      }).toList();
    } catch (e) {
      return [];
    }
  }

  /// Create a new lesson
  Future<String> createLesson(String subjectId, String chapterId, LessonModel lesson) async {
    try {
      final docRef = await _subjectsCollection
          .doc(subjectId)
          .collection('chapters')
          .doc(chapterId)
          .collection('lessons')
          .add(lesson.toJson());
      return docRef.id;
    } catch (e) {
      throw Exception('فشل في إنشاء الدرس: $e');
    }
  }

  /// Update a lesson
  Future<void> updateLesson(String subjectId, String chapterId, LessonModel lesson) async {
    try {
      await _subjectsCollection
          .doc(subjectId)
          .collection('chapters')
          .doc(chapterId)
          .collection('lessons')
          .doc(lesson.id)
          .update(lesson.toJson());
    } catch (e) {
      throw Exception('فشل في تحديث الدرس: $e');
    }
  }

  /// Delete a lesson
  Future<void> deleteLesson(String subjectId, String chapterId, String lessonId) async {
    try {
      await _subjectsCollection
          .doc(subjectId)
          .collection('chapters')
          .doc(chapterId)
          .collection('lessons')
          .doc(lessonId)
          .delete();
    } catch (e) {
      throw Exception('فشل في حذف الدرس: $e');
    }
  }
}
