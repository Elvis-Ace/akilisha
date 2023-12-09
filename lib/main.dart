import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:masaidizi/widgets/mybutton.dart';
import 'package:masaidizi/widgets/mytext.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:contacts_service/contacts_service.dart';

import 'base/BaseData.dart';
import 'base/httpdio.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Akilisha',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Akilisha'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  BaseData baseData = BaseData();
  late AudioRecorder record;
  HttpDio httpDio = HttpDio();
  FlutterTts flutterTts = FlutterTts();
  late List<Contact> contacts;
  late List<Contact> search;
  String audio = "";
  String said = "";
  recordaudio()async{
    record = AudioRecorder();
    audio = "";
    final Directory tempDir = await getTemporaryDirectory();
    if (await record.hasPermission()) {
      // Start recording to file
      await record.start(const RecordConfig(), path: '${tempDir.path}/audio.flac');
    }
  }

  stoprecording()async{
    // Stop recording...
    final path = await record.stop();
    audio = path!;
    record.dispose(); // As always, don't forget this one.
    setState(() {

    });
  }

  playrecording()async{
    if(audio.isEmpty){
      EasyLoading.showError("No audio available");
    }else{
      final player = AudioPlayer();
      await player.play(DeviceFileSource(audio));
    }

  }
  askquestion()async{
    await flutterTts.setLanguage("sw-KE");

    await flutterTts.setSpeechRate(0.5);

    await flutterTts.setVolume(1.0);

    await flutterTts.setPitch(1.0);
    var result = await flutterTts.speak("Habari ya Asubuhi? Kwa majina naitwa Akilisha. Naweza Kukusaidia aje leo..?");
  }
  sendaudio()async{
    if(audio.isNotEmpty){
      EasyLoading.show(status: "Fetching Data please wait");
      var data = await httpDio.uploadaudio(audio);
      if(data['text'] != null){
        said = data['text'];
        //addquery("Swahili Complaint", DateTime.now().toString(), data['text']);
        setState(() {

        });
        await translate(data['text']);
      }else{
        EasyLoading.showError(data['error']);
      }
      debugPrint('response : ${data.toString()}');
    }else{
      EasyLoading.showError("No audio recorded");
    }

  }

  playbeep()async{
    final player = AudioPlayer();
    await player.play(AssetSource('beep.wav'));
  }

  translate(String dta)async{
    EasyLoading.show(status: "Translating");
    String text = "$dta. Translate to english";
    var response = jsonDecode(await baseData.postChat(text));
    debugPrint(response.toString());
    EasyLoading.dismiss();
    //addquery("Translated", DateTime.now().toString(), response['choices'][0]['message']['content']);
  }


  loadcontacts()async{
    if(await Permission.contacts.request().isGranted){
      List<Contact> contacts = await ContactsService.getContacts(withThumbnails: false);
      //List<Contact> johns = await ContactsService.getContacts(query : "john");
    }

  }
  @override
  void initState() {
    loadcontacts();
    //askquestion();
    //playbeep();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MyTextView(data: said),
            SizedBox(height: 10,),
            RoundButton(Icons.mic, Colors.white, Colors.purple, (){
              playbeep();
              debugPrint('Pressed');
            },size: 80,)
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
