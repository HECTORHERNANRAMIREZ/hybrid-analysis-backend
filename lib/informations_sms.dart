// Importaciones necesarias
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Para abrir la app de SMS

// Lista global para almacenar los mensajes sospechosos
List<String> _storedMessages = [];

// Función para guardar los mensajes que se mostrarán en el modal
void saveMessages(List<String> messages) {
  _storedMessages = messages;
}

/// Función que muestra un modal con los mensajes sospechosos guardados
void showInformationSMSDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true, // Permite cerrar el modal tocando fuera
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor:
            Colors.black.withOpacity(0.95), // Fondo oscuro semitransparente
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Bordes redondeados
        ),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          height: MediaQuery.of(context).size.height * 0.6,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: const Color(0xFF0B0B0B), // Color del contenido del modal
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              /// Lista de mensajes sospechosos o mensaje por defecto
              Expanded(
                child: _storedMessages.isEmpty
                    ? const Center(
                        child: Text(
                          'No hay mensajes sospechosos disponibles.',
                          style: TextStyle(color: Colors.white70),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _storedMessages.length,
                        itemBuilder: (context, index) {
                          return Card(
                            color: Colors.grey[900],
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Muestra el contenido del mensaje
                                  Expanded(
                                    child: Text(
                                      _storedMessages[index],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),

                                  // Botón "Bloquear" (abre la app de SMS)
                                  TextButton(
                                    onPressed: () async {
                                      final Uri uri = Uri(scheme: 'sms');
                                      if (await canLaunchUrl(uri)) {
                                        await launchUrl(uri,
                                            mode:
                                                LaunchMode.externalApplication);
                                      } else {
                                        // Si no puede abrir la app de SMS, muestra un mensaje de error
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'No se pudo abrir la app de SMS.'),
                                            ),
                                          );
                                        }
                                      }
                                    },
                                    style: TextButton.styleFrom(
                                      backgroundColor: const Color(0xFF0A2D62),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                    ),
                                    child: const Text(
                                      'Bloquear',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),

              const SizedBox(height: 10),

              /// Botón para cerrar el modal
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0A2D62),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    'Cerrar',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
