import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../models/model_point.dart';
import '../../models/model_zone.dart';

List<LatLng> getAllPointZone(List<ZoneModel> zoneDataList) {
  final List<LatLng> allZonePoint = [];
  for (ZoneModel el in zoneDataList) {
    for (LatLng zoneEl in el.zone) allZonePoint.add(zoneEl);
  }

  return allZonePoint;
}

List<LatLng> getAllPointInZone(ZoneModel zoneData) {
  final List<LatLng> allZonePoint = [];
  for (PointModel el in zoneData.pointList) allZonePoint.add(el.point);

  return allZonePoint;
}
