import 'dart:io';
import 'dart:typed_data';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../widgets/create_qr.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';

class qrCodeDisplayPage extends StatefulWidget {
  @override
  _qrCodeDisplayPageState createState() => _qrCodeDisplayPageState();
}

class _qrCodeDisplayPageState extends State<qrCodeDisplayPage> {
  ScreenshotController screenshotController = ScreenshotController();
  TextEditingController _textcontroller = TextEditingController();
  void _shareScreenShot() async {
    await screenshotController
        .capture(delay: const Duration(milliseconds: 10))
        .then((image) async {
      if (image != null) {
        final directory = await getApplicationDocumentsDirectory();
        final imagePath = await File('${directory.path}/image.png').create();
        await imagePath.writeAsBytes(image);
        await Share.shareFiles([imagePath.path],
            text:
                "QR Code Created and Shared from Crypt QR - https://github.com/tabspacecoder/CryptQR");
      }
    });
  }

  _saveQr() async {
    var result;
    await screenshotController
        .capture(delay: const Duration(milliseconds: 10))
        .then((image) async {
      result = await ImageGallerySaver.saveImage(Uint8List.fromList(image!),
          isReturnImagePathOfIOS: true,
          quality: 80,
          name:
              '${DateTime.now().day}${DateTime.now().month}${DateTime.now().year}${DateTime.now().hour}${DateTime.now().minute}${DateTime.now().second}QR');
    });
    showSnackbar(context, '${result['filePath']}');
  }

  void showSnackbar(BuildContext context, String filename) {
    var snackBar = SnackBar(
      shape: StadiumBorder(),
      elevation: 20,
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: 3),
      content: Text('Image saved in : $filename'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
            // pink : Color(0xffcc2b5e),
            //purple: Color(0xff753a88),
            Color(0xffda2854),
            Color(0xfffca43c),
          ])),
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Screenshot(
            controller: screenshotController,
            child: Card(
              elevation: 20,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomQrCode(
                  text: _textcontroller.text,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              style: TextStyle(fontSize: 20, color: Colors.white),
              controller: _textcontroller,
              onSubmitted: (text) {
                setState(() {});
              },
              keyboardType: TextInputType.url,
              decoration: InputDecoration(
                  hintText: "Enter Text for converting to QR",
                  labelText: "Enter Text Here",
                  labelStyle: TextStyle(color: Colors.white60),
                  hintStyle: TextStyle(color: Colors.white60),
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.amber, width: 2)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.amber))),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton.icon(
                    icon: Icon(Icons.save),
                    label: Text(
                      'Save',
                      style: TextStyle(fontSize: 20),
                    ),
                    style: TextButton.styleFrom(
                        primary: Color(0xffda2854),
                        backgroundColor: Colors.amber,
                        textStyle: TextStyle(
                            fontSize: 24, fontStyle: FontStyle.italic)),
                    onPressed: _saveQr,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton.icon(
                    icon: Icon(Icons.share),
                    label: Text(
                      'Share',
                      style: TextStyle(fontSize: 20),
                    ),
                    style: TextButton.styleFrom(
                        primary: Color(0xffda2854),
                        backgroundColor: Colors.amber,
                        textStyle: TextStyle(
                            fontSize: 24, fontStyle: FontStyle.italic)),
                    onPressed: _shareScreenShot,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
