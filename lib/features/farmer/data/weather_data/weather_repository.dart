import 'package:farmlynco/features/farmer/domain/weather_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherRepository {
  static const String _cacheKey = 'weather_insights';
    static const String _sprayKey = 'spraying_fertilizer';


  Future<WeatherInsights> fetchWeatherInsights(
      Map<String, String> sensorData) async {
    print("sensor data: $sensorData");
    final url =
        Uri.parse('https://newtonapi-f45t.onrender.com/overall-recommendation');
    final headers = {
      'accept': 'application/json',
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    try {
      final response = await http.post(url, headers: headers, body: sensorData);

      print(response.body);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final insights = WeatherInsights.fromJson(jsonResponse);
        await _cacheInsights(insights);
        return insights;
      } else {
        throw Exception('Failed to load weather insights');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<SprayInsights> fetchSprayAdvice(Map<String, String> sensorData) async {
    print("sensor data: $sensorData");
    final url = Uri.parse(
        'https://newtonapi-f45t.onrender.com/spraying-or-fertilizer-advice');
    final headers = {
      'accept': 'application/json',
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    try {
      final response = await http.post(url, headers: headers, body: sensorData);

      print(response.body);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final insights = SprayInsights.fromJson(jsonResponse);
        await _cacheSprayInsights(insights);
        return insights;
      } else {
        throw Exception('Failed to load weather insights');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> _cacheSprayInsights(SprayInsights insights) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sprayKey, json.encode(insights.toJson()));
  }

  Future<SprayInsights?> getCachedSprayInsights() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString(_sprayKey);
    if (cachedData != null) {
      return SprayInsights.fromJson(json.decode(cachedData));
    }
    return null;
  }

  Future<void> _cacheInsights(WeatherInsights insights) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cacheKey, json.encode(insights.toJson()));
  }

  Future<WeatherInsights?> getCachedInsights() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString(_cacheKey);
    if (cachedData != null) {
      return WeatherInsights.fromJson(json.decode(cachedData));
    }
    return null;
  }
}
