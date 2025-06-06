// Importaciones necesarias
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:video_player/video_player.dart';

// Importa widgets reutilizables y decoraciones organizadas en archivos separados
import 'home_widgets.dart' as widgets;
import 'home_decorations.dart' as decorations;

// Función para analizar SMS y mostrar advertencias
import 'sms_analyzer.dart';

// Función para analizar archivos descargados
import 'file_analyzer.dart';

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
  int virusCount = 0; // Contador de archivos potencialmente peligrosos
  String? sampleMessage; // Muestra uno de los mensajes detectados
  String? analyzingMessage; // Mensaje temporal durante el análisis
  List<String> suspiciousMessages = []; // Lista de mensajes sospechosos

  // Función que inicia el análisis de los SMS y archivos
  void _startSmsAnalysis() async {
    setState(() {
      analyzingMessage = "🔍 Analizando un momento...";
    });

    final smsResult = await analyzeSMS(
      context,
      (intermediateText) {
        setState(() {
          analyzingMessage = intermediateText;
        });
      },
    );

    final fileCount = await analyzeDownloadedFiles();

    setState(() {
      suspiciousCount = smsResult.count;
      sampleMessage = smsResult.sampleMessage;
      suspiciousMessages = smsResult.suspiciousMessages;
      virusCount = fileCount;
      analyzingMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final double logoTop =
        widgets.circleTop + (widgets.circleArea - decorations.logoHeight) / 2;
    final double logoLeft = (screenWidth - decorations.logoWidth) / 2;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            if (widget.videoController.value.isInitialized)
              widgets.buildBackgroundVideo(widget.videoController),

            widgets.buildBlurredCircle(screenWidth),

            widgets.buildAnalyzeButton(screenWidth, _startSmsAnalysis),

            widgets.buildSolveButton(screenWidth, suspiciousMessages, context),

            // Indicador visual con número de mensajes sospechosos
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
                      'Mensajes de SMS: \$suspiciousCount | Virus encontrados: \$virusCount',
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

            Positioned(
              top: 300,
              left: 20,
              child: Image.network(
                'https://firebasestorage.googleapis.com/v0/b/app12-5128a.firebasestorage.app/o/uploads%2Fsms.png?alt=media&token=c085e136-1f43-4f10-9e46-111ed1368a0d',
                width: 40,
                height: 40,
              ),
            ),

            widgets.buildInfoButton(screenWidth, () {
              showInformationSMSDialog(context);
            }),

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
