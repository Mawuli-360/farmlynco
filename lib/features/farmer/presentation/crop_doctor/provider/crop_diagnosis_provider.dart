import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Diagnosis {
  final String id;
  final String imagePath;
  final String diagnosis;
  final DateTime timestamp;

  Diagnosis({
    required this.id,
    required this.imagePath,
    required this.diagnosis,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'imagePath': imagePath,
        'diagnosis': diagnosis,
        'timestamp': timestamp.toIso8601String(),
      };

  factory Diagnosis.fromJson(Map<String, dynamic> json) => Diagnosis(
        id: json['id'],
        imagePath: json['imagePath'],
        diagnosis: json['diagnosis'],
        timestamp: DateTime.parse(json['timestamp']),
      );
}

class CropDiagnosisNotifier extends StateNotifier<List<Diagnosis>> {
  CropDiagnosisNotifier() : super([]) {
    _loadDiagnoses();
  }

  static const String _diagnosesKey = 'diagnoses';
    Completer<void>? _cancelCompleter;


  Future<void> _loadDiagnoses() async {
    final prefs = await SharedPreferences.getInstance();
    final diagnosesJson = prefs.getString(_diagnosesKey);
    if (diagnosesJson != null) {
      final diagnosesList = jsonDecode(diagnosesJson) as List;
      state = diagnosesList.map((json) => Diagnosis.fromJson(json)).toList();
    }
  }

  Future<String> _uploadImage(String imagePath, Completer<void> cancelCompleter) async {
  var url = Uri.parse('https://newtonapi-f45t.onrender.com/analyze-rice-leaf');

  try {
    var request = http.MultipartRequest('POST', url);
    request.files.add(await http.MultipartFile.fromPath('file', imagePath));

    var futureResponse = request.send().timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        throw TimeoutException("Request timeout please try again later");
      },
    );

    var response = await Future.any([
      futureResponse,
      cancelCompleter.future.then((_) => throw Exception('Request cancelled'))
    ]);

    var responseBody = await http.Response.fromStream(response);

    if (responseBody.statusCode == 200) {
      return json.decode(responseBody.body)['suggestions'];
    } else {
      return 'Failed to get diagnosis';
    }
  } on TimeoutException catch (_) {
    return "Request timeout please try again later";
  } on SocketException catch (_) {
    return "Network connection is bad";
  } on Exception catch (e) {
    if (e.toString() == 'Exception: Request cancelled') {
      return 'Request was cancelled';
    }
    return 'Error: $e';
  }
}




    Future<String> uploadImage(String imagePath) async {
    _cancelCompleter = Completer<void>();
    
    try {
      String diagnosis = await _uploadImage(imagePath, _cancelCompleter!);
      return diagnosis;
    } finally {
      _cancelCompleter = null;
    }
  }

  void cancelOngoingRequest() {
    if (_cancelCompleter != null && !_cancelCompleter!.isCompleted) {
      _cancelCompleter!.complete();
    }
  }

  Future<void> _saveDiagnoses() async {
    final prefs = await SharedPreferences.getInstance();
    final diagnosesJson = jsonEncode(state.map((d) => d.toJson()).toList());
    await prefs.setString(_diagnosesKey, diagnosesJson);
  }

  Future<void> addDiagnosis(String imagePath, String diagnosis) async {
    final newDiagnosis = Diagnosis(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      imagePath: imagePath,
      diagnosis: diagnosis,
      timestamp: DateTime.now(),
    );
    state = [newDiagnosis, ...state];
    await _saveDiagnoses();
  }

  Future<void> deleteDiagnosis(String id) async {
    state = state.where((d) => d.id != id).toList();
    await _saveDiagnoses();
  }

  Future<void> clearDiagnoses() async {
    state = [];
    await _saveDiagnoses();
  }

  Diagnosis? getLastDiagnosis() {
    return state.isNotEmpty ? state.first : null;
  }
}

final cropDiagnosisProvider =
    StateNotifierProvider<CropDiagnosisNotifier, List<Diagnosis>>((ref) {
  return CropDiagnosisNotifier();
});
