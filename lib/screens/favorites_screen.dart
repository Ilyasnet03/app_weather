import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../widgets/glass_card.dart'; // On utilise notre widget "Verre"

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeatherProvider>(context);

    return Container(
      // 1. Le même fond dégradé que l'accueil pour la cohérence
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFAEBaf8), 
            Color(0xFFC9D6FF),
            Color(0xFFE2EFFF),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent, // Important pour voir le dégradé
        
        appBar: AppBar(
          title: const Text('Villes favorites', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          // La flèche de retour en blanc
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        
        body: provider.favoriteCities.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.favorite_border, size: 80, color: Colors.white.withOpacity(0.5)),
                    const SizedBox(height: 20),
                    Text(
                      "Aucun favori pour l'instant",
                      style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 18),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: provider.favoriteCities.length,
                itemBuilder: (context, index) {
                  final city = provider.favoriteCities[index];
                  
                  // 2. Chaque ville est dans une GlassCard
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: GlassCard(
                      padding: const EdgeInsets.all(0), // On gère le padding dans le ListTile
                      borderRadius: 20,
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        title: Text(
                          city,
                          style: const TextStyle(
                            color: Colors.white, 
                            fontSize: 20, 
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.white),
                          onPressed: () {
                            provider.removeFavorite(city);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Ville supprimée"),
                                duration: Duration(seconds: 1),
                                backgroundColor: Color(0xFFAEBaf8),
                              )
                            );
                          },
                        ),
                        onTap: () {
                          // Relancer la recherche quand on clique sur un favori
                          provider.fetchWeather(city);
                          Navigator.pop(context); // Revient à l'écran d'accueil
                        },
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}