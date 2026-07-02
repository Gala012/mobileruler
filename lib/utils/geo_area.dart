import 'dart:math' as math;

class GeoPoint {
  const GeoPoint({required this.latitude, required this.longitude});

  final double latitude;
  final double longitude;
}

class GeoArea {
  GeoArea._();

  static double polygonAreaM2(List<GeoPoint> points) {
    if (points.length < 3) return 0;

    final refLat = points.fold<double>(0, (s, p) => s + p.latitude) / points.length;
    final refLon = points.fold<double>(0, (s, p) => s + p.longitude) / points.length;
    final latRad = refLat * math.pi / 180;
    final mPerDegLat = 111132.954 - 559.822 * math.cos(2 * latRad) + 1.175 * math.cos(4 * latRad);
    final mPerDegLon = 111132.954 * math.cos(latRad);

    final xs = <double>[];
    final ys = <double>[];
    for (final p in points) {
      xs.add((p.longitude - refLon) * mPerDegLon);
      ys.add((p.latitude - refLat) * mPerDegLat);
    }

    var sum = 0.0;
    for (var i = 0; i < xs.length; i++) {
      final j = (i + 1) % xs.length;
      sum += xs[i] * ys[j] - xs[j] * ys[i];
    }
    return sum.abs() / 2;
  }

  static double distanceM(GeoPoint a, GeoPoint b) {
    const earthRadius = 6371000.0;
    final dLat = (b.latitude - a.latitude) * math.pi / 180;
    final dLon = (b.longitude - a.longitude) * math.pi / 180;
    final lat1 = a.latitude * math.pi / 180;
    final lat2 = b.latitude * math.pi / 180;
    final h = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1) * math.cos(lat2) * math.sin(dLon / 2) * math.sin(dLon / 2);
    return 2 * earthRadius * math.asin(math.sqrt(h));
  }
}
