import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart';
class BaseData{
  Color basecolor = Colors.purple;

  Future<String> postChat(String text) async{
    try{
      Response response = await post(Uri.parse('https://api.openai.com/v1/chat/completions'), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${dotenv.env['token']}'
      },body: jsonEncode({
        "model": "gpt-3.5-turbo-1106",
        "response_format": { "type": "text" },
        "messages": [
          {
            "role": "system",
            "content": "You are a helpful assistant designed to output JSON."
          },
          {
            "role": "user",
            "content": text
          }
        ]
      }));
      debugPrint(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint(response.body);
        return response.body;
      } else {
        debugPrint("server response : ${response.statusCode}");
        const data = {'status':'failed','response':'Failed to connect to server'};
        return jsonEncode(data);
      }
    }on Exception catch(e){
      EasyLoading.dismiss();
      EasyLoading.showError("Failed to connect");
      return "0";
    }

  }
}