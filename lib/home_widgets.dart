// Importaciones necesarias
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

// Pintor personalizado para el círculo difuminado
import 'circle_painter.dart';

// Función externa que guarda los mensajes para mostrarlos en un modal
import 'informations_sms.dart';

/// ───── VARIABLES DE TAMAÑO ─────
/// Estas constantes controlan posiciones y dimensiones para los widgets
const double figureWidth = 160.0;
const double figureHeight = 45.0;
const double figureTop = 220.0;

const double circleArea = 200.0;
const double blackRadius = 60.0;
const double blueRadius = 160.0;
const double logoWidth = 160.0;
const double logoHeight = 160.0;
const double circleTop = 50.0;

const double solveWidth = 160.0;
const double solveHeight = 45.0;
const double solveTop = 620.0;

const double infoButtonTop =
    690.0; // 🆕 Botón de imagen debajo del "Solucionar"

/// VIDEO DE FONDO
/// Muestra el video de fondo que cubre toda la pantalla
Widget buildBackgroundVideo(VideoPlayerController videoController) {
  return Positioned.fill(
    child: FittedBox(
      fit: BoxFit.cover, // Asegura que el video cubra la pantalla completa
      child: SizedBox(
        width: videoController.value.size.width,
        height: videoController.value.size.height,
        child: VideoPlayer(videoController),
      ),
    ),
  );
}

/// CÍRCULO DIFUMINADO
/// Dibuja un círculo decorativo en el centro superior de la pantalla
Widget buildBlurredCircle(double screenWidth) {
  final circleLeft = (screenWidth - circleArea) / 2;

  return Positioned(
    top: circleTop,
    left: circleLeft,
    child: SizedBox(
      width: circleArea,
      height: circleArea,
      child: CustomPaint(
        painter: CircleBlurPainter(
          blackCircleRadius: blackRadius,
          blueBlurRadius: blueRadius,
        ),
      ),
    ),
  );
}

/// BOTÓN "ANALIZAR"
/// Botón que lanza la función de análisis de SMS
Widget buildAnalyzeButton(
  double screenWidth,
  VoidCallback onPressed,
) {
  final figureLeft = (screenWidth - figureWidth) / 2;

  return Positioned(
    top: figureTop,
    left: figureLeft,
    child: SizedBox(
      width: figureWidth,
      height: figureHeight,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(97, 0, 0, 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
          elevation: 0,
          padding: EdgeInsets.zero,
        ),
        child: const Text(
          'Analizar',
          style: TextStyle(
            fontFamily: 'Open',
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );
}

/// BOTÓN "SOLUCIONAR"
/// Guarda los mensajes sospechosos detectados para mostrarlos posteriormente
Widget buildSolveButton(
    double screenWidth, List<String> messages, BuildContext context) {
  final solveLeft = (screenWidth - solveWidth) / 2;

  return Positioned(
    top: solveTop,
    left: solveLeft,
    child: SizedBox(
      width: solveWidth,
      height: solveHeight,
      child: ElevatedButton(
        onPressed: () {
          saveMessages(messages); // ✅ Guarda los mensajes sospechosos
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(97, 0, 0, 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
          elevation: 0,
          padding: EdgeInsets.zero,
        ),
        child: const Text(
          'Solucionar',
          style: TextStyle(
            fontFamily: 'Open',
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );
}

/// BOTÓN DE INFORMACIÓN
/// Muestra un botón con un ícono de información que abre un modal con los mensajes
Widget buildInfoButton(double screenWidth, VoidCallback onPressed) {
  final double buttonTop = 680.0;
  final double buttonLeft = (screenWidth - 50.0) / 1.2;

  return Positioned(
    top: buttonTop,
    left: buttonLeft,
    child: SizedBox(
      width: 50,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(97, 0, 0, 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
          elevation: 0,
          padding: EdgeInsets.zero,
        ),
        child: Image.network(
          'https://firebasestorage.googleapis.com/v0/b/app12-5128a.firebasestorage.app/o/uploads%2Finformation.png?alt=media&token=5201a98e-1e20-429c-a9dd-1ebba05883bb',
          width: 30,
          height: 30,
          fit: BoxFit.contain,
        ),
      ),
    ),
  );
}
