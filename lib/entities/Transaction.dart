import 'dart:ffi';

import 'package:intl/intl.dart';

class Transaction {
   Long? id;
   Long userId;
   String transactionType;
   int amount;
   int tokens;
   DateTime timestamp;
   String status;
   String paymentIntentId;
   String details;

  Transaction({
    this.id,
    required this.userId,
    required this.transactionType,
    required this.amount,
    required this.tokens,
    required this.timestamp,
    required this.status,
    required this.paymentIntentId,
    required this.details,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      userId: json['userId'],
      transactionType: json['transactionType'],
      amount: json['amount'],
      tokens: json['tokens'],
      timestamp: DateFormat('yyyy-MM-dd').parse(json['timestamp']),
      status: json['status'],
      paymentIntentId: json['paymentIntentId'],
      details: json['details'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'transactionType': transactionType,
      'amount': amount,
      'tokens': tokens,
      'timestamp': DateFormat('yyyy-MM-dd').format(timestamp),
      'status': status,
      'paymentIntentId': paymentIntentId,
      'details': details,
    };
  }
}
