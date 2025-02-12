import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:khedma/Services/JWTService.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';

import 'SharedPrefService.dart';

class MinIOService {
  final String apiUrl =
      'http://localhost:8080/minio';
  JWTService jwtService = JWTService();
  SharedPrefService sharedPrefService = SharedPrefService();

  Future<String> saveFileToServer(String bucketName, File file) async {
    var request = http.MultipartRequest('POST', Uri.parse('$apiUrl/upload'));
    String accessToken = await sharedPrefService.readStringFromPrefs('accessToken');    Map<String, dynamic> payload = jwtService.getUsernameFromToken(accessToken);
    String username = jwtService.getUsernameFromToken(accessToken)['sub'];
    String objectName = '$username-${DateTime.now().millisecondsSinceEpoch}';
    request.fields['bucketName'] = bucketName;
    request.fields['objectName'] = objectName;
    String? mimeType = lookupMimeType(file.path);
    if (mimeType == null) {
      mimeType = 'application/octet-stream';
    }
    request.headers['Authorization'] = 'Bearer $accessToken';
    request.files.add(await http.MultipartFile.fromPath('file', file.path,
        contentType: MediaType.parse(mimeType)));
    var response = await request.send();
    if (response.statusCode == 200) {
      return ('${bucketName}_$objectName');
    } else {
      throw Exception('Failed to upload file: ${response.reasonPhrase}');
    }
  }

  Future<String> saveLocationImagesToServer(String bucketName, File file, int locationId) async {
    var request = http.MultipartRequest('POST', Uri.parse('$apiUrl/upload'));
    String accessToken = await sharedPrefService.readStringFromPrefs('accessToken');    Map<String, dynamic> payload = jwtService.getUsernameFromToken(accessToken);
    String username = jwtService.getUsernameFromToken(accessToken)['sub'];
    String objectName = 'location{$locationId}-${DateTime.now().millisecondsSinceEpoch}';
    request.fields['bucketName'] = bucketName;
    request.fields['objectName'] = objectName;
    String? mimeType = lookupMimeType(file.path);
    if (mimeType == null) {
      mimeType = 'application/octet-stream';
    }
    request.headers['Authorization'] = 'Bearer $accessToken';
    request.files.add(await http.MultipartFile.fromPath('file', file.path,
        contentType: MediaType.parse(mimeType)));
    var response = await request.send();
    if (response.statusCode == 200) {
      return ('${bucketName}_$objectName');
    } else {
      throw Exception('Failed to upload file: ${response.reasonPhrase}');
    }
  }

  Future<String> saveTravailImagesToServer(String bucketName, File file, int travailId) async {
    var request = http.MultipartRequest('POST', Uri.parse('$apiUrl/upload'));
    String accessToken = await sharedPrefService.readStringFromPrefs('accessToken');
    Map<String, dynamic> payload = jwtService.getUsernameFromToken(accessToken);
    String username = jwtService.getUsernameFromToken(accessToken)['sub'];
    String objectName = 'travail{$travailId}-${DateTime.now().millisecondsSinceEpoch}';
    request.fields['bucketName'] = bucketName;
    request.fields['objectName'] = objectName;
    String? mimeType = lookupMimeType(file.path);
    if (mimeType == null) {
      mimeType = 'application/octet-stream';
    }
    request.headers['Authorization'] = 'Bearer $accessToken';
    request.files.add(await http.MultipartFile.fromPath('file', file.path,
        contentType: MediaType.parse(mimeType)));
    var response = await request.send();
    if (response.statusCode == 200) {
      return ('${bucketName}_$objectName');
    } else {
      throw Exception('Failed to upload file: ${response.reasonPhrase}');
    }
  }

  Future<String> LoadFileFromServer(String bucketName, String objectName) async {
    String accessToken = await sharedPrefService.readStringFromPrefs('accessToken');
    var response = await http.get(
      Uri.parse(
          '$apiUrl/download?bucketName=$bucketName&objectName=$objectName'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      print('File downloaded successfully');
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String filePath = '${appDocDir.path}/$objectName';
      if (await File(filePath).exists()) {
         return filePath;
      }
      File file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
      return filePath;
    } else {
      throw Exception('Failed to load file: ${response.reasonPhrase}');
    }
  }
}
