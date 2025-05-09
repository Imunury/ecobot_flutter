import 'package:flutter/material.dart';
import '../utils/ecobot_list.dart';
import '../utils/region_mapping.dart'; // ✅ 추가
import 'robot_detail_screen.dart';

class RobotListScreen extends StatefulWidget {
  const RobotListScreen({super.key});

  @override
  State<RobotListScreen> createState() => _RobotListScreenState();
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

                final ctrDeviceStatus = robot["ctr_device_status"];
                String statusText;
                switch (ctrDeviceStatus) {
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
                    statusText = "ERROR"; // 예외 처리
                }

                final robotId = robot["robot_id"];
                final regionId = getRegionName(robotId); // ✅ 함수 호출로 대체

                return Card(
                  margin: EdgeInsets.all(8),
                  child: InkWell(
                    onTap: () {
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
                            "Region : $regionId",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 6),
                          Text("🤖 Robot : $robotId"),
                          Text("🕹 Mode : $statusText"),
                          Text("🔋 Battery : ${robot["ctr_bat_soc"]}%"),
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
