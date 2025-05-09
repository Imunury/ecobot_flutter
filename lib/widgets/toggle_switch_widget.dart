import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ToggleSwitchWidget extends StatelessWidget {
  final String robotId;
  final Map<String, dynamic>? data;

  const ToggleSwitchWidget({super.key, required this.robotId, required this.data});

  @override
  Widget build(BuildContext context) {
    // ✅ WebSocket에서 받은 데이터 적용
    bool isOn = data?["motor_values"]?[0] == 1;

    return GestureDetector(
      onTap: () => _toggleSwitch(isOn),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 60,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isOn ? Colors.green : Colors.grey,
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              left: isOn ? 30 : 0,
              right: isOn ? 0 : 30,
              child: Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleSwitch(bool isOn) async {
    List<Map<String, dynamic>> topics = [
      {"topic": "cmd_plc", "payload": isOn ? '0' : '1'},
      {"topic": "mtr_ctrl", "payload": "stop"},
      {"topic": "drv_mode", "payload": isOn ? '00' : '01'},
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
