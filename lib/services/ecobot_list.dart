import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String apiUrl = "https://eco-dashboard-kappa.vercel.app/api/ecobot_list";

  Future<List<dynamic>> fetchRobots() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // JSON을 리스트로 변환
    } else {
      throw Exception("데이터를 불러오지 못했습니다.");
    }
  }
}
