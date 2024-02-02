import 'package:flutter/material.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0xff4a69bd),
          title: Row(
        children: const [
          Icon(Icons.nfc_rounded, color: Colors.white,),
          SizedBox(width: 10),
          Text('무주덕유산리조트 회원체크', style: TextStyle(color: Colors.white,),),
        ],
      )),
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              FilledButton.tonal(
                  onPressed: () {
                    Navigator.pushNamed(context, '/nfc/read');
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.document_scanner_rounded),
                      SizedBox(width: 40, height: 40,),
                      Text(
                        '카드 확인',
                        style: TextStyle(fontSize: 30),
                      ),
                    ],
                  )),
              // FilledButton.tonal(
              //     onPressed: () {
              //       Navigator.pushNamed(context, '/nfc/write');
              //     },
              //     child: Row(
              //       mainAxisSize: MainAxisSize.min,
              //       children: const [
              //         Icon(Icons.edit_note_rounded),
              //         SizedBox(width: 10),
              //         Text(
              //           'NFC Write',
              //           style: TextStyle(fontSize: 20),
              //         ),
              //       ],
              //     )),
            ],
          ),
        ],
      ),
    );
  }
}
