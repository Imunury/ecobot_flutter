// 🌍 웹뷰로 지도 표시
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TrackMap extends StatefulWidget {
  final String url;

  const TrackMap({super.key, required this.url});

  @override
  State<TrackMap> createState() => _TrackMapState();
}

class _TrackMapState extends State<TrackMap> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: WebViewWidget(controller: _controller),
    );
  }
}