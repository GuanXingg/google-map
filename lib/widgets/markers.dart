import 'package:google_maps_flutter/google_maps_flutter.dart';

Marker customMarker(String id, LatLng pos,
    {String? title, String? subTitle, double color = BitmapDescriptor.hueViolet, void Function(LatLng)? onTap}) {
  return Marker(
    markerId: MarkerId(id),
    position: pos,
    infoWindow: InfoWindow(title: title, snippet: subTitle),
    icon: BitmapDescriptor.defaultMarkerWithHue(color),
    onTap: () => (onTap == null) ? null : onTap(pos),
  );
}
