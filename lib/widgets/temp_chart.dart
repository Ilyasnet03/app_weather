import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/weather.dart';
import 'glass_card.dart';

class TempChart extends StatelessWidget {
  final List<Weather> forecast;

  const TempChart({super.key, required this.forecast});

  @override
  Widget build(BuildContext context) {
    if (forecast.isEmpty) return const SizedBox();
    
    // On prend les 24 prochaines heures (8 points de 3h)
    final List<Weather> dataPoints = forecast.take(8).toList();

    double minTemp = dataPoints.map((e) => e.temperature).reduce((a, b) => a < b ? a : b);
    double maxTemp = dataPoints.map((e) => e.temperature).reduce((a, b) => a > b ? a : b);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      height: 200, 
      child: GlassCard(
        padding: const EdgeInsets.fromLTRB(10, 25, 10, 10),
        child: LineChart(
          LineChartData(
            gridData: const FlGridData(show: false),
            titlesData: FlTitlesData(
              leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  getTitlesWidget: (value, meta) {
                    int index = value.toInt();
                    if (index >= 0 && index < dataPoints.length && index % 2 == 0) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          dataPoints[index].time ?? '',
                          style: const TextStyle(color: Colors.white70, fontSize: 10),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
            minX: 0,
            maxX: (dataPoints.length - 1).toDouble(),
            minY: minTemp - 3,
            maxY: maxTemp + 3,
            lineBarsData: [
              LineChartBarData(
                spots: dataPoints.asMap().entries.map((e) {
                  return FlSpot(e.key.toDouble(), e.value.temperature);
                }).toList(),
                isCurved: true,
                color: Colors.amber,
                barWidth: 4,
                isStrokeCapRound: true,
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: [Colors.amber.withOpacity(0.3), Colors.transparent],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                dotData: FlDotData(show: false),
              ),
            ],
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                getTooltipColor: (touchedSpot) => Colors.black87,
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map((spot) {
                    return LineTooltipItem(
                      '${spot.y.round()}°C',
                      const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    );
                  }).toList();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}