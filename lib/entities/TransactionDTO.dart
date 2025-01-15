import 'dart:ffi';

class TransactionDTO {
   int? userId;
   int amount;
   int tokens;
   String paymentIntentId;
   String? status;
   String details;

  TransactionDTO({
    this.userId,
    required this.amount,
    required this.tokens,
    required this.paymentIntentId,
    this.status,
    required this.details,
  });

  factory TransactionDTO.fromJson(Map<String, dynamic> json) {
    return TransactionDTO(
      userId: json['userId'],
      amount: json['amount'],
      tokens: json['tokens'],
      paymentIntentId: json['paymentIntentId'],
      status: json['status'],
      details: json['details'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'amount': amount,
      'tokens': tokens,
      'paymentIntentId': paymentIntentId,
      'status': status,
      'details': details,
    };
  }
}
