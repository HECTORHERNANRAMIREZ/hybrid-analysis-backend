// Importaciones necesarias
import 'package:flutter/material.dart';
import 'dart:async'; // Para usar Timer
import 'package:video_player/video_player.dart'; // Para reproducir video de fondo
import 'logeo.dart'; // Contenido de logeo (pantalla siguiente)
import 'main.dart'; // Para acceder al routeObserver definido en main.dart

// Widget principal de la página de introducción
class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

// Estado del widget, implementa RouteAware para pausar/reanudar video si cambia de pantalla
class _IntroPageState extends State<IntroPage> with RouteAware {
  bool _isLogoMoved = false; // Controla si el logo ya se animó
  bool _showLogeoContent =
      false; // Controla si se muestra el contenido de logeo
  late VideoPlayerController
      _videoController; // Controlador para el video de fondo

  @override
  void initState() {
    super.initState();

    // Inicializa el video desde una URL en Firebase Storage
    _videoController = VideoPlayerController.networkUrl(
      Uri.parse(
        'https://firebasestorage.googleapis.com/v0/b/app12-5128a.firebasestorage.app/o/uploads%2Ffondo.mp4?alt=media&token=10641f1c-973b-4213-bf7f-52c39cbee569',
      ),
    )..initialize().then((_) {
        _videoController
          ..setLooping(true) // Hace que el video se repita
          ..setVolume(0.0) // Sin sonido
          ..play(); // Reproduce el video automáticamente

        if (mounted)
          setState(() {}); // Refresca la interfaz una vez inicializado
      });

    // Después de 500 ms, anima el logo y luego muestra el contenido de logeo
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;

      setState(() => _isLogoMoved = true);

      // Después de 1 segundo, muestra el contenido de logeo
      Timer(const Duration(seconds: 1), () {
        if (mounted) setState(() => _showLogeoContent = true);
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Suscribe este widget al routeObserver para saber cuándo regresa a la pantalla
    routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
  }

  @override
  void dispose() {
    // Libera los recursos usados por el observador y el controlador de video
    routeObserver.unsubscribe(this);
    _videoController.dispose();
    super.dispose();
  }

  @override
  void didPopNext() {
    // Si se vuelve a esta pantalla desde otra, reanuda el video
    if (_videoController.value.isInitialized) {
      _videoController.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Fondo negro por defecto
          Positioned.fill(child: Container(color: Colors.black)),

          // Si el video se inicializó correctamente, lo muestra como fondo
          if (_videoController.value.isInitialized)
            Positioned.fill(
              child: FittedBox(
                fit: BoxFit.cover, // Ajusta el video al tamaño de pantalla
                child: SizedBox(
                  width: _videoController.value.size.width,
                  height: _videoController.value.size.height,
                  child: VideoPlayer(_videoController),
                ),
              ),
            ),

          // Logo animado (posición y tamaño cambian con el tiempo)
          AnimatedAlign(
            duration: const Duration(seconds: 1),
            curve: Curves.easeInOut,
            alignment:
                _isLogoMoved ? const Alignment(0, -0.5) : Alignment.center,
            child: AnimatedContainer(
              duration: const Duration(seconds: 1),
              curve: Curves.easeInOut,
              width: _isLogoMoved ? 180 : 250,
              height: _isLogoMoved ? 150 : 250,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    'https://firebasestorage.googleapis.com/v0/b/app12-5128a.firebasestorage.app/o/uploads%2Flogo.png?alt=media&token=3e5f8d8a-22a6-4942-bb7e-0b4c55abaf00',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // Si la animación terminó, muestra el contenido de logeo (botón o formulario)
          if (_showLogeoContent) const LogeoContent(),
        ],
      ),
    );
  }
}
