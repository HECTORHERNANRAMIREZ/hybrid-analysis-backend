// Importaciones necesarias
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:video_player/video_player.dart';

// Importa widgets reutilizables y decoraciones organizadas en archivos separados
import 'home_widgets.dart' as widgets;
import 'home_decorations.dart' as decorations;

// Función para analizar SMS y mostrar advertencias
import 'sms_analyzer.dart';

// Modal informativo personalizado para mostrar mensajes sospechosos
import 'informations_sms.dart'; // ✅ Importa la función del modal

// Widget con estado que representa el layout principal de la pantalla de inicio
class HomePageLayout extends StatefulWidget {
  final VideoPlayerController videoController; // Video de fondo
  final User user; // Usuario autenticado

  const HomePageLayout({
    super.key,
    required this.videoController,
    required this.user,
  });

  @override
  HomePageLayoutState createState() => HomePageLayoutState();
}

class HomePageLayoutState extends State<HomePageLayout> {
  int suspiciousCount = 0; // Contador de SMS sospechosos detectados
  String? sampleMessage; // Muestra uno de los mensajes detectados
  String? analyzingMessage; // Mensaje temporal durante el análisis
  List<String> suspiciousMessages =
      []; // ✅ Lista completa de mensajes sospechosos

  // Función que inicia el análisis de los SMS
  void _startSmsAnalysis() async {
    setState(() {
      analyzingMessage = "🔍 Analizando un momento...";
    });

    // Llama a la función de análisis y actualiza resultados en tiempo real
    final result = await analyzeSMS(
      context,
      (intermediateText) {
        setState(() {
          analyzingMessage = intermediateText;
        });
      },
    );

    // Al finalizar, guarda los resultados
    setState(() {
      suspiciousCount = result.count;
      sampleMessage = result.sampleMessage;
      suspiciousMessages = result.suspiciousMessages;
      analyzingMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Calcula posición del logo central
    final double logoTop =
        widgets.circleTop + (widgets.circleArea - decorations.logoHeight) / 2;
    final double logoLeft = (screenWidth - decorations.logoWidth) / 2;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // ✅ Video de fondo si está inicializado
            if (widget.videoController.value.isInitialized)
              widgets.buildBackgroundVideo(widget.videoController),

            // ✅ Círculo borroso decorativo de fondo
            widgets.buildBlurredCircle(screenWidth),

            // ✅ Botón "Analizar" que inicia el análisis de SMS
            widgets.buildAnalyzeButton(screenWidth, _startSmsAnalysis),

            // ✅ Botón "Solucionar" que muestra opciones según los SMS sospechosos
            widgets.buildSolveButton(screenWidth, suspiciousMessages, context),

            // ✅ Indicador visual con número de mensajes sospechosos
            Positioned(
              top: 300,
              left: 70,
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Container(
                    width: screenWidth - 120,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color.fromARGB(85, 0, 0, 0),
                          Color.fromARGB(103, 27, 38, 59),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      'Mensajes de SMS: $suspiciousCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Open',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ✅ Icono de SMS a la izquierda del indicador
            Positioned(
              top: 300,
              left: 20,
              child: Image.network(
                'https://firebasestorage.googleapis.com/v0/b/app12-5128a.firebasestorage.app/o/uploads%2Fsms.png?alt=media&token=c085e136-1f43-4f10-9e46-111ed1368a0d',
                width: 40,
                height: 40,
              ),
            ),

            // ✅ Botón de información que abre un modal con los mensajes sospechosos
            widgets.buildInfoButton(screenWidth, () {
              showInformationSMSDialog(
                  context); // ✅ Llama directamente a la función
            }),

            // ✅ Sección decorativa inferior (textos, contenedor, etc.)
            decorations.buildDecorativeSections(
              context: context,
              screenWidth: screenWidth,
              screenHeight: screenHeight,
              logoTop: logoTop,
              logoLeft: logoLeft,
              user: widget.user,
              sampleMessage: sampleMessage,
              analyzingMessage: analyzingMessage,
            ),
          ],
        ),
      ),
    );
  }
}
