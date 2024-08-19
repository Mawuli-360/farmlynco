import 'dart:math';

import 'package:farmlynco/features/farmer/data/weather_data/weather_repository.dart';
import 'package:farmlynco/features/farmer/domain/weather_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final weatherRepositoryProvider = Provider<WeatherRepository>((ref) {
  return WeatherRepository();
});

class WeatherInsightsNotifier
    extends StateNotifier<AsyncValue<WeatherInsights>> {
  final WeatherRepository _repository;

  WeatherInsightsNotifier(this._repository)
      : super(const AsyncValue.loading()) {
    _loadCachedInsights();
  }

  Future<void> _loadCachedInsights() async {
    final cachedInsights = await _repository.getCachedInsights();
    if (cachedInsights != null) {
      state = AsyncValue.data(cachedInsights);
    }
  }

  Future<void> fetchInsights(Map<String, String> sensorData) async {
    state = const AsyncValue.loading();

    try {
      final insights = await _repository.fetchWeatherInsights(
        sensorData,
      );
      state = AsyncValue.data(insights);
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }
}

class SprayInsightsNotifier extends StateNotifier<AsyncValue<SprayInsights>> {
  final WeatherRepository _repository;

  SprayInsightsNotifier(this._repository) : super(const AsyncValue.loading()) {
    _loadCachedInsights();
  }

  Future<void> _loadCachedInsights() async {
    final cachedInsights = await _repository.getCachedSprayInsights();
    if (cachedInsights != null) {
      state = AsyncValue.data(cachedInsights);
    }
  }

  Future<void> fetchSprayAdvice(Map<String, String> sensorData) async {
    state = const AsyncValue.loading();

    try {
      final insights = await _repository.fetchSprayAdvice(
        sensorData,
        timeout: const Duration(seconds: 60),
      );
      state = AsyncValue.data(insights);
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }
}

final weatherInsightsProvider =
    StateNotifierProvider<WeatherInsightsNotifier, AsyncValue<WeatherInsights>>(
        (ref) {
  final repository = ref.watch(weatherRepositoryProvider);
  return WeatherInsightsNotifier(repository);
});

final sprayInsightsProvider =
    StateNotifierProvider<SprayInsightsNotifier, AsyncValue<SprayInsights>>(
        (ref) {
  final repository = ref.watch(weatherRepositoryProvider);
  return SprayInsightsNotifier(repository);
});

final sensorDataStreamProvider = StreamProvider<Map<String, String>>((ref) {
  // Replace this with your actual sensor data stream
  return Stream.periodic(const Duration(minutes: 2), (_) {
    return {
      'temperature': '${14.0 + Random().nextDouble() * 2}',
      'humidity': '${13.0 + Random().nextDouble() * 2}',
      'windspeed': '${14.0 + Random().nextDouble() * 2}',
      'pressure': '${60.0 + Random().nextDouble() * 2}',
    };
  });
});
