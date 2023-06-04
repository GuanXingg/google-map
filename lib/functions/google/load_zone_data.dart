import 'dart:async';
import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/model_zone.dart';
import '../../utils/custom_logger.dart';
import '../../utils/point_in_polygon.dart';

Future<List<ZoneModel>> handleZoneFile(Map<String, dynamic> file) async {
  final SharedPreferences shared = await SharedPreferences.getInstance();

  final List<Map<String, dynamic>> rawZoneDataList = [];
  final List<Map<String, dynamic>> rawPointDataList = [];
  final List<Map<String, dynamic>> pointDataList = [];
  final List<Map<String, dynamic>> zoneDataList = [];

  final List<dynamic> placeMark = file['kml']['Document']['Placemark'];
  for (dynamic el in placeMark) {
    final dynamic isPolygonEl = el['Polygon'];
    if (isPolygonEl == null)
      rawPointDataList.add(el);
    else
      rawZoneDataList.add(el);
  }

  for (dynamic el in rawPointDataList) {
    final String rawPoint = el['Point']['coordinates'].trim();
    final List<String> splitRawPoint = rawPoint.split(',');

    final Map<String, dynamic> item = {
      'name': el['name'],
      'point': LatLng(double.parse(splitRawPoint[1]), double.parse(splitRawPoint[0])),
    };
    pointDataList.add(item);
  }

  for (dynamic el in rawZoneDataList) {
    final String rawColor = el['styleUrl'].trim();
    final String splitColor = rawColor.split('-')[1];

    final String rawZone = el['Polygon']['outerBoundaryIs']['LinearRing']['coordinates'].trim();
    final List<String> splitRawZone = rawZone.split(' ').where((e) => e.isNotEmpty).toList();
    final List<List<String>> splitZoneItem = splitRawZone.map((e) => e.split(',')).toList();
    final List<LatLng> zone = splitZoneItem.map((e) => LatLng(double.parse(e[1]), double.parse(e[0]))).toList();

    final List<Map<String, dynamic>> pointList = [];
    for (Map<String, dynamic> pointEl in pointDataList) {
      final bool checked = checkPointInPolygon(pointEl['point'], zone);
      if (checked) pointList.add(pointEl);
    }

    final Map<String, dynamic> item = {
      'name': el['name'],
      'color': '0xFF$splitColor',
      'zone': zone,
      'pointList': pointList,
    };
    zoneDataList.add(item);
  }

  final List<Map<String, dynamic>> storeZoneDataList = zoneDataList;
  final String encodeZoneDataList = jsonEncode(storeZoneDataList);
  await shared.setString('zoneData', encodeZoneDataList);

  return zoneDataList.map((e) => ZoneModel.fromJson(e)).toList();
}

Future<List<ZoneModel>?> firstLoadZoneData() async {
  final SharedPreferences shared = await SharedPreferences.getInstance();
  final List<ZoneModel> zoneDataList = [];

  final String? rawZoneData = shared.getString('zoneData');
  if (rawZoneData == null) return null;

  final List<dynamic> parseZoneData = jsonDecode(rawZoneData);
  for (dynamic el in parseZoneData) {
    final List<LatLng> zone = [];
    for (dynamic zoneEl in el['zone']) zone.add(LatLng(zoneEl[0], zoneEl[1]));

    final List<Map<String, dynamic>> pointList = [];
    for (dynamic pointEl in el['pointList']) {
      final Map<String, dynamic> item = {
        'name': pointEl['name'],
        'point': LatLng(pointEl['point'][0], pointEl['point'][1]),
      };
      pointList.add(item);
    }

    final Map<String, dynamic> item = {
      'name': el['name'],
      'color': el['color'],
      'zone': zone,
      'pointList': pointList,
    };

    zoneDataList.add(ZoneModel.fromJson(item));
  }

  return zoneDataList;
}
