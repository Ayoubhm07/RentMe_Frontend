import 'dart:convert';
import 'package:http/http.dart' as http;
import '../entities/Transaction.dart';
import '../entities/TransactionDTO.dart';
import 'SharedPrefService.dart';

class TransactionService {
  final String _baseUrl = 'http://localhost:8080/transaction';
  final http.Client httpClient;
  final SharedPrefService sharedPrefService;

  TransactionService({required this.httpClient, required this.sharedPrefService});

  Future<String> getOnboardingLink(String accountId) async {
    final url = Uri.parse('$_baseUrl/onboarding-link/$accountId');
    try {
      final response = await httpClient.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${await sharedPrefService.readUserData('accessToken')}',
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
    try {
      final response = await httpClient.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await sharedPrefService.readUserData('accessToken')}',
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
    try {
      final response = await httpClient.put(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await sharedPrefService.readUserData('accessToken')}',
        },
      );
      if (response.statusCode == 200) {
        return "Payment successful. Transfer ID: ${json.decode(response.body)['id']}";
      } else {
        throw Exception('Failed to make payment: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error making payment: $e');
    }
  }

  Future<String> workerPayout(int userId, int tokens) async {
    final url = Uri.parse('$_baseUrl/worker-payout/$userId/$tokens');
    try {
      final response = await httpClient.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await sharedPrefService.readUserData('accessToken')}',
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
