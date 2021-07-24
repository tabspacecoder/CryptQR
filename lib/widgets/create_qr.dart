import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class CustomQrCode extends StatelessWidget {
  String text;
  CustomQrCode({this.text = 'Enter some text'});

  @override
  Widget build(BuildContext context) {
    return PrettyQr(
      elementColor: Colors.black,
      image: AssetImage('images/26.png'),
      typeNumber: 5,
      size: 300,
      data: text,
      errorCorrectLevel: QrErrorCorrectLevel.M,
      roundEdges: true,
    );
  }
}
