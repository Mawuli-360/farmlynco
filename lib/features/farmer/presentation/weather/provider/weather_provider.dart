import 'dart:async';
import 'dart:convert';

import 'package:farmlynco/features/farmer/data/weather_data/weather_repository.dart';
import 'package:farmlynco/features/farmer/domain/weather_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final weatherRepositoryProvider = Provider<WeatherRepository>((ref) {
  return WeatherRepository();
});

class WeatherInsightsNotifier
    extends StateNotifier<AsyncValue<CachedWeatherInsights>> {
  final WeatherRepository _repository;
  final Ref _ref;
  Timer? _retryTimer;
  Map<String, dynamic>? _latestSensorData;

  WeatherInsightsNotifier(this._repository, this._ref)
      : super(AsyncValue.data(
            CachedWeatherInsights(WeatherInsights.empty(), DateTime.now()))) {
    _loadCachedInsights();
    _listenToSensorData();
  }

  Future<void> _loadCachedInsights() async {
    final cachedData = await _loadCachedData();
    if (cachedData != null) {
      state = AsyncValue.data(cachedData);
    }
  }

  void _listenToSensorData() {
    _ref.listen(sensorDataProvider, (previous, next) {
      next.whenData((sensorData) {
        fetchInsights(sensorData);
      });
    });
  }

  Future<void> fetchInsights(Map<String, dynamic> sensorData) async {
    _latestSensorData = sensorData;
    _cancelRetryTimer();

    try {
      final insights = await _repository.fetchWeatherInsights(
          sensorData as Map<String, String>);

      final cachedInsights = CachedWeatherInsights(insights, DateTime.now());
      await _updateCache(cachedInsights);
      state = AsyncValue.data(cachedInsights);
    } catch (e) {
      final cachedData = await _loadCachedData();
      if (cachedData != null) {
        state = AsyncValue.data(cachedData.copyWith(isOutdated: true));
      } else {
        state = AsyncValue.data(CachedWeatherInsights(
            WeatherInsights.empty(), DateTime.now(),
            isOutdated: true));
      }
      _scheduleRetry();
    }
  }

  void _scheduleRetry() {
    _retryTimer = Timer(const Duration(seconds: 30), () {
      if (_latestSensorData != null) {
        fetchInsights(_latestSensorData!);
      }
    });
  }

  void _cancelRetryTimer() {
    _retryTimer?.cancel();
    _retryTimer = null;
  }

  Future<void> _updateCache(CachedWeatherInsights cachedInsights) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'cachedWeatherInsights', json.encode(cachedInsights.toJson()));
  }

  Future<CachedWeatherInsights?> _loadCachedData() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString('cachedWeatherInsights');
    if (cachedData != null) {
      final decodedData = json.decode(cachedData);
      return CachedWeatherInsights.fromJson(decodedData);
    }
    return null;
  }

  @override
  void dispose() {
    _cancelRetryTimer();
    super.dispose();
  }
}

class SprayInsightsNotifier
    extends StateNotifier<AsyncValue<CachedSprayInsights>> {
  final WeatherRepository _repository;
  final Ref _ref;
  Timer? _retryTimer;
  Map<String, dynamic>? _latestSensorData;

  SprayInsightsNotifier(this._repository, this._ref)
      : super(AsyncValue.data(
            CachedSprayInsights(SprayInsights.empty(), DateTime.now()))) {
    _loadCachedInsights();
    _listenToSensorData();
  }

  Future<void> _loadCachedInsights() async {
    final cachedData = await _loadCachedData();
    if (cachedData != null) {
      state = AsyncValue.data(cachedData);
    }
  }

  void _listenToSensorData() {
    _ref.listen(sensorDataProvider, (previous, next) {
      next.whenData((sensorData) {
        fetchSprayAdvice(sensorData);
      });
    });
  }

  Future<void> fetchSprayAdvice(Map<String, dynamic> sensorData) async {
    _latestSensorData = sensorData;
    _cancelRetryTimer();

    try {
      final insights =
          await _repository.fetchSprayAdvice(sensorData as Map<String, String>);

      final cachedInsights = CachedSprayInsights(insights, DateTime.now());
      await _updateCache(cachedInsights);
      state = AsyncValue.data(cachedInsights);
    } catch (e) {
      final cachedData = await _loadCachedData();
      if (cachedData != null) {
        state = AsyncValue.data(cachedData.copyWith(isOutdated: true));
      } else {
        state = AsyncValue.data(CachedSprayInsights(
            SprayInsights.empty(), DateTime.now(),
            isOutdated: true));
      }
      _scheduleRetry();
    }
  }

  void _scheduleRetry() {
    _retryTimer = Timer(const Duration(seconds: 30), () {
      if (_latestSensorData != null) {
        fetchSprayAdvice(_latestSensorData!);
      }
    });
  }

  void _cancelRetryTimer() {
    _retryTimer?.cancel();
    _retryTimer = null;
  }

  Future<void> _updateCache(CachedSprayInsights cachedInsights) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'cachedSprayInsights', json.encode(cachedInsights.toJson()));
  }

  Future<CachedSprayInsights?> _loadCachedData() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString('cachedSprayInsights');
    if (cachedData != null) {
      final decodedData = json.decode(cachedData);
      return CachedSprayInsights.fromJson(decodedData);
    }
    return null;
  }

  @override
  void dispose() {
    _cancelRetryTimer();
    super.dispose();
  }
}


