import 'package:flutter/material.dart';

class DownloadPage extends StatelessWidget {
  final String scannedCode;

  DownloadPage({required this.scannedCode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Download Page'),
      ),
      body: Center(
        child: Text(
          'Scanned Code: $scannedCode',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
