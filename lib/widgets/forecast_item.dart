import 'package:flutter/material.dart';

import '../models/weather.dart';

import 'glass_card.dart'; // Import



class ForecastItem extends StatelessWidget {

  final Weather weather;

  const ForecastItem({super.key, required this.weather});



  @override

  Widget build(BuildContext context) {

    // On enveloppe dans une GlassCard avec moins de padding

    return Container(

      width: 100,

      margin: const EdgeInsets.symmetric(horizontal: 5),

      child: GlassCard(

        padding: const EdgeInsets.all(12),

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            Text(weather.time ?? '', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),

            const SizedBox(height: 5),

            Image.network(

              'https://openweathermap.org/img/wn/${weather.icon}.png',

              width: 50,

              errorBuilder: (_,__,___) => const Icon(Icons.error, color: Colors.white),

            ),

            Text('${weather.temperature.round()}°', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),

          ],

        ),

      ),

    );

  }

}