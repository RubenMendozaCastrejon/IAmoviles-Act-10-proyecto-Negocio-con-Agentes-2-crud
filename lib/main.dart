import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'providers/activo_provider.dart';
import 'providers/transaccion_provider.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ActivoProvider()),
        ChangeNotifierProvider(create: (_) => TransaccionProvider()),
      ],
      child: MaterialApp(
        title: 'CrudInvestech',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorSchemeSeed: Colors.indigo,
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}