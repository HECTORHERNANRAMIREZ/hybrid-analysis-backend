// Importaciones necesarias
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart'; // Para gestionar permisos
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart'; // Para acceder a los SMS
import 'dart:convert'; // Para codificar datos a JSON
import 'package:http/http.dart' as http; // Para hacer solicitudes HTTP

/// Modelo de resultado del análisis de SMS
/// Incluye:
/// - cantidad de mensajes sospechosos encontrados,
/// - un mensaje de ejemplo,
/// - y la lista completa de mensajes sospechosos.
class SmsAnalysisResult {
  final int count;
  final String? sampleMessage;
  final List<String> suspiciousMessages;

  SmsAnalysisResult(this.count, this.sampleMessage, this.suspiciousMessages);
}

/// Función principal para analizar los SMS recibidos en los últimos 10 días
/// - Solicita permiso
/// - Lee los SMS
/// - Filtra los recientes
/// - Los envía al backend para analizar
/// - Devuelve los resultados
Future<SmsAnalysisResult> analyzeSMS(
  BuildContext context,
  void Function(String?)
      onIntermediateMessage, // Callback para mostrar mensajes mientras analiza
) async {
  final SmsQuery query = SmsQuery();

  // Muestra mensaje de análisis en progreso
  onIntermediateMessage("🔍 Analizando un momento...");

  // Solicita permiso de acceso a SMS
  var status = await Permission.sms.request();
  if (!status.isGranted) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permiso de SMS denegado')),
      );
    }
    onIntermediateMessage(null);
    return SmsAnalysisResult(0, null, []);
  }

  // Obtiene todos los SMS del dispositivo
  final List<SmsMessage> messages = await query.getAllSms;

  // Si no hay mensajes, muestra un cuadro de diálogo
  if (messages.isEmpty) {
    if (context.mounted) {
      showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          title: Text('Sin SMS'),
          content: Text('No se encontraron mensajes en la bandeja de entrada.'),
        ),
      );
    }
    onIntermediateMessage(null);
    return SmsAnalysisResult(0, null, []);
  }

  // 🔽 Filtra los mensajes por fecha: últimos 10 días
  final now = DateTime.now();
  final threshold = now.subtract(const Duration(days: 10));
  final recentMessages = messages.where((sms) {
    final date = sms.date;
    return date != null && date.isAfter(threshold);
  }).toList();

  int count = 0; // Contador de mensajes sospechosos
  String? sample; // Mensaje de ejemplo
  List<String> suspiciousList = []; // Lista completa de mensajes sospechosos

  // Analiza cada mensaje reciente usando el backend
  for (var sms in recentMessages) {
    final content = sms.body ?? '';

    final response = await http.post(
      Uri.parse(
          'https://web-production-0f002.up.railway.app/analyze'), // Backend en Railway
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'message': content}), // Envía mensaje como JSON
    );

    // Si el backend responde correctamente...
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['suspicious'] == true) {
        count++;
        sample ??= content; // Guarda el primer mensaje como ejemplo
        suspiciousList.add(content); // Agrega a la lista de sospechosos
      }
    }
  }

  // Limpia el mensaje de análisis en pantalla
  onIntermediateMessage(null);

  // Devuelve el resultado completo
  return SmsAnalysisResult(count, sample, suspiciousList);
}
