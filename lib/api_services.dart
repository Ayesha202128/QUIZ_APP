import 'dart:convert';


import 'package:http/http.dart' as http;          //http pkg er name http

var link = "https://opentdb.com/api.php?amount=20";           //link teke 20 question niye asbe

getQuiz() async {
  var res = await http.get(Uri.parse(link));
  if (res.statusCode == 200) {                                 //check korce j server teke sotik response hoice ki na
    var data = jsonDecode(res.body.toString());
    print("data is loaded");
    return data;
  }
}
