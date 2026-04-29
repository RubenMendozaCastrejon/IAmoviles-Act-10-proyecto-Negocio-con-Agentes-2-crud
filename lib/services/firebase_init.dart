import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class FirebaseInit {
  static Future<void> initialize() async {
    try {
      if (kIsWeb) {
        // Configuración específica para WEB (la que te dio Firebase)
        await Firebase.initializeApp(
          options: const FirebaseOptions(
            apiKey: "AIzaSyA5M3jOWpZ945c-qOXjX8jdEdEQ2SWY4nY",
            authDomain: "bdinvestech.firebaseapp.com",
            projectId: "bdinvestech",
            storageBucket: "bdinvestech.firebasestorage.app",
            messagingSenderId: "160748377511",
            appId: "1:160748377511:web:bc17f7394b721a13ba1282",
          ),
        );
      } else {
        // Configuración para Android/iOS (usa el archivo google-services.json)
        await Firebase.initializeApp();
      }
      print("Firebase inicializado correctamente");
    } catch (e) {
      print("Error al inicializar Firebase: $e");
    }
  }
}