// Importaciones necesarias
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Constantes para dimensiones del logo
const double logoWidth = 160.0;
const double logoHeight = 160.0;

/// Función que construye todas las secciones decorativas de la pantalla principal
Widget buildDecorativeSections({
  required BuildContext context,
  required double screenWidth,
  required double screenHeight,
  required double logoTop,
  required double logoLeft,
  required User user,
  String? sampleMessage, // Mensaje de ejemplo tras análisis
  String? analyzingMessage, // Mensaje temporal mientras analiza
  int? fileThreatsCount, // 🔍 Nuevo: contador de archivos detectados
}) {
  return Stack(
    children: [
      /// ───── INDICADOR: Virus Encontrados ─────
      Positioned(
        top: 360,
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
                    Color.fromARGB(86, 0, 0, 0),
                    Color.fromARGB(103, 27, 38, 59),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                'Virus Encontrados: ${fileThreatsCount ?? 0}',
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

      /// Icono de virus al lado izquierdo del indicador
      Positioned(
        top: 360,
        left: 25,
        child: Image.network(
          'https://firebasestorage.googleapis.com/v0/b/app12-5128a.firebasestorage.app/o/uploads%2Fvirus.png?alt=media&token=d0f2aa54-16a8-4bed-a843-779a1a16e58e',
          width: 40,
          height: 40,
        ),
      ),

      /// ───── INDICADOR: Espionaje ─────
      Positioned(
        top: 420,
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
                    Color.fromARGB(86, 0, 0, 0),
                    Color.fromARGB(103, 27, 38, 59),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                'Espionaje:',
                style: TextStyle(
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

      /// Icono de espía al lado izquierdo del indicador
      Positioned(
        top: 420,
        left: 25,
        child: Image.network(
          'https://firebasestorage.googleapis.com/v0/b/app12-5128a.firebasestorage.app/o/uploads%2Fspy.png?alt=media&token=4958372a-e4ca-42de-a1a6-77399d767026',
          width: 40,
          height: 40,
        ),
      ),

      /// ───── LOGO CENTRAL ─────
      Positioned(
        top: logoTop,
        left: logoLeft,
        child: Image.network(
          'https://firebasestorage.googleapis.com/v0/b/app12-5128a.firebasestorage.app/o/uploads%2Flogo.png?alt=media&token=3e5f8d8a-22a6-4942-bb7e-0b4c55abaf00',
          width: logoWidth,
          height: logoHeight,
        ),
      ),

      /// ───── SECCIÓN: Resultado de Análisis ─────
      Positioned(
        top: 475,
        left: 70,
        child: Container(
          width: screenWidth - 120,
          height: 100,
          padding: const EdgeInsets.all(12),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Analizando:',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Open',
                ),
              ),
              const SizedBox(height: 6),
              Text(
                // Muestra primero el mensaje de análisis, luego uno de ejemplo
                analyzingMessage ??
                    sampleMessage ??
                    'Presiona "Analizar" para iniciar.',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: analyzingMessage != null
                      ? const Color.fromARGB(255, 245, 245, 245)
                      : Colors.white,
                  fontSize: 13,
                  fontFamily: 'Open',
                ),
              ),
            ],
          ),
        ),
      ),

      /// ───── BOTÓN DE SALIDA (Sign out y regresar) ─────
      Positioned(
        top: screenHeight * 0.04,
        left: screenWidth * 0.05,
        child: GestureDetector(
          onTap: () async {
            await FirebaseAuth.instance.signOut();
            await GoogleSignIn().signOut();
            if (!context.mounted) return;
            Navigator.pop(context); // Regresa a la pantalla anterior
          },
          child: Image.network(
            'https://firebasestorage.googleapis.com/v0/b/app12-5128a.firebasestorage.app/o/uploads%2Fvolver.png?alt=media&token=a35683dd-a13c-4918-8718-8c2a2815f246',
            width: screenWidth * 0.10,
            height: screenWidth * 0.10,
          ),
        ),
      ),

      /// ───── PERFIL DEL USUARIO (Nombre y foto) ─────
      Positioned(
        top: screenHeight * 0.02,
        right: screenWidth * 0.05,
        child: Row(
          children: [
            Text(
              user.displayName ?? '', // Muestra el nombre del usuario
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'Open',
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundImage:
                  NetworkImage(user.photoURL ?? ''), // Foto del usuario
              radius: 20,
            ),
          ],
        ),
      ),
    ],
  );
}
