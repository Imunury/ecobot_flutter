import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HoldingButtonWidget extends StatelessWidget {
  final String robotId;
  final Map<String, dynamic>? data;

  const HoldingButtonWidget(
      {super.key, required this.robotId, required this.data});

  void _sendMqttCommand() async {
    try {
      bool holdingState = data?["current_state"] == 3;
      List<Map<String, dynamic>> topics = [
        {
          "topic": "drv_mode",
          "payload": holdingState ? "01" : "03", // 상태에 따라 payload 변경
        }
      ];

      final url = Uri.parse('http://112.164.105.160:4001/send-mqtt/$robotId');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'topics': topics}),
      );

      if (response.statusCode == 200) {
        print("✅ MQTT 메시지 전송 성공: $topics");
      } else {
        print("❌ MQTT 메시지 전송 실패: ${response.statusCode}");
      }
    } catch (e) {
      print("⚠️ 오류 발생: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    bool hodlingState = data?["current_state"] == 3 ? true : false;

    return GestureDetector(
      onTap: _sendMqttCommand, // 함수 호출이 아니라 참조 전달해야 함
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: hodlingState ? Colors.blueAccent : Colors.white,
        ),
        child: Icon(Icons.pin_drop,
            size: 30, color: hodlingState ? Colors.white : Colors.black),
      ),
    );
  }
}
