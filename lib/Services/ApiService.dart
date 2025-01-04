import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  Future<bool> submitAddressData(Map<String, dynamic> addressData, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/profileDetail'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(addressData),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Erreur lors de la soumission des données : ${response.statusCode}');
      return false;
    }
  }
}
