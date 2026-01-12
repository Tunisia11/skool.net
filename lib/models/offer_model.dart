import 'package:flutter/material.dart';

enum OfferType {
  silver,
  gold,
  platinum,
}

class OfferModel {
  final String id;
  final String name;
  final OfferType type;
  final String description;
  final double monthlyPrice;
  final double? annualPrice;
  final int? discountPercentage;
  final List<String> features;
  final List<String> targetGrades; // Empty = all grades
  final Color primaryColor;
  final Color secondaryColor;
  final IconData icon;
  final bool isPopular;

  OfferModel({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    required this.monthlyPrice,
    this.annualPrice,
    this.discountPercentage,
    required this.features,
    this.targetGrades = const [],
    required this.primaryColor,
    required this.secondaryColor,
    required this.icon,
    this.isPopular = false,
  });

  String get formattedMonthlyPrice => '${monthlyPrice.toStringAsFixed(0)} دت/الشهر';
  
  String? get formattedAnnualPrice => annualPrice != null 
      ? '${annualPrice!.toStringAsFixed(0)} دت/السنة' 
      : null;

  String get priceDisplay {
    if (annualPrice != null && discountPercentage != null) {
      return 'ابتداءً من $formattedMonthlyPrice';
    }
    return formattedMonthlyPrice;
  }

  // Check if offer is suitable for user's grade
  bool isSuitableForGrade(String userGrade) {
    if (targetGrades.isEmpty) return true;
    return targetGrades.any((grade) => userGrade.contains(grade));
  }

  // Get all predefined offers
  static List<OfferModel> getAllOffers() {
    return [
      // Silver Offer - Basic for all levels
      OfferModel(
        id: 'silver',
        name: 'عرض سيلفر',
        type: OfferType.silver,
        description: 'عرض شهري أو سنوي، مع تخفيض 25% للاشتراكات السنوية',
        monthlyPrice: 20,
        annualPrice: 180,
        discountPercentage: 25,
        targetGrades: [], // All grades
        primaryColor: const Color(0xFF00BCD4),
        secondaryColor: const Color(0xFF0097A7),
        icon: Icons.workspace_premium,
        features: [
          'فيديوهات تفسير كامل الدروس في كل المواد',
          'تمارين مرفقة بالإصلاح مطابقة للبرنامج الرسمي',
          'مجلات تلخيص الدروس (PDF +Magazines)',
          'حصص مباشرة تفاعلية (حصة واحدة)',
          'دعم فني على مدار الساعة',
        ],
      ),

      // Gold Offer - Premium with more live sessions
      OfferModel(
        id: 'gold',
        name: 'عرض جولد',
        type: OfferType.gold,
        description: 'عرض مميز للطلاب الطموحين مع حصص مباشرة إضافية',
        monthlyPrice: 45,
        annualPrice: 400,
        discountPercentage: 26,
        targetGrades: ['ثانوي', 'باكالوريا'],
        primaryColor: const Color(0xFFFFB300),
        secondaryColor: const Color(0xFFF57C00),
        icon: Icons.stars,
        isPopular: true,
        features: [
          'كل مميزات العرض الفضي',
          'حصص مباشرة تفاعلية (4 حصص أسبوعياً)',
          'تصحيحات خصوصية للامتحانات (REC)',
          'فيديوهات تفسير تفصيلية لكل المواد',
          'تمارين مرفقة بالإصلاح مطابقة للبرنامج الرسمي',
          'منتدى - Forum للتفاعل مع الأساتذة وطرح الأسئلة في أي وقت',
          'مراجعة شاملة قبل الامتحانات الرسمية',
        ],
      ),

      // Platinum Offer - Complete unlimited package
      OfferModel(
        id: 'platinum',
        name: 'عرض بلاتينيوم',
        type: OfferType.platinum,
        description: 'الباقة الكاملة للنجاح المضمون - وصول غير محدود لكل المحتوى',
        monthlyPrice: 75,
        annualPrice: 650,
        discountPercentage: 28,
        targetGrades: ['الثالثة ثانوي', 'باكالوريا'],
        primaryColor: const Color(0xFF7B1FA2),
        secondaryColor: const Color(0xFF4A148C),
        icon: Icons.diamond,
        features: [
          'كل مميزات العرض الذهبي',
          'حصص مباشرة غير محدودة (يومياً)',
          'تصحيحات خصوصية مباشرة للامتحانات (REC)',
          'متابعة شخصية مع مدرس خاص',
          'جلسات استشارية للتوجيه الدراسي',
          'امتحانات تجريبية أسبوعية مع التصحيح',
          'تطبيق جوال حصري مع مزايا إضافية',
          'أولوية في الحصص المباشرة والرد على الأسئلة',
          'شهادة إتمام معتمدة',
        ],
      ),
    ];
  }

  // Get recommended offer for user's grade
  static OfferModel? getRecommendedOffer(String userGrade) {
    final offers = getAllOffers();
    
    // Platinum for Bac students
    if (userGrade.contains('باكالوريا') || userGrade.contains('الثالثة ثانوي')) {
      return offers.firstWhere((o) => o.type == OfferType.platinum);
    }
    
    // Gold for secondary students
    if (userGrade.contains('ثانوي')) {
      return offers.firstWhere((o) => o.type == OfferType.gold);
    }
    
    // Silver for others
    return offers.firstWhere((o) => o.type == OfferType.silver);
  }
}
