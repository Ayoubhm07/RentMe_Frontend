
import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
class StripeService{
  String clientKey = "sk_test_51QdfwMD8lq4eL7A0rXTSSHpvm9IVhSUD8wIYU8BDxwVNwuAzXocpxaSJgQcNUHJvDQPQ5Ok3KW3EzI286JUYnT5M00CoRLpYG4";
  createPaymentIntent(String amount, String currency) async {
    try {

      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,

        'payment_method_types[]': 'card'
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer ' + clientKey,
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );

      log('Payment Intent Body->>> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (err) {
      log('err charging user: ${err.toString()}');
    }
  }
  calculateAmount(String amount) {
    final calculatedAmout = (int.parse(amount)) * 100;
    return calculatedAmout.toString();
  }


}



