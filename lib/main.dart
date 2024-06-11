import 'package:flutter/material.dart';
import 'package:project1/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Offline Music Player',
      theme: ThemeData(
        primarySwatch: Colors.red,
        hintColor: Colors.amber,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.blueGrey[400],
        appBarTheme: const AppBarTheme(
          color: Colors.lightBlueAccent,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
          bodyMedium: TextStyle(color: Colors.black),
        ),
      ),
      home: const MusicPlayerScreen(),
    );
  }
}
