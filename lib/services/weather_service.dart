import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather.dart';

class WeatherService {
  static const String apiKey = 'bc910b6dd9aa2d3788adca4f6c49a77f';
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';

  Future<Weather> fetchWeather(String city) async {
    final url = Uri.parse('$baseUrl/weather?q=$city&appid=$apiKey&units=metric');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Erreur API météo');
    }
  }
}
