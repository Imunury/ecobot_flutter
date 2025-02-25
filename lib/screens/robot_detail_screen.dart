import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RobotDetailScreen extends StatefulWidget {
  final Map<String, dynamic> robot;

  RobotDetailScreen({required this.robot});

  @override
  _RobotDetailScreenState createState() => _RobotDetailScreenState();
}

class _RobotDetailScreenState extends State<RobotDetailScreen> {
  late WebViewController controller;

  @override
  void initState() {
    super.initState();

    // 화면을 가로 모드로 강제 전환
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    // WebViewController 초기화
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
  }

  @override
  void dispose() {
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
    final url = 'https://ecobotdashboard1.co.kr/$robotId/';

    return Scaffold(
      body: Stack(
        children: [
          // WebView를 전체 화면으로 배치
          Positioned.fill(
            child: WebViewWidget(
              controller: controller..loadRequest(Uri.parse(url)),
            ),
          ),

          // 왼쪽 하단에 고정된 조이스틱 UI
          Positioned(
            left: 20, // 왼쪽 여백
            bottom: 20, // 아래쪽 여백
            child: FixedJoystick(),
          ),
        ],
      ),
    );
  }
}

// 왼쪽 하단 고정 조이스틱 UI
class FixedJoystick extends StatefulWidget {
  @override
  _FixedJoystickState createState() => _FixedJoystickState();
}

class _FixedJoystickState extends State<FixedJoystick> {
  String _activeButton = ""; // 현재 눌린 버튼 상태

  void _onPress(String direction) {
    setState(() => _activeButton = direction);
    print("$direction 버튼 눌림");
  }

  void _onRelease() {
    setState(() => _activeButton = "");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        JoystickButton(
          icon: Icons.arrow_drop_up,
          isActive: _activeButton == "up",
          onPressed: () => _onPress("up"),
          onReleased: _onRelease,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            JoystickButton(
              icon: Icons.arrow_left,
              isActive: _activeButton == "left",
              onPressed: () => _onPress("left"),
              onReleased: _onRelease,
            ),
            JoystickButton(
              icon: Icons.circle,
              isActive: _activeButton == "center",
              onPressed: () => _onPress("center"),
              onReleased: _onRelease,
            ),
            JoystickButton(
              icon: Icons.arrow_right,
              isActive: _activeButton == "right",
              onPressed: () => _onPress("right"),
              onReleased: _onRelease,
            ),
          ],
        ),
        JoystickButton(
          icon: Icons.arrow_drop_down,
          isActive: _activeButton == "down",
          onPressed: () => _onPress("down"),
          onReleased: _onRelease,
        ),
      ],
    );
  }
}

// 조이스틱 버튼 공통 위젯 (눌렀을 때 색 변경)
class JoystickButton extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback onPressed;
  final VoidCallback onReleased;

  JoystickButton({
    required this.icon,
    required this.isActive,
    required this.onPressed,
    required this.onReleased,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => onPressed(),
      onTapUp: (_) => onReleased(),
      onTapCancel: onReleased,
      child: Container(
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isActive ? Colors.blue : Colors.black.withOpacity(0.6), // 눌리면 파란색
        ),
        child: Icon(icon, size: 40, color: Colors.white),
      ),
    );
  }
}
