// Importa los paquetes necesarios para la interfaz, conectividad y Firebase
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';

// Importa la pantalla de introducción que se mostrará luego de la carga
import 'intro.dart'; // Asegúrate de que esta pantalla exista

// Widget con estado que representa la pantalla de carga inicial
class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    // Al iniciar, se ejecuta el proceso de inicialización de la app
    _initializeApp();
  }

  // Método asincrónico para inicializar Firebase y verificar conexión
  Future<void> _initializeApp() async {
    // Inicializa Firebase antes de usar cualquier funcionalidad relacionada
    await Firebase.initializeApp();

    // Verifica el estado de la conexión a internet
    final connectivityResult = await Connectivity().checkConnectivity();

    // Si no hay conexión, muestra un mensaje y espera 3 segundos
    if (connectivityResult == ConnectivityResult.none && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("❌ Sin conexión a internet"),
        ),
      );
      await Future.delayed(const Duration(seconds: 3));
    }

    // Espera adicional para dar tiempo a la animación de carga o procesos internos
    await Future.delayed(const Duration(seconds: 2));

    // Si el widget sigue montado, navega a la pantalla de introducción
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const IntroPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black, // Fondo oscuro
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Indicador de carga circular
            CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 20),
            // Texto que indica el estado de carga
            Text(
              "Cargando...",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
