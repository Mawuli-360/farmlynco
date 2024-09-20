// class WeatherInsights {
//   final String insights;
//   final DateTime timestamp;

//   WeatherInsights({required this.insights, required this.timestamp});

//   factory WeatherInsights.fromJson(Map<String, dynamic> json) {
//     return WeatherInsights(
//       insights: json['insights'],
//       timestamp: DateTime.now(),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'insights': insights,
//       'timestamp': timestamp.toIso8601String(),
//     };
//   }
// }

class WeatherInsights {
  final String insights;

  WeatherInsights(this.insights);

  factory WeatherInsights.empty() => WeatherInsights('No insights available');

  Map<String, dynamic> toJson() => {'insights': insights};

  factory WeatherInsights.fromJson(Map<String, dynamic> json) {
    return WeatherInsights(json['insights'] ?? 'No insights available');
  }
}

class SprayInsights {
  final String insights;

  SprayInsights(this.insights);

  factory SprayInsights.empty() => SprayInsights('No insights available');

  Map<String, dynamic> toJson() => {'insights': insights};

  factory SprayInsights.fromJson(Map<String, dynamic> json) {
    return SprayInsights(json['insights'] ?? 'No insights available');
  }
}

