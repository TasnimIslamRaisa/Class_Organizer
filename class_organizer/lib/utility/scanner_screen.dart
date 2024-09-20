import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'download_page.dart';

class ScannerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR/Barcode Scanner'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            String scannedCode = await scanBarcode();
            if (scannedCode.isNotEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DownloadPage(scannedCode: scannedCode),
                ),
              );
            }
          },
          child: Text('Scan QR/Barcode'),
        ),
      ),
    );
  }

  Future<String> scanBarcode() async {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
      "#ff6666", // Color of the scan line
      "Cancel",  // Text for cancel button
      true,      // Show the flash icon
      ScanMode.DEFAULT,
    );

    return barcodeScanRes; // Returns the scanned code
  }
}
