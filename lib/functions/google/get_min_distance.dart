import 'package:google_map/utils/calculate_distance.dart';

PointDistance getMinDistance(List<PointDistance> pointList) {
  PointDistance minPoint = pointList.first;
  double minDis = double.infinity;

  for (PointDistance pointEl in pointList) {
    if (pointEl.distance < minDis) {
      minDis = pointEl.distance;
      minPoint = pointEl;
    }
  }

  return minPoint;
}
