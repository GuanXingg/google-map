import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../models/model_zone.dart';
import '../../utils/point_in_polygon.dart';

int checkPointInZone(LatLng currentPos, List<ZoneModel> zoneDataList) {
  for (int i = 0; i < zoneDataList.length; i++) {
    bool checked = checkPointInPolygon(currentPos, zoneDataList[i].zone);
    if (checked) return i;
  }

  return -1;
}
