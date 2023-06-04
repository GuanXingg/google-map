import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../components/google/dialog_settings.dart';
import '../constants/const_color.dart';
import '../functions/google/get_all_zone_point.dart';
import '../functions/google/get_bound_view.dart';
import '../functions/google/load_zone_data.dart';
import '../models/model_point.dart';
import '../models/model_zone.dart';
import '../utils/current_location.dart';
import '../utils/custom_logger.dart';
import '../utils/parse_file_json.dart';
import '../utils/read_kml_file.dart';
import '../widgets/circles.dart';
import '../widgets/custom_alert.dart';
import '../widgets/function_item.dart';
import '../widgets/markers.dart';
import '../widgets/polygons.dart';

class GooglePage extends StatefulWidget {
  const GooglePage({super.key});

  @override
  State<GooglePage> createState() => _GooglePageState();
}

class _GooglePageState extends State<GooglePage> {
  final Completer<GoogleMapController> kGgController = Completer<GoogleMapController>();

  final Set<Marker> markers = {};
  final Set<Circle> circles = {};
  final Set<Polyline> polylines = {};
  final Set<Polygon> polygons = {};

  LatLng? _initPos;
  List<ZoneModel> zoneDataList = [];

  void clearShape({bool marker = true, bool circle = true, bool polyline = true, bool polygon = true}) {
    if (marker) markers.clear();
    if (circle) circles.clear();
    if (polyline) polylines.cast();
    if (polygon) polygons.clear();
  }

  Future<void> _loadData() async {
    try {
      final currentPos = await getCurrentLocation();
      setState(() => _initPos = currentPos);
    } catch (err) {
      CLogger().error('>>> An occurred while load app resources!!!, log: $err');
      setState(() => _initPos = const LatLng(0, 0));
    }
  }

  Future<void> onTapCurrentLocation() async {
    clearShape();

    try {
      final GoogleMapController controller = await kGgController.future;
      final LatLng currentPos = await getCurrentLocation();

      circles.add(currentCircle(currentPos));
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: currentPos, zoom: 16)));
      setState(() {});
    } catch (err) {
      CLogger().error('>>> An occurred while get current location!!!, log: $err');
      CAlert.error(context, content: 'Something went wrong, can not find your location!');
    }
  }

  Future<void> onTapImportZoneData() async {
    clearShape();

    try {
      final GoogleMapController controller = await kGgController.future;

      final String rawFile = await readKmlFile();
      final Map<String, dynamic> file = await parseKml2Json(rawFile);
      final List<ZoneModel> newZoneDataList = await handleZoneFile(file);

      for (ZoneModel zoneEl in newZoneDataList) {
        polygons.add(customPolygon('pos-${zoneEl.name}', zoneEl.color, zoneEl.zone));
        for (PointModel pointEl in zoneEl.pointList) markers.add(customMarker('pos-${pointEl.name}', pointEl.point));
      }

      List<LatLng> allZonePoint = getAllPointInZone(newZoneDataList);
      LatLngBounds bounds = getBoundView(allZonePoint);
      controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 30));

      setState(() {
        zoneDataList = newZoneDataList;
        Navigator.pop(context);
      });
    } catch (err) {
      CLogger().error('>>> An occurred while import file KML and load it!!!, log: $err');
      CAlert.error(context, content: 'Can not import file');
    }
  }

  Future<void> onTapClearZoneData() async {
    clearShape();

    try {
      onTapCurrentLocation();

      setState(() {
        zoneDataList.clear();
        Navigator.popUntil(context, ModalRoute.withName('/'));
      });
    } catch (err) {
      CLogger().error('>>> An occurred while delete file zone KML!!!, log: $err');
      CAlert.error(context, content: 'Can not delete file');
    }
  }

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (_initPos == null)
          ? SpinKitRing(color: AppColor.highlight)
          : Stack(children: [
              _googleMap(),
              _settingFunction(),
              _mapFunction(),
            ]),
    );
  }

  // * ========== Parent widget ==========
  GoogleMap _googleMap() {
    return GoogleMap(
      initialCameraPosition: CameraPosition(target: _initPos!, zoom: 15),
      onMapCreated: (controller) => kGgController.complete(controller),
      markers: markers,
      circles: circles,
      polylines: polylines,
      polygons: polygons,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
    );
  }

  Positioned _settingFunction() {
    return Positioned(
      top: 60,
      right: 20,
      child: FunctionItem(
        onTap: () => showDialog(
          context: context,
          builder: (context) => DialogSettings(
            onTapImportFile: onTapImportZoneData,
            onTapDeleteFile: onTapClearZoneData,
          ),
        ),
        icon: Icons.settings,
      ),
    );
  }

  Positioned _mapFunction() {
    return Positioned(
      right: 20,
      bottom: 20,
      child: FunctionItem(onTap: onTapCurrentLocation, size: 60, icon: Icons.near_me),
    );
  }
}
