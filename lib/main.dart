import 'package:flutter/material.dart';
import 'screens/ecobot_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "EcoBot List",
      theme: ThemeData(primarySwatch: Colors.green),
      home: RobotListScreen(),
    );
  }
}
