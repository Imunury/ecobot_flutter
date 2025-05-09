import 'package:flutter/material.dart';

class EcobotStatusWidget extends StatelessWidget {
  final String robotId;
  final Map<String, dynamic>? data;

  const EcobotStatusWidget({super.key, required this.robotId, required this.data});

  @override
  Widget build(BuildContext context) {
    // ✅ WebSocket에서 받은 데이터 적용
    int currentState = data?["current_state"] ?? 0;
    double ctrBatSoc = data?["ctr_bat_soc"]?.toDouble() ?? 0.0;
    List<dynamic> mtrValue = data?["motor_values"].sublist(1) ?? [];

    // ✅ 상태 값 변환
    String statusText;
    switch (currentState) {
      case 0:
        statusText = "정지";
        break;
      case 1:
        statusText = "수동";
        break;
      case 2:
        statusText = "코스주행";
        break;
      case 3:
        statusText = "위치사수";
        break;
      default:
        statusText = "ERROR";
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.black, // 배경 검은색
        borderRadius: BorderRadius.circular(8), // 모서리 둥글게 (선택 사항)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "ID : $robotId",
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
          Text(
            "Mode : $statusText",
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
          Text(
            "배터리 : $ctrBatSoc%",
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
          Text(
            "모터 값 : $mtrValue",
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
