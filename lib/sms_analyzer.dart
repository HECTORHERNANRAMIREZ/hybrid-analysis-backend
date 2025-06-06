// Importaciones necesarias
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SmsAnalysisResult {
  final int count;
  final String? sampleMessage;
  final List<String> suspiciousMessages;

  SmsAnalysisResult(this.count, this.sampleMessage, this.suspiciousMessages);
}

Future<SmsAnalysisResult> analyzeSMS(
  BuildContext context,
  void Function(String?) onIntermediateMessage,
) async {
  final SmsQuery query = SmsQuery();

  // Breve espera y muestra mensaje inicial
  await Future.delayed(const Duration(milliseconds: 300));
  onIntermediateMessage("📩 Analizando SMS...");

  final status = await Permission.sms.request();
  if (!status.isGranted) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permiso de SMS denegado')),
      );
    }
    onIntermediateMessage(null);
    return SmsAnalysisResult(0, null, []);
  }

  final List<SmsMessage> messages = await query.getAllSms;

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

  final now = DateTime.now();
  final threshold = now.subtract(const Duration(days: 10));
  final recentMessages = messages.where((sms) {
    final date = sms.date;
    return date != null && date.isAfter(threshold);
  }).toList();

  int count = 0;
  String? sample;
  List<String> suspiciousList = [];

  for (var sms in recentMessages) {
    final content = sms.body ?? '';

    final response = await http.post(
      Uri.parse('https://web-production-0f002.up.railway.app/analyze'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'message': content}),
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['suspicious'] == true) {
        count++;
        sample ??= content;
        suspiciousList.add(content);
      }
    }
  }

  await Future.delayed(const Duration(milliseconds: 300));
  onIntermediateMessage(null);

  return SmsAnalysisResult(count, sample, suspiciousList);
}
