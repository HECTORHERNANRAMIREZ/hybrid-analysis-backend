// Importa el paquete principal de Flutter para crear la interfaz de usuario
import 'package:flutter/material.dart';

// Importa la pantalla de carga personalizada, que será la pantalla inicial de la app
import 'loading_screen.dart'; // ✅ Se mantiene porque es la nueva pantalla inicial

// Observador de rutas para detectar cambios de navegación entre pantallas
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

// Función principal que se ejecuta al iniciar la app
void main() async {
  // Asegura que Flutter esté completamente inicializado antes de correr la app
  WidgetsFlutterBinding.ensureInitialized();

  // Inicia la aplicación llamando al widget raíz
  runApp(const MyApp());
}

// Widget principal de la aplicación
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Define la primera pantalla que se mostrará: LoadingScreen
      home: const LoadingScreen(),

      // Agrega el observador de rutas para rastrear la navegación
      navigatorObservers: [routeObserver],
    );
  }
}
