import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/weather.dart';

class WeatherProvider with ChangeNotifier {
  Weather? weather;
  List<Weather> forecast = [];
  List<String> favoriteCities = [];
  bool isLoading = false;
  String? errorMessage;

  // ⚠️ VÉRIFIEZ VOTRE CLÉ ICI
  static const String apiKey = 'bc910b6dd9aa2d3788adca4f6c49a77f';
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';

  // Constructeur : Charge tout au démarrage
  WeatherProvider() {
    loadFavorites(); // Charge les favoris
    loadLastCity();  // Charge la dernière ville
  }

  Future<void> fetchWeather(String city) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final cleanCity = city.trim();
      final urlCurrent = Uri.parse('$baseUrl/weather?q=$cleanCity&appid=$apiKey&units=metric&lang=fr');
      final responseCurrent = await http.get(urlCurrent);

      if (responseCurrent.statusCode == 200) {
        final data = jsonDecode(responseCurrent.body) as Map<String, dynamic>;
        weather = Weather.fromJson(data);

        // Sauvegarde automatique de la dernière ville
        _saveLastCity(cleanCity);

        // Prévisions
        final lat = data['coord']['lat'];
        final lon = data['coord']['lon'];
        final urlForecast = Uri.parse('$baseUrl/forecast?lat=$lat&lon=$lon&appid=$apiKey&units=metric&lang=fr');
        final responseForecast = await http.get(urlForecast);

        if (responseForecast.statusCode == 200) {
          final forecastData = jsonDecode(responseForecast.body);
          forecast = (forecastData['list'] as List).map((item) {
            return Weather.fromJson(item as Map<String, dynamic>);
          }).toList();
        }
      } else if (responseCurrent.statusCode == 401) {
        errorMessage = "Erreur Clé API";
      } else {
        errorMessage = 'Ville introuvable';
      }
    } catch (e) {
      errorMessage = 'Erreur réseau';
    }

    isLoading = false;
    notifyListeners();
  }

  // --- C'EST ICI QUE C'ÉTAIT CASSÉ ---

  void addFavorite(String city) {
    if (!favoriteCities.contains(city)) {
      favoriteCities.add(city);
      notifyListeners();
      _saveFavorites(); // <--- CETTE LIGNE EST OBLIGATOIRE POUR SAUVEGARDER
    }
  }

  void removeFavorite(String city) {
    favoriteCities.remove(city);
    notifyListeners();
    _saveFavorites(); // <--- CETTE LIGNE EST OBLIGATOIRE AUSSI
  }

  // --- FONCTIONS DE PERSISTANCE ---

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorites', favoriteCities);
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    favoriteCities = prefs.getStringList('favorites') ?? [];
    notifyListeners();
  }

  Future<void> _saveLastCity(String city) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_city', city);
  }

  Future<void> loadLastCity() async {
    final prefs = await SharedPreferences.getInstance();
    final lastCity = prefs.getString('last_city');
    if (lastCity != null && lastCity.isNotEmpty) {
      fetchWeather(lastCity);
    }
  }
}