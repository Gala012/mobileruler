import 'dart:math' as math;

class CameraScale {
  CameraScale._();

  static const fovDeg = 55.0;

  static double focalLengthPx(double sceneHeight) {
    return sceneHeight / (2 * math.tan(fovDeg * math.pi / 360));
  }

  static double metersPerPixel(double distanceM, double sceneHeight) {
    if (distanceM <= 0 || sceneHeight <= 0) return 0;
    return distanceM / focalLengthPx(sceneHeight);
  }

  static double pxAreaToMm2(double px2, double distanceM, double sceneHeight) {
    final mpp = metersPerPixel(distanceM, sceneHeight);
    if (mpp <= 0) return 0;
    return px2 * mpp * mpp * 1e6;
  }
}
