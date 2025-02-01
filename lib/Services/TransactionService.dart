import 'dart:convert';
import 'package:http/http.dart' as http;
import '../entities/TransactionDTO.dart';
import 'SharedPrefService.dart';

class TransactionService {
  final String _baseUrl = 'http://localhost:8080/transaction';
  SharedPrefService sharedPrefService = SharedPrefService();

  Future<String> getOnboardingLink(String accountId) async {
    final url = Uri.parse('$_baseUrl/onboarding-link/$accountId');
    String accessToken = await sharedPrefService.readStringFromPrefs('accessToken');
    try {
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      });
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Failed to get onboarding link: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error getting onboarding link: $e');
    }
  }

  Future<String> buyTokens(TransactionDTO transaction) async {
    final url = Uri.parse('$_baseUrl/buy-tokens');
    String accessToken = await sharedPrefService.readStringFromPrefs('accessToken');
    try {
      print(accessToken);
      final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(transaction.toJson()),
      );
      if (response.statusCode == 200) {
        return "Payment successful. Tokens added to your account.";
      } else {
        throw Exception('Failed to buy tokens: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error buying tokens: $e');
    }
  }

  Future<String> pay(int idClient, int idWorker, int tokens) async {
    final url = Uri.parse('$_baseUrl/pay/$idClient/$idWorker/$tokens');
    String accessToken = await sharedPrefService.readStringFromPrefs('accessToken');

      final response = await http.put(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
      if (response.statusCode == 200) {
        return "Payment successful!-";
      } else return "";

  }

  Future<String> workerPayout(int userId, int tokens) async {
    final url = Uri.parse('$_baseUrl/worker-payout/$userId/$tokens');
    String accessToken = await sharedPrefService.readStringFromPrefs('accessToken');
    try {
      final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
      if (response.statusCode == 200) {
        return "Payout successful. Payout ID: ${json.decode(response.body)['id']}";
      } else {
        throw Exception('Failed to payout worker: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error during payout: $e');
    }
  }
}
