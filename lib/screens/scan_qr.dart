import 'package:flutter/material.dart';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class qrCodeScannerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _qrCodeScannerPageState();
}

class _qrCodeScannerPageState extends State<qrCodeScannerPage> {
  IconData flashIcon = Icons.flash_off;
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  void showSnackbar(BuildContext context, String filename) {
    var snackBar = SnackBar(
      shape: StadiumBorder(),
      elevation: 20,
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: 3),
      content: Text('Copied to clipboard!'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(flex: 10, child: _buildQrView(context)),
        Expanded(
          flex: 1,
          child: Card(
            borderOnForeground: false,
            color: Color(0xfffca43c),
            margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: ListTile(
              leading: Icon(
                Icons.qr_code_scanner,
                color: Color(0xffda2854),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: result!.code));
                    },
                    icon: Icon(
                      Icons.content_copy_outlined,
                      color: Color(0xffda2854),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      await controller?.toggleFlash();
                      setState(() {
                        flashIcon == Icons.flash_off
                            ? flashIcon = Icons.flash_on
                            : flashIcon = Icons.flash_off;
                      });
                    },
                    icon: Icon(
                      flashIcon,
                      color: Color(0xffda2854),
                    ),
                  )
                ],
              ),
              title: Text(
                result != null ? '${result!.code}' : 'Scan a code',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Color(0xffda2854),
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
