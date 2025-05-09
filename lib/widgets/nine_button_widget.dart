import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NineButtonJoystick extends StatelessWidget {
  final String robotId;
  final Map<String, dynamic>? data;

  const NineButtonJoystick(
      {super.key, required this.robotId, required this.data});

  @override
  Widget build(BuildContext context) {
    List<dynamic> motor = data?["motor_values"] ?? [0, 0, 0, 0, 0];
    int motor1 = motor[1];
    int motor2 = motor[2];
    int motor3 = motor[3];
    int motor4 = motor[4];

    // ✅ 버튼 활성화 상태 결정
    String manualActive;
    if (motor1 > 0 && motor2 > 0) {
      manualActive = "forward";
    } else if (motor3 < 0 && motor4 > 0) {
      manualActive = "left_turn";
    } else if (motor3 > 0 && motor4 < 0) {
      manualActive = "right_turn";
    } else if (motor3 < 0 && motor4 < 0) {
      manualActive = "left_shift";
    } else if (motor3 > 0 && motor4 > 0) {
      manualActive = "right_shift";
    } else if (motor1 < 0 && motor2 < 0) {
      manualActive = "backward";
    } else {
      manualActive = "stop";
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildRow(
            ["left_turn", "forward", "right_turn"],
            [Icons.rotate_left, Icons.arrow_upward, Icons.rotate_right],
            manualActive),
        _buildRow(
            ["left_shift", "stop", "right_shift"],
            [Icons.arrow_back, Icons.circle, Icons.arrow_forward],
            manualActive),
        _buildRow(
            ["left_turn_down", "backward", "right_turn_down"],
            [Icons.rotate_left, Icons.arrow_downward, Icons.rotate_right],
            manualActive),
      ],
    );
  }

  Widget _buildRow(
      List<String> actions, List<IconData> icons, String manualActive) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return JoystickButton(
          icon: icons[index],
          isActive: manualActive == actions[index],
          onPressed: () => _sendMqttCommand(actions[index]),
        );
      }),
    );
  }

  void _sendMqttCommand(String action) async {
    List<Map<String, dynamic>> topics = [
      {
        "topic": "mtr_ctrl",
        "payload": action,
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

// 🎮 조이스틱 버튼 공통 위젯
class JoystickButton extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback onPressed;

  const JoystickButton({
    required this.icon,
    required this.isActive,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isActive ? Colors.blueAccent : Colors.black54, // 활성화 시 색상 변경
        ),
        child: Icon(icon, size: 40, color: Colors.white),
      ),
    );
  }
}
