import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_filex/open_filex.dart';

class BlackBoxOnlineE extends StatefulWidget {
  @override
  _BlackBoxOnlineEState createState() => _BlackBoxOnlineEState();
}

class _BlackBoxOnlineEState extends State<BlackBoxOnlineE> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    
    final PlatformWebViewControllerCreationParams params = 
        const PlatformWebViewControllerCreationParams();
    _controller = WebViewController.fromPlatformCreationParams(params);

    _controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageFinished: (String url) {
          setState(() {
            _isLoading = false;
          });
          _injectJavaScript();
        },
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

  Future<void> _checkPermissions() async {
    if (!await Permission.storage.isGranted) {
      await Permission.storage.request();
    }
  }

  Future<void> _downloadFile(String url) async {
    if (await Permission.storage.request().isGranted) {
      Directory? directory = await getExternalStorageDirectory();
      String path = directory!.path + "/downloaded_file.pdf";
      File file = File(path);

      try {
        var request = await HttpClient().getUrl(Uri.parse(url));
        var response = await request.close();

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

  Future<void> _fileUploadRequest() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      PlatformFile file = result.files.first;
      print('Selected file: ${file.name}');
    } else {
      print('No file selected');
    }
  }

  // Inject JavaScript to handle file uploads
  void _injectJavaScript() {
    _controller.runJavaScript('''
      document.querySelectorAll('input[type=file]').forEach(input => {
        input.addEventListener('click', function(event) {
          window.flutter_inappwebview.callHandler('fileChooser').then(result => {
            const file = new File([result], result.name);
            const dataTransfer = new DataTransfer();
            dataTransfer.items.add(file);
            input.files = dataTransfer.files;
          });
        });
      });
    ''');
  }

  // Refresh the WebView
  Future<void> _refreshPage() async {
    setState(() {
      _isLoading = true;
    });
    _controller.reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('East Delta University'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refreshPage,
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
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
