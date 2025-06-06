import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart';

Future<int> analizarArchivosEnDescargas() async {
  // Solicitar permisos
  final permiso = await Permission.storage.request();
  if (!permiso.isGranted) return 0;

  // Obtener la carpeta de descargas
  final Directory? downloadsDir = Directory('/storage/emulated/0/Download');
  if (downloadsDir == null || !downloadsDir.existsSync()) return 0;

  final archivos = downloadsDir.listSync();
  int sospechosos = 0;

  for (final archivo in archivos) {
    if (archivo is File) {
      final uri = Uri.parse(
          'https://hybrid-analysis-backend-production.up.railway.app/escanear');
      final request = http.MultipartRequest('POST', uri)
        ..files.add(await http.MultipartFile.fromPath('file', archivo.path));

      try {
        final response = await request.send();
        if (response.statusCode == 200) {
          final cuerpo = await response.stream.bytesToString();
          if (cuerpo.contains('"threat_score":') &&
              !cuerpo.contains('"threat_score":0')) {
            sospechosos++;
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error al enviar archivo: $e');
        }
      }
    }
  }

  return sospechosos;
}
