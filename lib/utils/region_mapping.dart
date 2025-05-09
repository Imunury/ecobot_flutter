// lib/utils/region_mapping.dart
Map<String, String> regionMapping = {
  "ecobot00003": "보령호",
  "ecobot00004": "강정고령보",
  "ecobot00005": "안동댐",
  "ecobot00006": "추소리",
  "ecobot00007": "서낙동강1",
  "ecobot00008": "서낙동강2",
  "ecobot00009": "인천",
  "ecobot00012": "진천1",
  "ecobot00013": "진천2",
  "ecobot00014": "신창제",
  "ecobot00016": "EDC",
  "ecobot00017": "죽산보",
  "ecobot00018": "창녕보",
  "ecobot00019": "싱가포르",
  "ecobot00020": "거품제거봇",
};

String getRegionName(String robotId) {
  return regionMapping[robotId] ?? "임시"; // 기본값 처리
}
