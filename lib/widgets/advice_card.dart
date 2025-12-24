import 'package:flutter/material.dart';
import '../models/weather.dart';
import 'glass_card.dart'; 

class AdviceCard extends StatelessWidget {
  final Weather weather;
  const AdviceCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: GlassCard(
        child: Row(
          children: [
            // Partie Gauche : L'icône (Design conservé)
            CircleAvatar(
              backgroundColor: Colors.white.withOpacity(0.3),
              child: const Icon(Icons.lightbulb, color: Colors.amber),
            ),
            const SizedBox(width: 15),
            
            // Partie Droite : Le texte du conseil
            Expanded(
              child: Text(
                // Cette fonction appelle maintenant votre logique complexe (pluie + moto + temp)
                weather.getAdvice(),
                textAlign: TextAlign.left,
                style: const TextStyle(
                  color: Colors.white, 
                  fontSize: 15, 
                  fontStyle: FontStyle.italic,
                  height: 1.3, // Petit espacement pour rendre le multi-lignes plus joli
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}