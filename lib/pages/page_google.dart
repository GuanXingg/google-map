import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_routes/google_maps_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/google/dialog_point_in_zone.dart';
import '../components/google/dialog_settings.dart';
import '../components/google/speed_dial.dart';
import '../constants/const_color.dart';
import '../constants/const_map.dart';
import '../constants/const_space.dart';
import '../functions/google/check_in_zone.dart';
import '../functions/google/get_all_zone_point.dart';
import '../functions/google/get_bound_view.dart';
import '../functions/google/get_min_distance.dart';
import '../functions/google/load_coupon_data.dart';
import '../functions/google/load_zone_data.dart';
import '../models/model_coupon.dart';
import '../models/model_point.dart';
import '../models/model_zone.dart';
import '../utils/calculate_distance.dart';
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
  final MapsRoutes mapRoutes = MapsRoutes();

  final Set<Marker> markers = {};
  final Set<Circle> circles = {};
  final Set<Polygon> polygons = {};
  final List<PointModel> availPointList = [];

  bool hasCouponInZone = false;
  LatLng? availPoint;
  LatLng? _initPos;
  List<ZoneModel> zoneDataList = [];
  List<CouponModel> couponDataList = [];

  void clearShape({
    bool marker = true,
    bool circle = true,
    bool polyline = true,
    bool polygon = true,
    bool availPoint = true,
  }) {
    if (marker) markers.clear();
    if (circle) circles.clear();
    if (polyline) mapRoutes.routes.clear();
    if (polygon) polygons.clear();
    if (availPoint) availPointList.clear();
  }

  Future<void> _loadData() async {
    try {
      final currentPos = await getCurrentLocation();
      final List<ZoneModel>? newZoneDataList = await firstLoadZoneData();
      final List<CouponModel>? newCouponDataList = await firstLoadCouponData();

      setState(() {
        _initPos = currentPos;
        if (newZoneDataList != null) zoneDataList = newZoneDataList;
        if (newCouponDataList != null) couponDataList = newCouponDataList;
      });
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

      List<CouponModel> newCouponDataList = [];
      final Map<String, dynamic>? couponFile = await parseJsonFileFromAssets('assets/data/fake_data.json');
      if (couponFile != null) newCouponDataList = await handleCouponFile(couponFile);

      for (ZoneModel zoneEl in newZoneDataList) {
        polygons.add(customPolygon('pos-${zoneEl.name}', zoneEl.color, zoneEl.zone));
        for (PointModel pointEl in zoneEl.pointList) markers.add(customMarker('pos-${pointEl.name}', pointEl.point));
      }

      final List<LatLng> allZonePoint = getAllPointZone(newZoneDataList);
      final LatLngBounds bounds = getBoundView(allZonePoint);
      controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 30));

      setState(() {
        zoneDataList = newZoneDataList;
        couponDataList = newCouponDataList;
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
      final SharedPreferences shared = await SharedPreferences.getInstance();
      onTapCurrentLocation();

      await shared.remove('zoneData');
      await shared.remove('couponData');

      setState(() {
        zoneDataList.clear();
        couponDataList.clear();
        Navigator.popUntil(context, ModalRoute.withName('/'));
      });
    } catch (err) {
      CLogger().error('>>> An occurred while delete file zone KML!!!, log: $err');
      CAlert.error(context, content: 'Can not delete file');
    }
  }

  Future<void> onTapShowAllArea() async {
    clearShape();

    if (zoneDataList.isEmpty) {
      CLogger().error('>>> An occurred while zone data is empty!!!');
      CAlert.error(context, content: 'Please import file zone KML data first');
      return;
    }

    try {
      final GoogleMapController controller = await kGgController.future;

      for (ZoneModel zoneEl in zoneDataList) {
        polygons.add(customPolygon('poly-${zoneEl.name}', zoneEl.color, zoneEl.zone));
        for (PointModel pointEl in zoneEl.pointList)
          markers.add(customMarker('pos-${pointEl.name}', pointEl.point, title: pointEl.name));
      }

      final List<LatLng> allZonePoint = getAllPointZone(zoneDataList);
      final LatLngBounds bounds = getBoundView(allZonePoint);
      controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 30));

      setState(() {});
    } catch (err) {
      CLogger().error('>>> An occurred while get all zone data!!!, log: $err');
      CAlert.error(context, content: 'Can not load all zone available');
    }
  }

  Future<void> onTapGetClosestZone() async {
    clearShape();

    if (zoneDataList.isEmpty) {
      CLogger().error('>>> An occurred while zone data is empty!!!');
      CAlert.error(context, content: 'Please import file zone KML data first');
      return;
    }

    try {
      final GoogleMapController controller = await kGgController.future;
      final LatLng currentPos = await getCurrentLocation();
      final List<PointDistance> pointInZoneDistanceList = [];

      bool newHasCouponInZone = false;

      int indexClosestZone = checkPointInZone(currentPos, zoneDataList);
      if (indexClosestZone < 0) {
        final List<LatLng> allZonePoint = getAllPointZone(zoneDataList);
        final List<PointDistance> pointZoneDistanceList = [];
        for (LatLng zonePointEl in allZonePoint) {
          final PointDistance pointZoneDistanceEl = await calculateDistance(currentPos, zonePointEl);
          pointZoneDistanceList.add(pointZoneDistanceEl);
        }
        PointDistance minPoint = getMinDistance(pointZoneDistanceList);
        indexClosestZone = checkPointInZone(minPoint.point, zoneDataList);
      }

      final List<LatLng> allPointInZone = getAllPointInZone(zoneDataList[indexClosestZone]);
      for (LatLng zonePointEl in allPointInZone) {
        PointDistance pointZoneDistanceEl = await calculateDistance(currentPos, zonePointEl);
        pointInZoneDistanceList.add(pointZoneDistanceEl);
      }

      polygons.add(customPolygon(
        'poly-${zoneDataList[indexClosestZone].name}',
        zoneDataList[indexClosestZone].color,
        zoneDataList[indexClosestZone].zone,
      ));

      pointInZoneDistanceList.sort((a, b) => a.distance.compareTo(b.distance));
      for (PointModel pointEl in zoneDataList[indexClosestZone].pointList) {
        final List<CouponModel> couponList = [];
        for (CouponModel couponEl in couponDataList) {
          if (couponEl.place == pointEl.name) couponList.add(couponEl);
        }

        if (couponList.isNotEmpty) {
          availPointList.add(PointModel(name: pointEl.name, point: pointEl.point, couponList: couponList));
          if (!newHasCouponInZone) newHasCouponInZone = true;
        } else
          availPointList.add(pointEl);

        for (int i = 0; i < pointInZoneDistanceList.length; i++) {
          if (pointInZoneDistanceList[i].point.latitude == pointEl.point.latitude &&
              pointInZoneDistanceList[i].point.longitude == pointEl.point.longitude) {
            if (i == 0)
              markers.add(customMarker(
                'pos-${pointEl.name}',
                pointEl.point,
                title: '${pointEl.name} (Suggest place)',
                subTitle: pointInZoneDistanceList[i].description,
                color: BitmapDescriptor.hueGreen,
                onTap: onTapSelectPlace,
              ));
            else
              markers.add(customMarker(
                'pos-${pointEl.name}',
                pointEl.point,
                title: pointEl.name,
                subTitle: pointInZoneDistanceList[i].description,
                onTap: onTapSelectPlace,
              ));
          }
        }
      }

      final List<LatLng> boundPoints = [];
      boundPoints.add(currentPos);
      for (LatLng zonePoint in zoneDataList[indexClosestZone].zone) boundPoints.add(zonePoint);
      final LatLngBounds bounds = getBoundView(boundPoints);
      controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 30));

      setState(() => hasCouponInZone = newHasCouponInZone);
    } catch (err) {
      CLogger().error('>>> An occurred while find closest zone!!!, log: $err');
      CAlert.error(context, content: 'Can not find closest area');
    }
  }

  void onTapSelectPlace(LatLng pos) {
    setState(() => availPoint = pos);
  }

  Future<void> onTapDrawRoute() async {
    clearShape(availPoint: false, marker: false, polygon: false);

    try {
      if (availPoint == null) throw 'Can not find destination coordinate';
      final GoogleMapController controller = await kGgController.future;

      final LatLng currentPos = await getCurrentLocation();
      await mapRoutes.drawRoute([currentPos, availPoint!], '', Colors.blue, AppMap.googleKey);

      final LatLngBounds bounds = getBoundView([currentPos, availPoint!]);
      controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));

      setState(() {});
    } catch (err) {
      CLogger().error('>>> An occurred while draw route to destination!!!, log: $err');
      CAlert.error(context, content: 'Can not identify routes to destination');
    }
  }

  Future<void> onTapMoveToPlace(LatLng point) async {
    clearShape(availPoint: false, marker: false, polygon: false, polyline: false);
    try {
      final GoogleMapController controller = await kGgController.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: point, zoom: 16)));
      setState(() => Navigator.popUntil(context, ModalRoute.withName('/')));
    } catch (err) {
      CLogger().error('>>> An occurred while move camera to place!!!, log: $err');
      CAlert.error(context, content: '>>> Can not move to place');
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
      polylines: mapRoutes.routes,
      polygons: polygons,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      onTap: (_) => setState(() => availPoint = null),
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
    );
  }

  Positioned _settingFunction() {
    return Positioned(
      top: 60,
      right: 20,
      child: Column(children: [
        FunctionItem(
          onTap: () => showDialog(
            context: context,
            builder: (context) => DialogSettings(
              onTapImportFile: onTapImportZoneData,
              onTapDeleteFile: onTapClearZoneData,
            ),
          ),
          icon: Icons.settings,
        ),
        const SizedBox(height: AppSpace.primary),
        if (availPointList.isNotEmpty)
          FunctionItem(
            icon: Icons.location_on_rounded,
            iconColor: (hasCouponInZone) ? AppColor.primary : null,
            onTap: () => showDialog(
              context: context,
              builder: (context) => DialogPointInZone(pointList: availPointList, onTap: onTapMoveToPlace),
            ),
          )
      ]),
    );
  }

  Positioned _mapFunction() {
    return Positioned(
      right: 20,
      bottom: 20,
      child: Column(children: [
        if (availPoint != null) ...[
          FunctionItem(
            onTap: onTapDrawRoute,
            size: 56,
            color: Colors.red,
            iconColor: Colors.white,
            icon: Icons.directions,
          ),
          const SizedBox(height: AppSpace.primary),
        ],
        FunctionItem(onTap: onTapCurrentLocation, size: 56, icon: Icons.location_searching),
        const SizedBox(height: AppSpace.primary),
        MapSpeedDial(
          onTapShowAllZone: onTapShowAllArea,
          onTapClosestZone: onTapGetClosestZone,
        ),
      ]),
    );
  }
}
