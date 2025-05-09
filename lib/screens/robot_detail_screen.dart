import 'package:cctv_flutter/widgets/holding_button_widget.dart';
import 'package:cctv_flutter/widgets/toggle_switch_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';

import '../widgets/back_button_widget.dart';
import '../widgets/ecobot_status_widget.dart';
import '../widgets/manual_control_widget.dart';
import '../widgets/track_map_widget.dart';
import '../widgets/nine_button_widget.dart';

class RobotDetailScreen extends StatefulWidget {
  final Map<String, dynamic> robot;

  const RobotDetailScreen({super.key, required this.robot});

  @override
  State<RobotDetailScreen> createState() => RobotDetailScreenState();
}

class RobotDetailScreenState extends State<RobotDetailScreen> {
  late WebSocketChannel channel;
  late final WebViewController controller;

  Map<String, dynamic>? websocketData; // WebSocket 데이터 저장 변수

  @override
  void initState() {
    super.initState();
    _connectWebSocket();

    // 화면을 가로 모드로 강제 전환
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    // WebViewController 초기화 및 URL 로드
    final robotId = widget.robot["robot_id"];
    final url = 'https://ecobotdashboard1.co.kr/$robotId/';

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black) // 배경을 검은색으로 설정
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) {
            controller.runJavaScript('''
              document.querySelector('meta[name="viewport"]')?.remove();
              let meta = document.createElement('meta');
              meta.name = "viewport";
              meta.content = "width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, viewport-fit=cover";
              document.head.appendChild(meta);
              document.documentElement.style.overflow = "hidden";
              document.body.style.overflow = "hidden";
            ''');
          },
        ),
      )
      ..loadRequest(Uri.parse(url));
  }

  void _connectWebSocket() {
    channel = IOWebSocketChannel.connect('ws://112.164.105.160:4101');

    // 특정 robotId 구독 요청 전송
    channel.sink.add(jsonEncode({
      "type": "subscribe",
      "robotId": widget.robot["robot_id"]
    }));

    // WebSocket에서 데이터 수신
    channel.stream.listen((message) {

      try {
        final data = jsonDecode(message); // JSON 문자열 → Map 변환

        if (data is Map<String, dynamic>) {
          setState(() {
            websocketData = data; // 데이터 업데이트
          });
        } else {
          setState(() {
          });
        }
      } catch (e) {
        setState(() {
        });
      }
    });
  }


  @override
  void dispose() {
    channel.sink.close();
    // 화면 회전 설정을 기본값(세로 모드 허용)으로 되돌리기
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final robotId = widget.robot["robot_id"];

    final trackUrl =
        'https://ecobotdashboard1.co.kr/d-solo/flutter_track_$robotId/$robotId?orgId=1&panelId=1';
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: WebViewWidget(controller: controller)),
          Positioned(top : 100, left : 40, child: ToggleSwitchWidget(robotId : robotId, data:websocketData)),
          Positioned(top : 85, left : 140, child: HoldingButtonWidget(robotId : robotId, data:websocketData )),
          Positioned(top: 30, left: 20, child: BackButtonWidget()),
          Positioned(
            left: 10,
            bottom: 10,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ManualControlWidget(
                  robotId: robotId,
                    data:websocketData
                ),
                const SizedBox(height: 5), // 버튼과 조이스틱 사이 여백
                NineButtonJoystick(
                  robotId: robotId,
                    data:websocketData
                ),
              ],
            ),
          ),
          Positioned(
            top: 30,
            right: 10,
            child: Opacity(
              opacity: 0.4,
              child: SizedBox(
                  width: 240, child: EcobotStatusWidget(robotId: robotId, data:websocketData)),
            ),
          ),
          Positioned(
            right: 10,
            bottom: 10,
            child: SizedBox(
              width: 240, // 크기 조정
              height: 160,
              child: TrackMap(
                url: trackUrl,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
