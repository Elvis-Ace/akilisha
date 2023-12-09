import 'dart:io';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class HttpDio{
  uploadaudio(String path)async{

    String apiUrl = 'https://api-inference.huggingface.co/models/Joshua-Abok/finetuned_wav2vec_asr'; // Replace with your server endpoint

    try{
      Response response = await post(Uri.parse(apiUrl),body: File(path).readAsBytesSync(),headers: {
        'Authorization':'Bearer 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'
      });
      EasyLoading.dismiss();
      debugPrint(response.body);
      return jsonDecode(response.body);
    }on Exception catch(e){
      EasyLoading.dismiss();
      EasyLoading.showError("Failed to connect");
      return "0";
    }
  }
}