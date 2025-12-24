class Weather {
  final String cityName;
  final double temperature;
  final String description;
  final String icon;
  final String? time;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.icon,
    this.time,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    String? timeString;
    // Si c'est une prévision, on récupère l'heure
    if (json.containsKey('dt_txt')) {
      timeString = json['dt_txt'].toString().split(' ')[1].substring(0, 5);
    }

    return Weather(
      cityName: json['name'] ?? '',
      temperature: json['main']['temp'].toDouble(),
      description: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'],
      time: timeString,
    );
  }

  // La fonction pour le conseil (Parapluie/Manteau)
 String getAdvice() {
    String desc = description.toLowerCase();
    List<String> listConseils = [];

    // --- 1. Analyse des Conditions Météo (Précipitation & Ciel) ---
    if (desc.contains('orage')) {
      listConseils.add("⚠️ Orage : Restez à l'abri, débranchez les appareils.");
    } else if (desc.contains('neige') || desc.contains('verglas')) {
      listConseils.add("❄️ Attention routes glissantes. Bottes impératives !");
    } else if (desc.contains('pluie') || desc.contains('averse')) {
      listConseils.add("☔ Prenez un parapluie et une veste imperméable.");
    } else if (desc.contains('bruine')) {
      listConseils.add("💧 Une pluie fine... un k-way suffira.");
    } else if (desc.contains('brouillard') || desc.contains('brume')) {
      listConseils.add("🌫️ Visibilité réduite : Prudence sur la route.");
    } else if (desc.contains('clair') || desc.contains('dégagé') || desc.contains('soleil')) {
      listConseils.add("😎 Ciel bleu : Sortez les lunettes de soleil !");
    } else if (desc.contains('nuage') || desc.contains('couvert')) {
      listConseils.add("☁️ Temps gris, mais pas de pluie prévue.");
    }

    // --- 2. Analyse de la Température (Ressenti humain) ---
    if (temperature <= 0) {
      listConseils.add("🥶 Il gèle ! Bonnet, écharpe et gants obligatoires.");
    } else if (temperature > 0 && temperature <= 10) {
      listConseils.add("🧥 Il fait froid. Mettez un bon manteau.");
    } else if (temperature > 10 && temperature <= 18) {
      listConseils.add("sw️ Un peu frais. Un pull ou une veste légère est conseillé.");
    } else if (temperature > 18 && temperature <= 25) {
      listConseils.add("👕 Température idéale ! T-shirt ou chemise.");
    } else if (temperature > 25 && temperature <= 32) {
      listConseils.add("🥤 Il fait chaud. Pensez à vous hydrater.");
    } else if (temperature > 32) {
      listConseils.add("🔥 Canicule ! Restez au frais et évitez le sport.");
    }

    // --- 3. Le "Bonus Motard" (Logique conditionnelle combinée) ---
    // Si pas de pluie/neige/orage ET température agréable (>12°C)
    bool mauvaisTemps = desc.contains('pluie') || desc.contains('neige') || desc.contains('orage') || desc.contains('verglas');
    if (!mauvaisTemps && temperature > 12 && temperature < 30) {
      listConseils.add("🏍️ Conditions parfaites pour une balade en moto !");
    }

    // On joint tous les conseils avec un retour à la ligne
    return listConseils.join("\n");
  }
}