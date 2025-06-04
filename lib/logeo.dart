// Importa los paquetes necesarios de Flutter, Firebase y Google Sign-In
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Importa la pantalla principal a la que se navegará tras autenticarse
import 'home_page.dart';

// Widget sin estado que representa el contenido del inicio de sesión
class LogeoContent extends StatelessWidget {
  const LogeoContent({super.key});

  // Función asincrónica para autenticarse con Google
  Future<User?> _signInWithGoogle() async {
    try {
      // Abre el cuadro de diálogo de cuenta de Google
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Si el usuario cancela el inicio de sesión, termina el proceso
      if (googleUser == null) {
        debugPrint("🔴 Google Sign-In cancelado");
        return null;
      }

      // Obtiene los tokens necesarios para autenticar con Firebase
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Crea las credenciales para Firebase a partir del inicio de sesión de Google
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Usa las credenciales para iniciar sesión en Firebase
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      debugPrint("✅ Usuario autenticado: ${userCredential.user?.displayName}");
      return userCredential.user;
    } catch (e) {
      // En caso de error, lo muestra en la consola
      debugPrint("❌ Error en Google Sign-In: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center, // Centra el contenido verticalmente
      child: Column(
        mainAxisSize: MainAxisSize.min, // Toma el tamaño mínimo necesario
        children: [
          // Título "Inicia sesión"
          const Padding(
            padding: EdgeInsets.only(right: 1.0, bottom: 10.0),
            child: Text(
              'Inicia sesión',
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
                fontFamily: 'Open',
                fontWeight: FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 0),
            child: Column(
              children: [
                // Fila con iconos de redes sociales
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Botón de Facebook (sin funcionalidad por ahora)
                    IconButton(
                      icon: const Icon(
                        Icons.facebook,
                        color: Colors.blue,
                        size: 30.0,
                      ),
                      onPressed: () async {
                        // Implementación futura para Facebook Login
                      },
                    ),
                    const SizedBox(width: 20),

                    // Botón de Google con imagen personalizada
                    IconButton(
                      icon: Image.network(
                        'https://firebasestorage.googleapis.com/v0/b/app12-5128a.firebasestorage.app/o/uploads%2Fgoogle.png?alt=media&token=0e79f76f-af8c-43f9-a2e6-2313b525987d',
                        width: 30.0,
                        height: 30.0,
                      ),
                      onPressed: () async {
                        // Llama a la función de inicio de sesión con Google
                        User? user = await _signInWithGoogle();

                        // Si el usuario se autenticó correctamente, navega a HomePage
                        if (user != null && context.mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(user: user),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Texto de "Términos y condiciones"
                const Text(
                  'Términos y condiciones',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontFamily: 'Open',
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
