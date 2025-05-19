import 'package:flutter/material.dart';
import 'screens/ecobot_list_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(); // 루트에 있는 .env 파일을 기본 경로로 인식
  runApp(const MyApp());
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
