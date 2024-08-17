class WeatherInsights {
  final String insights;
  final DateTime timestamp;

  WeatherInsights({required this.insights, required this.timestamp});

  factory WeatherInsights.fromJson(Map<String, dynamic> json) {
    return WeatherInsights(
      insights: json['insights'],
      timestamp: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'insights': insights,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

class SprayInsights {
  final String insights;
  final DateTime timestamp;

  SprayInsights({required this.insights, required this.timestamp});

  factory SprayInsights.fromJson(Map<String, dynamic> json) {
    return SprayInsights(
      insights: json['insights'],
      timestamp: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'insights': insights,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}