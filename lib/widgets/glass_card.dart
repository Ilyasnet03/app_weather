import 'dart:ui'; // Nécessaire pour le flou (ImageFilter)
import 'package:flutter/material.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius = 30.0, // Coins très arrondis par défaut
  });

  @override
  Widget build(BuildContext context) {
    // ClipRRect coupe le flou qui dépasserait des bords arrondis
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        // L'effet de flou en arrière-plan
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          padding: padding ?? const EdgeInsets.all(20),
          decoration: BoxDecoration(
            // Couleur blanche très transparente
            color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.2),
            borderRadius: BorderRadius.circular(borderRadius),
            // Une bordure fine et subtile pour définir la carte
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1.5,
            ),
            // Légère ombre pour la profondeur
            boxShadow: [
               BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                spreadRadius: -5,
                offset: const Offset(0, 10),
              ),
            ]
          ),
          child: child,
        ),
      ),
    );
  }
}