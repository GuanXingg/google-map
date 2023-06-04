import 'dart:io';

import 'package:file_picker/file_picker.dart';

Future<String> readKmlFile() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['kml']);
  if (result == null) return Future.error('Can not get file KML extensions');

  String? filePath = result.files.first.path;
  if (filePath == null) return Future.error('Can not find file path');

  File file = File(filePath);
  return file.readAsString();
}
