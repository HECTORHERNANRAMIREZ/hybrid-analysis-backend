import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'circle_painter.dart';

/// ───── VARIABLES DE TAMAÑO ─────
const double figureWidth = 160.0;
const double figureHeight = 45.0;
const double figureTop = 220.0;

const double circleArea = 200.0;
const double blackRadius = 60.0;
const double blueRadius = 160.0;
const double logoWidth = 160.0;
const double logoHeight = 160.0;
const double circleTop = 50.0;

/// ───── VIDEO DE FONDO ─────
Widget buildBackgroundVideo(VideoPlayerController videoController) {
  return Positioned.fill(
    child: FittedBox(
      fit: BoxFit.cover,
      child: SizedBox(
        width: videoController.value.size.width,
        height: videoController.value.size.height,
        child: VideoPlayer(videoController),
      ),
    ),
  );
}

/// ───── CÍRCULO DIFUMINADO ─────
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
