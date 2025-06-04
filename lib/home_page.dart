// Importa los paquetes necesarios
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:video_player/video_player.dart'; // Para mostrar video de fondo

// Importa el layout de la página principal (interfaz de usuario estructurada)
import 'home_layout.dart';

// Widget con estado que representa la página principal después del inicio de sesión
class HomePage extends StatefulWidget {
  final User user; // Usuario autenticado que se pasa desde logeo.dart

  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late VideoPlayerController _videoController; // Controlador del video de fondo

  @override
  void initState() {
    super.initState();

    // Inicializa el video desde una URL en Firebase Storage
    _videoController = VideoPlayerController.networkUrl(
      Uri.parse(
        'https://firebasestorage.googleapis.com/v0/b/app12-5128a.firebasestorage.app/o/uploads%2Ffondo.mp4?alt=media&token=10641f1c-973b-4213-bf7f-52c39cbee569',
      ),
    )..initialize().then((_) {
        // Cuando el video esté listo, actualiza el estado y configura el video
        setState(() {});
        _videoController.setLooping(true); // Reproduce en bucle
        _videoController.setVolume(0.0); // Sin sonido
        _videoController.play(); // Reproduce automáticamente
      });
  }

  @override
  void dispose() {
    // Libera recursos del controlador cuando el widget se destruye
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Usa un layout externo (HomePageLayout) y le pasa el video y el usuario
    return HomePageLayout(
      videoController: _videoController,
      user: widget.user,
    );
  }
}
