import 'package:flutter/material.dart';

enum TransactionType {
  recharge,
  payment,
  refund,
}

class TransactionModel {
  final String id;
  final double amount;
  final TransactionType type;
  final DateTime dateTime;
  final String description;

  TransactionModel({
    required this.id,
    required this.amount,
    required this.type,
    required this.dateTime,
    required this.description,
  });

  // Get formatted amount with sign
  String get formattedAmount {
    final sign = type == TransactionType.recharge || type == TransactionType.refund ? '+' : '-';
    return '$sign${amount.toStringAsFixed(2)} TND';
  }

  // Get color based on transaction type
  Color get typeColor {
    switch (type) {
      case TransactionType.recharge:
        return Colors.green;
      case TransactionType.payment:
        return Colors.red;
      case TransactionType.refund:
        return Colors.blue;
    }
  }

  // Get icon based on transaction type
  IconData get typeIcon {
    switch (type) {
      case TransactionType.recharge:
        return Icons.add_circle;
      case TransactionType.payment:
        return Icons.remove_circle;
      case TransactionType.refund:
        return Icons.refresh;
    }
  }

  // Get formatted date string
  String get formattedDate {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final transactionDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (transactionDate == today) {
      return 'اليوم ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else if (transactionDate == today.subtract(const Duration(days: 1))) {
      return 'أمس ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  // Generate fake transaction history
  static List<TransactionModel> getFakeTransactions() {
    final now = DateTime.now();

    return [
      TransactionModel(
        id: 't1',
        amount: 50.0,
        type: TransactionType.recharge,
        dateTime: now.subtract(const Duration(hours: 2)),
        description: 'شحن رصيد - بطاقة ائتمان',
      ),
      TransactionModel(
        id: 't2',
        amount: 25.0,
        type: TransactionType.payment,
        dateTime: now.subtract(const Duration(days: 1, hours: 5)),
        description: 'حصة مباشرة - الفيزياء',
      ),
      TransactionModel(
        id: 't3',
        amount: 100.0,
        type: TransactionType.recharge,
        dateTime: now.subtract(const Duration(days: 2)),
        description: 'شحن رصيد - بريد سريع',
      ),
      TransactionModel(
        id: 't4',
        amount: 15.0,
        type: TransactionType.payment,
        dateTime: now.subtract(const Duration(days: 3)),
        description: 'شراء دورة - الرياضيات',
      ),
      TransactionModel(
        id: 't5',
        amount: 30.0,
        type: TransactionType.payment,
        dateTime: now.subtract(const Duration(days: 5)),
        description: 'اشتراك شهري - العلوم',
      ),
      TransactionModel(
        id: 't6',
        amount: 200.0,
        type: TransactionType.recharge,
        dateTime: now.subtract(const Duration(days: 7)),
        description: 'شحن رصيد - تحويل بنكي',
      ),
      TransactionModel(
        id: 't7',
        amount: 10.0,
        type: TransactionType.refund,
        dateTime: now.subtract(const Duration(days: 10)),
        description: 'استرجاع مبلغ - حصة ملغاة',
      ),
      TransactionModel(
        id: 't8',
        amount: 45.0,
        type: TransactionType.payment,
        dateTime: now.subtract(const Duration(days: 12)),
        description: 'حصة مباشرة - الإنجليزية',
      ),
    ];
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'type': type.toString(),
      'dateTime': dateTime.toIso8601String(),
      'description': description,
    };
  }

  // Create from JSON
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      amount: (json['amount'] as num).toDouble(),
      type: TransactionType.values.firstWhere(
        (e) => e.toString() == json['type'],
      ),
      dateTime: DateTime.parse(json['dateTime'] as String),
      description: json['description'] as String,
    );
  }
}
