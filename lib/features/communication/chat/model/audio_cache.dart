import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class AudioCache {
  static Future<String> getCachedAudioPath(String url) async {
    final directory = await getTemporaryDirectory();
    final fileName = url.split('/').last;
    final file = File('${directory.path}/$fileName');

    if (await file.exists()) {
      return file.path;
    } else {
      final response = await http.get(Uri.parse(url));
      await file.writeAsBytes(response.bodyBytes);
      return file.path;
    }
  }
}