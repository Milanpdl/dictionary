import 'dart:convert';

import 'package:http/http.dart' as http;

import 'dictionaryModel.dart';

class APIservices {
  static String baseUrl = "https://api.dictionaryapi.dev/api/v2/entries/en/";
  static Future<Dictionary?> fetchData(String word) async {
    Uri url = Uri.parse("$baseUrl $word");
    final response = await http.get(url);
    try {
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Dictionary.fromJson(data[0]);
      } else {
        throw Exception("Failure to load Meaning");
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
