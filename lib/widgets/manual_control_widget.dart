import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ManualControlWidget extends StatelessWidget {
  final String robotId;
  final Map<String, dynamic>? data;

  const ManualControlWidget({super.key, required this.robotId, required this.data});

  @override
  Widget build(BuildContext context) {
    // ✅ WebSocket에서 받은 데이터 적용
    List<dynamic> speed = data?["current_speeds"] ?? [0];
    int speedValue = speed[0];

    final List<double> speedLevels = [15, 30, 44, 60]; // 각 버튼의 motor 값

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        int level = index + 1;
        bool isActive = speedValue == speedLevels[index];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: ElevatedButton(
            onPressed: () => _sendMqttCommand(index),
            style: ElevatedButton.styleFrom(
              backgroundColor: isActive ? Colors.green : Colors.black45,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              minimumSize: const Size(50, 30),
            ),
            child: Text("$level단", style: TextStyle(fontSize: 12)),
          ),
        );
      }),
    );
  }

  void _sendMqttCommand(int index) async {
    List<Map<String, dynamic>> topics = [
      {
        "topic": "set_twist",
        "payload": [
          0.15 * (index + 1),
          -0.15 * (index + 1),
          0.15 * (index + 1),
          0.12 * (index + 1)
        ].join(',')
      }
    ];

    final url = Uri.parse('http://112.164.105.160:4001/send-mqtt/$robotId');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'topics': topics}),
    );

    if (response.statusCode == 200) {
      print("MQTT 메시지 전송 성공: $topics");
    } else {
      print("MQTT 메시지 전송 실패: ${response.statusCode}");
    }
  }
}
