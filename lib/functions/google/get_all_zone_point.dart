import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../models/model_zone.dart';

List<LatLng> getAllPointInZone(List<ZoneModel> zoneDataList) {
  final List<LatLng> allZonePoint = [];
  for (ZoneModel el in zoneDataList) {
    for (LatLng zoneEl in el.zone) allZonePoint.add(zoneEl);
  }

  return allZonePoint;
}
