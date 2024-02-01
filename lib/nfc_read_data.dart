
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_nfc_sample/nfc_helpers/ndef_records.dart';
import 'package:flutter_nfc_sample/nfc_helpers/nfc_form_row.dart';
import 'package:flutter_nfc_sample/nfc_helpers/nfc_wrapper_view.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/painting.dart';
import 'package:assets_audio_player/assets_audio_player.dart';


final AssetsAudioPlayer _assetsAudioPlayer = AssetsAudioPlayer.newPlayer();

class NfcReadData extends StatefulWidget {
  NfcReadData({Key? key}) : super(key: key);

  @override
  State<NfcReadData> createState() => _NfcReadDataState();
}

class _NfcReadDataState extends State<NfcReadData> {

  
  var image = null;
  

  Future<NfcTag?> _scannedTag = Future.value(null);
  bool _isScanning = false;
  bool isMember = false;
  String identiStr = "";
  Map<String, dynamic> _jsonData = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Row(
        children: [
          Icon(Icons.document_scanner_rounded),
          SizedBox(width: 10),
          Text('카드 인식'),
        ],
      )),
      body:  ListView(
        children: [
          const Padding(padding: EdgeInsets.all(20.0),),
          GestureDetector(
              onTap: () => {                    
                    setState(() {
                      
                      _isScanning = true;
                      launchNfcSequence1();
                    })
                  },
              child: NFCWrapperView(isScanning: _isScanning)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder(
              future: printMember(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {

                  
                  if(_jsonData.isEmpty)
                  {
                      return const Center(
                      child: Text(
                          ''));
                  }
                
                  String useYn = _jsonData['USE_YN'];
                  if(useYn == 'N')
                  {
                    return const Center(
                      child: Text(
                          '사용 불가카드입니다.'));
                  }

                  String cardType = _jsonData['CardType'];
                  String reason = _jsonData['REASON'];
                  String typeName = _jsonData['TypeName'];
                  String memberNo = _jsonData['MEMBER_NO'];
                  String memberGubun = _jsonData['MEMBER_GUBUN'];
                  String memberName = _jsonData['MEMBER_Name'];
                  String gonUse = _jsonData['GON_USE'];
                  String daesoGubun = _jsonData['DAESO_GUBUN'];
                  String fromTime = _jsonData['FROM_TIME'];
                  String toTime = _jsonData['TO_TIME'];
                  String picture = _jsonData['PICTURE'];
                  String picture1 = _jsonData['PICTURE1'];
                  String blacklist = _jsonData['BlackList'];
                  String idNo = _jsonData['ID_NO'];
                  String telNo = _jsonData['TEL_NO'];
                  String valid = _jsonData['VALID'];
                  String daesoGubun1 = _jsonData['DAESO_GUBUN1'];
                  String category = _jsonData['Category'];

                  try{
                    if(picture1.length > 10)
                    {
                      image = Image.memory(base64.decode(picture1));
                    }else{
                      image = Image.asset('assets/muju.png', height: 100, width: 100, fit: BoxFit.fill,);
                    }
                  }catch(e){
                    print(e.toString());
                  }

                  if(_jsonData.isNotEmpty)
                  {

                    if(memberGubun == "회원")
                    {
                        final assetsAudioPlayer = AssetsAudioPlayer();

                        assetsAudioPlayer.open(
                          Audio("assets/isMember.mp3"),
                        );

                        assetsAudioPlayer.play();  
                    }

                    _jsonData = {};

                    return Container(
                        child:Column(children: [
                          image,
                          DataTable(
                          columns: const [
                            DataColumn(label: Text('구분')),
                            DataColumn(label: Text('데이터')),                          
                          ],
                          rows: [                            
                            DataRow(
                              cells: [ 
                                  const DataCell(Text('카드타입')),
                                  DataCell(Text(cardType)),                                
                            ]
                            ),
                            DataRow(
                              cells: [ 
                                  const DataCell(Text('카드종류')),
                                  DataCell(Text(typeName)),                                
                            ]
                            ),DataRow(
                              cells: [ 
                                  const DataCell(Text('회원여부')),
                                  DataCell(Text(memberGubun)),                                
                            ]
                            ),DataRow(
                              cells: [ 
                                  const DataCell(Text('회원번호')),
                                  DataCell(Text(memberNo)),                                
                            ]
                            ),DataRow(
                              cells: [ 
                                  const DataCell(Text('회원구분')),
                                  DataCell(Text(memberGubun)),                                
                            ]
                            ),DataRow(
                              cells: [ 
                                  const DataCell(Text('회원명')),
                                  DataCell(Text(memberName)),                                
                            ]
                            ),DataRow(
                              cells: [ 
                                  const DataCell(Text('대소구분')),
                                  DataCell(Text(daesoGubun)),                                
                            ]
                            ),DataRow(
                              cells: [ 
                                  const DataCell(Text('사용시작')),
                                  DataCell(Text(fromTime)),                                
                            ]
                            ),DataRow(
                              cells: [ 
                                  const DataCell(Text('사용종료')),
                                  DataCell(Text(toTime)),                                
                            ]
                            ),DataRow(
                              cells: [ 
                                  const DataCell(Text('블랙여부')),
                                  DataCell(Text(blacklist)),                                
                            ]
                            ),DataRow(
                              cells: [ 
                                  const DataCell(Text('사유')),
                                  DataCell(Text(reason)),                                
                            ]
                            ),DataRow(
                              cells: [ 
                                  const DataCell(Text('생년월일')),
                                  DataCell(Text(idNo)),                                
                            ]
                            ),DataRow(
                              cells: [ 
                                  const DataCell(Text('전화번호')),
                                  DataCell(Text(telNo)),                                
                            ]
                            ),
                        
                            ],
                          ),
                        ],)
                          
                    );
                   
                  }else{
                    return const Center(
                      child: Text(
                          ''));
                  }                  
                } else {
                  return const Center(
                      child: Text(
                          ''));
                }
              },
            ),
          ),

        ],
      ),
    );
  }
  

  Future<Map<String, dynamic>> printMember() async{

       if(_isScanning)
      {
        _jsonData = {};        
      }else{
        _jsonData = await post();  
      }      

      return _jsonData;
  }


 Future<Map<String, dynamic>> post() async {
 
    String baseUrl = 'http://61.81.162.4/BarcodeGondola/getBarcodeInfo.asp';
    //identiStr = "9B277B4808";

    print('post() url: $baseUrl');

    if(identiStr == "")
    {
      return {};
    }else{
      http.Response response = await http.post(Uri.parse(baseUrl) ,
          body: {'uid': identiStr});
      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 400 || json == null) {
        //코드 입력
      }   
    
      return json.decode(utf8.decode(response.bodyBytes));
    }
    
  }




  List<Widget> readNdef(NfcTag tag) {
    //Lister les données du tag
    List<Widget> ndefWidgets = [];

    var tech = Ndef.from(tag);
    if (tech is Ndef) {
      final cachedMessage = tech.cachedMessage;
      final canMakeReadOnly = tech.additionalData['canMakeReadOnly'] as bool?;
      final type = tech.additionalData['type'] as String?;
      if (type != null) {
        ndefWidgets.add(ListTile(
            title: const Text('HOHOHO'), subtitle: Text(getNdefType(type))));
      }

      ndefWidgets.add(ListTile(
          title: const Text('Size'),
          subtitle: Text(
              '${cachedMessage?.byteLength ?? 0} / ${tech.maxSize} bytes')));

      ndefWidgets.add(ListTile(
          title: const Text('Writable'), subtitle: Text('${tech.isWritable}')));

      if (canMakeReadOnly != null) {
        ndefWidgets.add(ListTile(
            title: const Text('Can Make Read Only'),
            subtitle: Text('$canMakeReadOnly')));
      }

      if (cachedMessage != null) {
        Iterable.generate(cachedMessage.records.length).forEach((i) {
          final record = cachedMessage.records[i];
          final info = NdefRecordInfo.fromNdef(record);
          ndefWidgets.add(ListTile(
              title: Text('#$i ${info.title}'),
              subtitle: Text(info.subtitle)));
        });
      }
      return ndefWidgets;
    } else {
      return [const Text('No NDEF data found')];
    }
  }

 final Uint8List command = Uint8List.fromList([0x02, 0x23, 0x00, 0x04]);


  //Démarre la session de lecture NFC
  void getNfcData() async {
    bool isAvailable = await NfcManager.instance.isAvailable();

    if (isAvailable) {
      await NfcManager.instance.startSession(onError: (error) async {
        print(error);
        _scannedTag = Future.error(error);
      }, onDiscovered: (NfcTag tag) async {
        setState(() {
          _scannedTag = Future.value(tag);
          _isScanning = false;
        });
        NfcManager.instance.stopSession();
      });
    }
  }


   Future<void> launchNfcSequence1() async {
    await NfcManager.instance.startSession(onDiscovered: (tag) async {
      final nfcV = NfcV.from(tag);
      List<int>? identi = nfcV?.identifier.toList();
      String identiStr1 = identi![0].toRadixString(16).toUpperCase();
      if(identiStr1.length < 2)
      {
        identiStr1 = "0" + identiStr1;
      }
      String identiStr2 = identi![1].toRadixString(16).toUpperCase();
      if(identiStr2.length < 2)
      {
        identiStr2 = "0" + identiStr2;
      }
      String identiStr3 = identi![2].toRadixString(16).toUpperCase();
      if(identiStr3.length < 2)
      {
        identiStr3 = "0" + identiStr3;
      }
      String identiStr4 = identi![3].toRadixString(16).toUpperCase();
      if(identiStr4.length < 2)
      {
        identiStr4 = "0" + identiStr4;
      }
      String identiStr5 = identi![4].toRadixString(16).toUpperCase();
      if(identiStr5.length < 2)
      {
        identiStr5 = "0" + identiStr5;
      }

      identiStr = identiStr1 + identiStr2 + identiStr3 + identiStr4 + identiStr5; 


    
      setState(() {
          _scannedTag = Future.value(tag);
          _isScanning = false;
        });
        NfcManager.instance.stopSession();

    });
  }


  // Transceive command twice
  Future<void> sequence(NfcV nfcV) async {
    try {
      final answer1 = await nfcV.transceive(data: command);      
      print(answer1.toString());      

      if(answer1[3] == 1)
      {
        isMember = true;
      }else{
        isMember = false;
      }

    } catch (e) {
      print(e);
      rethrow;
    }
  }

}
