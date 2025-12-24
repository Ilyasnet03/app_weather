import 'package:flutter/material.dart';
import '../models/weather.dart';

class WeatherCard extends StatelessWidget {
  final Weather weather;

  const WeatherCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3), // Effet verre
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFAEBaf8).withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Nom de la ville
          Text(
            weather.cityName,
            style: const TextStyle(
              fontSize: 32, 
              fontWeight: FontWeight.bold, 
              color: Colors.white,
              shadows: [Shadow(blurRadius: 5, color: Colors.black12, offset: Offset(2, 2))]
            ),
          ),
          const SizedBox(height: 10),
          // Température
          Text(
            "${weather.temperature.toStringAsFixed(1)}°C",
            style: const TextStyle(
              fontSize: 60, 
              fontWeight: FontWeight.bold, 
              color: Colors.white
            ),
          ),
          // Description (ex: Nuageux)
          Text(
            weather.description.toUpperCase(),
            style: const TextStyle(
              fontSize: 16, 
              letterSpacing: 2,
              color: Colors.white70,
              fontWeight: FontWeight.w500
            ),
          ),
        ],
      ),
    );
  }
}