class CachedSprayInsights {
  final SprayInsights insights;
  final DateTime timestamp;
  final bool isOutdated;

  CachedSprayInsights(this.insights, this.timestamp, {this.isOutdated = false});

  CachedSprayInsights copyWith({bool? isOutdated}) {
    return CachedSprayInsights(insights, timestamp,
        isOutdated: isOutdated ?? this.isOutdated);
  }

  Map<String, dynamic> toJson() => {
        'insights': insights.toJson(),
        'timestamp': timestamp.toIso8601String(),
        'isOutdated': isOutdated,
      };

  factory CachedSprayInsights.fromJson(Map<String, dynamic> json) {
    return CachedSprayInsights(
      SprayInsights.fromJson(json['insights']),
      DateTime.parse(json['timestamp']),
      isOutdated: json['isOutdated'] ?? false,
    );
  }
}

class CachedWeatherInsights {
  final WeatherInsights insights;
  final DateTime timestamp;
  final bool isOutdated;

  CachedWeatherInsights(this.insights, this.timestamp, {this.isOutdated = false});

  CachedWeatherInsights copyWith({bool? isOutdated}) {
    return CachedWeatherInsights(insights, timestamp,
        isOutdated: isOutdated ?? this.isOutdated);
  }

  Map<String, dynamic> toJson() => {
        'insights': insights.toJson(),
        'timestamp': timestamp.toIso8601String(),
        'isOutdated': isOutdated,
      };

  factory CachedWeatherInsights.fromJson(Map<String, dynamic> json) {
    return CachedWeatherInsights(
      WeatherInsights.fromJson(json['insights']),
      DateTime.parse(json['timestamp']),
      isOutdated: json['isOutdated'] ?? false,
    );
  }
}


final weatherInsightsProvider =
    StateNotifierProvider<WeatherInsightsNotifier, AsyncValue<CachedWeatherInsights>>(
        (ref) {
  final repository = ref.watch(weatherRepositoryProvider);
  return WeatherInsightsNotifier(repository, ref);
});

final sprayInsightsProvider = StateNotifierProvider<SprayInsightsNotifier,
    AsyncValue<CachedSprayInsights>>((ref) {
  return SprayInsightsNotifier(ref.watch(weatherRepositoryProvider), ref);
});

final sensorDataStreamProvider = StreamProvider<Map<String, String>>((ref) {
  final databaseReference = FirebaseDatabase.instance.ref();

  return databaseReference.onValue.map((event) {
    final data = event.snapshot.value as Map<dynamic, dynamic>?;
    if (data != null) {
      return {
        'temperature': data['temp']?.toString() ?? '',
        'humidity': data['humidity']?.toString() ?? '',
        'windspeed': data['wind']?.toString() ?? '',
        'pressure': data['pressure']?.toString() ?? '',
      };
    } else {
      throw Exception('No sensor data available');
    }
  });
});

final sensorDataProvider = Provider<AsyncValue<Map<String, String>>>((ref) {
  return ref.watch(sensorDataStreamProvider);
});
