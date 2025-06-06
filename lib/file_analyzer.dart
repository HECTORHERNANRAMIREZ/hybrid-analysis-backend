import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<int> analyzeDownloadedFiles() async {
  final status = await Permission.storage.request();
  if (!status.isGranted) return 0;

  // Accede a la carpeta de descargas
  final downloadDir = Directory('/storage/emulated/0/Download');
  if (!downloadDir.existsSync()) return 0;

  final files = downloadDir
      .listSync()
      .whereType<File>()
      .where((file) =>
          file.path.endsWith('.pdf') ||
          file.path.endsWith('.docx') ||
          file.path.endsWith('.apk'))
      .toList();

  int detected = 0;
  for (final file in files) {
    final uri = Uri.parse(
        'https://hybrid-analysis-backend-production.up.railway.app/escanear');
    final request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath('file', file.path));
    final response = await request.send();

    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      final json = jsonDecode(respStr);
      final score = json['threat_score'] ?? 0;
      if (score >= 1) detected++;
    }
  }

  return detected;
}
