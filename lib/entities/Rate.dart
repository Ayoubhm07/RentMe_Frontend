import 'dart:ffi';

class AddRateRequest {
  final int userId;
  final double rate;

  AddRateRequest({required this.userId, required this.rate});

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'rate': rate,
  };
}