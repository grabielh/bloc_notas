import 'package:bloc_notas/bloc-notas/widgets/drawer/drawer_homescreens.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          colorScheme: const ColorScheme.highContrastLight(
              primary: Colors.black,
              secondary: Colors.white,
              background: Color(0XFF274754))),
      title: 'Bloc-notas',
      home: const DrawerHomeEscreens(),
    );
  }
}
