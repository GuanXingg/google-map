import 'dart:convert';

import 'package:xml2json/xml2json.dart';

Future<Map<String, dynamic>> parseKml2Json(String rawFile) async {
  final Xml2Json xml2json = Xml2Json();

  xml2json.parse(rawFile);
  String fileToParker = xml2json.toParker();
  
  return jsonDecode(fileToParker);
}
