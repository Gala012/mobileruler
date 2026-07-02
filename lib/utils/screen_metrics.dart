import 'dart:io';
import 'dart:ui' as ui;

class ScreenMetrics {
  static double devicePixelRatio() {
    final dispatcher = ui.PlatformDispatcher.instance;
    final view = dispatcher.implicitView ??
        (dispatcher.views.isNotEmpty ? dispatcher.views.first : null);
    return view?.devicePixelRatio ?? 3.0;
  }

  static double autoPixelsPerMm() {
    final pixelsPerInch = Platform.isIOS ? 163.0 : 160.0;
    return pixelsPerInch / 25.4;
  }
}
