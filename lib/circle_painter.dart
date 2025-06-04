import 'package:flutter/material.dart';

/// Clase que extiende CustomPainter para dibujar un círculo con efecto de desenfoque (blur).
class CircleBlurPainter extends CustomPainter {
  final double blackCircleRadius; // Radio del círculo negro central
  final double blueBlurRadius; // Radio del desenfoque azul exterior

  /// Constructor que recibe los radios para ambos círculos
  CircleBlurPainter({
    required this.blackCircleRadius,
    required this.blueBlurRadius,
  });

  /// Método donde se pinta el contenido en el canvas
  @override
  void paint(Canvas canvas, Size size) {
    // Calculamos el centro del área disponible
    final center = Offset(size.width / 2, size.height / 2);

    // Pintura azul con opacidad y desenfoque (blur)
    final bluePaint = Paint()
      ..color = Colors.blue.withOpacity(0.6) // Color azul semi-transparente
      ..maskFilter = MaskFilter.blur(
          BlurStyle.normal, blueBlurRadius); // Efecto desenfocado

    // Pintura negra sin desenfoque para el centro
    final blackPaint = Paint()..color = Colors.black;

    // Dibuja el círculo azul grande con desenfoque
    canvas.drawCircle(center, blueBlurRadius, bluePaint);

    // Dibuja el círculo negro pequeño centrado sobre el azul
    canvas.drawCircle(center, blackCircleRadius, blackPaint);
  }

  /// Indica si es necesario volver a pintar el canvas (en este caso no)
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
