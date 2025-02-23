import 'dart:math';

class CoordinateConverter {
  static const double pi = 3.14159265358979324;
  static const double xPi = (pi * 3000.0) / 180.0;
  static const double a = 6378245.0;
  static const double ee = 0.00669342162296594323;

  static bool _outOfChina(double lat, double lon) {
    if (lon < 72.004 || lon > 137.8347) return true;
    if (lat < 0.8293 || lat > 55.8271) return true;
    return false;
  }

  static double _transformLat(double x, double y) {
    double ret = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(x.abs());
    ret += (20.0 * sin(6.0 * x * pi) + 20.0 * sin(2.0 * x * pi)) * 2.0 / 3.0;
    ret += (20.0 * sin(y * pi) + 40.0 * sin(y / 3.0 * pi)) * 2.0 / 3.0;
    ret += (160.0 * sin(y / 12.0 * pi) + 320 * sin(y * pi / 30.0)) * 2.0 / 3.0;
    return ret;
  }

  static double _transformLon(double x, double y) {
    double ret = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(x.abs());
    ret += (20.0 * sin(6.0 * x * pi) + 20.0 * sin(2.0 * x * pi)) * 2.0 / 3.0;
    ret += (20.0 * sin(x * pi) + 40.0 * sin(x / 3.0 * pi)) * 2.0 / 3.0;
    ret += (150.0 * sin(x / 12.0 * pi) + 300.0 * sin(x / 30.0 * pi)) * 2.0 / 3.0;
    return ret;
  }

  static (double, double) wgs84ToGcj02(double wgslat, double wgslon) {
    if (_outOfChina(wgslat, wgslon)) return (wgslat, wgslon);

    double dlat = _transformLat(wgslon - 105.0, wgslat - 35.0);
    double dlng = _transformLon(wgslon - 105.0, wgslat - 35.0);
    double radlat = wgslat / 180.0 * pi;
    double magic = 1 - ee * sin(radlat) * sin(radlat);
    double sqrtmagic = sqrt(magic);
    dlat = (dlat * 180.0) / ((a * (1 - ee)) / (magic * sqrtmagic) * pi);
    dlng = (dlng * 180.0) / (a / sqrtmagic * cos(radlat) * pi);
    double mglat = wgslat + dlat;
    double mglng = wgslon + dlng;
    return (mglat, mglng);
  }
}
