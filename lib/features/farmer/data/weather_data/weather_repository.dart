import 'dart:async';

import 'package:farmlynco/features/farmer/domain/weather_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherRepository {
  static const String _cacheKey = 'weather_insights';
  static const String _sprayKey = 'spraying_fertilizer';

  Future<WeatherInsights> fetchWeatherInsights(
    Map<String, String> sensorData, {
    Duration timeout = const Duration(seconds: 15),
    CancelToken? cancelToken,
  }) async {
    final url =
        Uri.parse('https://newtonapi-f45t.onrender.com/overall-recommendation');
    final headers = {
      'accept': 'application/json',
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    final client = http.Client();
    final completer = Completer<WeatherInsights>();
    Timer? timeoutTimer;

    try {
      timeoutTimer = Timer(timeout, () {
        if (!completer.isCompleted) {
          client.close();
          completer.completeError(TimeoutException('Request timed out'));
        }
      });

      cancelToken?.whenCancel.then((_) {
        if (!completer.isCompleted) {
          client.close();
          completer.completeError(CancelledException());
        }
      });

      final response = await client
          .post(
            url,
            headers: headers,
            body: sensorData,
          )
          .timeout(timeout);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final insights = WeatherInsights.fromJson(jsonResponse);
        await _cacheInsights(insights);
        completer.complete(insights);
      } else {
        throw Exception('Failed to load weather insights');
      }
    } on TimeoutException {
      throw Exception('Request timed out. Please try again.');
    } catch (e) {
      throw Exception('Error: $e');
    } finally {
      timeoutTimer?.cancel();
      client.close();
    }

    return completer.future;
  }

  Future<SprayInsights> fetchSprayAdvice(
    Map<String, String> sensorData, {
    Duration timeout = const Duration(seconds: 15),
    CancelToken? cancelToken,
  }) async {
    final url = Uri.parse(
        'https://newtonapi-f45t.onrender.com/spraying-or-fertilizer-advice');
    final headers = {
      'accept': 'application/json',
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    final client = http.Client();
    final completer = Completer<SprayInsights>();
    Timer? timeoutTimer;

    try {
      timeoutTimer = Timer(timeout, () {
        if (!completer.isCompleted) {
          client.close();
          completer.completeError(TimeoutException('Request timed out'));
        }
      });

      cancelToken?.whenCancel.then((_) {
        if (!completer.isCompleted) {
          client.close();
          completer.completeError(CancelledException());
        }
      });

      final response = await client
          .post(
            url,
            headers: headers,
            body: sensorData,
          )
          .timeout(timeout);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final insights = SprayInsights.fromJson(jsonResponse);
        await _cacheSprayInsights(insights);
        completer.complete(insights);
      } else {
        throw Exception('Failed to load spray advice');
      }
    } on TimeoutException {
      throw Exception('Request timed out. Please try again.');
    } catch (e) {
      throw Exception('Error: $e');
    } finally {
      timeoutTimer?.cancel();
      client.close();
    }

    return completer.future;
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

class CancelToken {
  final _completer = Completer<void>();
  Future<void> get whenCancel => _completer.future;
  void cancel() {
    if (!_completer.isCompleted) _completer.complete();
  }
}

class CancelledException implements Exception {
  final String message = 'Request was cancelled';
  @override
  String toString() => message;
}
