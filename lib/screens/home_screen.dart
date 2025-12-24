import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../widgets/weather_card.dart';
import '../widgets/advice_card.dart';
import '../widgets/forecast_item.dart';
import '../widgets/temp_chart.dart'; // Import nécessaire pour le graphique
import 'favorites_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeatherProvider>(context);

    return Container(
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
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('NACHRA jAWYA', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.favorite, color: Colors.white),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FavoritesScreen())),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // --- BARRE DE RECHERCHE ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: TextField(
                  controller: _controller,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Rechercher une ville...',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.25),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search, color: Colors.white),
                      onPressed: () {
                          if (_controller.text.isNotEmpty) {
                            FocusScope.of(context).unfocus();
                            provider.fetchWeather(_controller.text);
                          }
                       },
                    ),
                  ),
                  onSubmitted: (val) {
                    if (val.isNotEmpty) provider.fetchWeather(val);
                  },
                ),
              ),

              // --- ERREURS ---
              if (provider.errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: Colors.redAccent.withOpacity(0.8), borderRadius: BorderRadius.circular(15)),
                  child: Text(provider.errorMessage!, style: const TextStyle(color: Colors.white), textAlign: TextAlign.center),
                ),
              
              if (provider.isLoading)
                const Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator(color: Colors.white)),

              // --- AFFICHAGE ---
              if (provider.weather != null) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: WeatherCard(weather: provider.weather!),
                ),

                AdviceCard(weather: provider.weather!),

                const SizedBox(height: 20),

                // TITRE GRAPHIQUE
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Évolution 24h", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                ),

                // LE GRAPHIQUE
                if (provider.forecast.isNotEmpty)
                  TempChart(forecast: provider.forecast),

                const SizedBox(height: 20),

                // TITRE DÉTAILS
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Détails", style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 20, fontWeight: FontWeight.w600)),
                  ),
                ),

                // LA LISTE (C'est ici que l'erreur est corrigée)
                SizedBox(
                  height: 150,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    itemCount: provider.forecast.length, // C'était manquant
                    itemBuilder: (context, index) {       // C'était manquant
                      return ForecastItem(weather: provider.forecast[index]);
                    },
                  ),
                ),

                const SizedBox(height: 30),
                
                // BOUTON FAVORIS
                ElevatedButton.icon(
                  onPressed: () {
                    provider.addFavorite(provider.weather!.cityName);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ajouté aux favoris !')));
                  },
                  icon: const Icon(Icons.favorite_border, color: Color(0xFFAEBaf8)),
                  label: const Text('Ajouter aux favoris', style: TextStyle(color: Color(0xFFAEBaf8), fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15)),
                ),
                const SizedBox(height: 40),
              ]
            ],
          ),
        ),
      ),
    );
  }
}