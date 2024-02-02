import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NFCWrapperView extends StatelessWidget {
  const NFCWrapperView({
    super.key,
    required bool isScanning,
  }) : _isScanning = isScanning;

  final bool _isScanning;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 200.0,
        height: 200.0,
        decoration: BoxDecoration(
          color: _isScanning ? Color.fromARGB(255, 224, 155, 50): Color.fromARGB(180, 25, 127, 243),
          shape: BoxShape.circle,
        ),
        child: Center(
            child: Icon(
          CupertinoIcons.radiowaves_right,
          size: 100,
          color: _isScanning ? Colors.green[400] : Colors.amber[400],
        )));
  }
}
