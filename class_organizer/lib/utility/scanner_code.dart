import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'download_page.dart';
import 'download_routine.dart';

class ScannerCode extends StatefulWidget {
  @override
  _ScannerCodeState createState() => _ScannerCodeState();
}

class _ScannerCodeState extends State<ScannerCode> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String scannedCode = '';
  TextEditingController _manualCodeController = TextEditingController();

  @override
  void reassemble() {
    super.reassemble();
    if (controller != null) {
      controller!.pauseCamera();
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR/Barcode Scanner'),
      ),
      body: Column(
        children: <Widget>[
          // QR Scanner view
          Expanded(
            flex: 4,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),

          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [

                  TextField(
                    controller: _manualCodeController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter Code Manually',
                      hintText: 'Enter Temp Code|Num',
                    ),
                    onChanged: (value) {
                      setState(() {
                        scannedCode = value;
                      });
                    },
                  ),
                  SizedBox(height: 10),

                  ElevatedButton(
                    onPressed: scannedCode.isNotEmpty
                        ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DownloadRoutine(scannedCode: scannedCode),
                        ),
                      );
                    }
                        : null,
                    child: Text('Go to Download Page'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // QR code scanning logic
  void _onQRViewCreated(QRViewController qrController) {
    this.controller = qrController;
    qrController.scannedDataStream.listen((scanData) {
      setState(() {
        scannedCode = scanData.code ?? '';
        _manualCodeController.text = scannedCode;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    _manualCodeController.dispose(); // Dispose of the controller
    super.dispose();
  }
}
