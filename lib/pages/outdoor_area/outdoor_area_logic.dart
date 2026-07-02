import 'dart:async';
import 'package:flutter/services.dart';
import 'package:mobilem/components/app_feedback.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:mobilem/components/bottom_sheet_helper.dart';
import 'package:mobilem/db_mobilem/db_mobilem_entity.dart';
import 'package:mobilem/db_mobilem/db_mobilem_helper.dart';
import 'package:mobilem/lang/lang.dart';
import 'package:mobilem/services/app_data_service.dart';
import 'package:mobilem/utils/geo_area.dart';

enum OutdoorTrackState { idle, tracking, done }

class OutdoorAreaLogic extends GetxController {
  static const _minSampleM = 2.0;
  static const _closeRadiusM = 8.0;
  static const _minPointsToClose = 4;

  final trackState = OutdoorTrackState.idle.obs;
  final points = <GeoPoint>[].obs;
  final areaM2 = 0.0.obs;
  final pointCount = 0.obs;
  final statusText = ''.obs;

  StreamSubscription<Position>? _sub;

  @override
  void onInit() {
    super.onInit();
    DbMobilemHelper.instance.incrementUsage('outdoor_area');
    statusText.value = Lang.outdoorAreaIdle;
  }

  @override
  void onClose() {
    _stopStream();
    super.onClose();
  }

  Future<void> startTracking() async {
    final ok = await _ensurePermission();
    if (!ok) return;

    _stopStream();
    points.clear();
    areaM2.value = 0;
    pointCount.value = 0;
    trackState.value = OutdoorTrackState.tracking;
    statusText.value = Lang.outdoorAreaTracking;

    try {
      _sub = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 2,
        ),
      ).listen(
        _onPosition,
        onError: (_) => _handleLocationFailure(),
      );
    } on MissingPluginException {
      _handleLocationFailure();
    } on PlatformException {
      _handleLocationFailure(permission: true);
    } catch (_) {
      _handleLocationFailure();
    }
  }

  Future<void> finishTracking() async {
    if (trackState.value != OutdoorTrackState.tracking) return;
    _stopStream();
    _finalizePolygon();
  }

  void reset() {
    _stopStream();
    points.clear();
    areaM2.value = 0;
    pointCount.value = 0;
    trackState.value = OutdoorTrackState.idle;
    statusText.value = Lang.outdoorAreaIdle;
  }

  Future<bool> _ensurePermission() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        statusText.value = Lang.outdoorAreaPermissionDenied;
        return false;
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        statusText.value = Lang.outdoorAreaPermissionDenied;
        return false;
      }
      return true;
    } on MissingPluginException {
      statusText.value = Lang.outdoorAreaLocationUnavailable;
      return false;
    } on PlatformException {
      statusText.value = Lang.outdoorAreaPermissionDenied;
      return false;
    } catch (_) {
      statusText.value = Lang.outdoorAreaLocationUnavailable;
      return false;
    }
  }

  void _handleLocationFailure({bool permission = false}) {
    _stopStream();
    trackState.value = OutdoorTrackState.idle;
    statusText.value =
        permission ? Lang.outdoorAreaPermissionDenied : Lang.outdoorAreaLocationUnavailable;
  }

  void _onPosition(Position position) {
    final next = GeoPoint(latitude: position.latitude, longitude: position.longitude);
    if (points.isNotEmpty) {
      final last = points.last;
      if (GeoArea.distanceM(last, next) < _minSampleM) return;
    }
    points.add(next);
    pointCount.value = points.length;

    if (points.length >= _minPointsToClose) {
      final distToStart = GeoArea.distanceM(points.first, next);
      if (distToStart <= _closeRadiusM) {
        _stopStream();
        _finalizePolygon(autoClosed: true);
      }
    }
  }

  void _finalizePolygon({bool autoClosed = false}) {
    if (points.length < 3) {
      trackState.value = OutdoorTrackState.idle;
      statusText.value = Lang.outdoorAreaNeedMorePoints;
      return;
    }
    areaM2.value = GeoArea.polygonAreaM2(points.toList());
    trackState.value = OutdoorTrackState.done;
    statusText.value = autoClosed
        ? Lang.outdoorAreaClosed
        : '${Lang.outdoorAreaResult}: ${areaM2.value.toStringAsFixed(2)} m²';
  }

  void _stopStream() {
    _sub?.cancel();
    _sub = null;
  }

  String get areaText => areaM2.value > 0 ? areaM2.value.toStringAsFixed(2) : '--';

  String get muText => areaM2.value > 0 ? (areaM2.value / 666.67).toStringAsFixed(2) : '--';

  Future<void> save() async {
    if (areaM2.value <= 0) return;
    final note = await showNoteInputSheet() ?? '';
    await Get.find<AppDataService>().saveMeasurement(
      MeasurementRecordEntity(
        toolType: 'outdoor_area',
        value: double.parse(areaM2.value.toStringAsFixed(2)),
        unit: 'm²',
        note: note,
        createdAt: DateTime.now().toIso8601String(),
      ),
    );
    AppToast.success(Lang.outdoorAreaSaved);
    reset();
  }
}
