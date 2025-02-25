import 'package:flutter/material.dart';
import '../services/ecobot_list.dart';
import 'robot_detail_screen.dart'; // 새로 추가할 상세 화면

class RobotListScreen extends StatefulWidget {
  @override
  _RobotListScreenState createState() => _RobotListScreenState();
}

class _RobotListScreenState extends State<RobotListScreen> {
  late Future<List<dynamic>> robots;

  @override
  void initState() {
    super.initState();
    robots = ApiService().fetchRobots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("로봇 리스트")),
      body: FutureBuilder<List<dynamic>>(
        future: robots,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("데이터를 불러오지 못했습니다."));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var robot = snapshot.data![index];
                return Card(
                  margin: EdgeInsets.all(8),
                  child: InkWell(
                    onTap: () {
                      // 클릭 시 새로운 화면으로 이동
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RobotDetailScreen(robot: robot),
                        ),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Robot ID: ${robot["robot_id"]}",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 6),
                          Text("📡 상태: ${robot["ctr_device_status"]}"),
                          Text("🔋 배터리: ${robot["ctr_bat_soc"]}"),
                          Text("📍 위도: ${robot["latitude"]}, 경도: ${robot["longitude"]}"),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
