import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_filex/open_filex.dart';

class BlackBox extends StatefulWidget {
  @override
  _BlackBoxState createState() => _BlackBoxState();
}

class _BlackBoxState extends State<BlackBox> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    // No need to set WebView platform manually in the latest version

    // Initialize WebViewController
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onNavigationRequest: (NavigationRequest request) async {
          if (request.url.contains('.pdf')) {
            await _downloadFile(request.url);
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ))
      ..loadRequest(Uri.parse('https://edu.orbund.com/einstein-freshair/index.jsp'));

    _checkPermissions();
  }

  // Check permissions for storage access
  Future<void> _checkPermissions() async {
    if (!await Permission.storage.isGranted) {
      await Permission.storage.request();
    }
  }

  // Method to handle file downloads
  Future<void> _downloadFile(String url) async {
    if (await Permission.storage.request().isGranted) {
      Directory? directory = await getExternalStorageDirectory();
      String path = directory!.path + "/downloaded_file.pdf"; // Specify the extension
      File file = File(path);

      try {
        var request = await HttpClient().getUrl(Uri.parse(url));
        var response = await request.close();

        // Handle the byte stream manually
        List<int> bytes = [];
        await for (var data in response) {
          bytes.addAll(data);
        }
        await file.writeAsBytes(bytes);

        OpenFilex.open(file.path);
      } catch (e) {
        print("Download failed: $e");
      }
    }
  }

  // Method to handle file upload requests
  Future<void> _fileUploadRequest() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      PlatformFile file = result.files.first;
      print('Selected file: ${file.name}');
    } else {
      print('No file selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('East Delta University'),
      ),
      body: Stack(
        children: <Widget>[
          // Use WebViewWidget instead of WebView
          WebViewWidget(controller: _controller),
          _isLoading ? Center(child: CircularProgressIndicator()) : Container(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fileUploadRequest,
        child: Icon(Icons.upload),
      ),
    );
  }
}
