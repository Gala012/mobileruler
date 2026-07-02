import 'package:flutter/material.dart';

class ToolIcons {
  ToolIcons._();

  static const IconData ruler = Icons.straighten_rounded;
  static const IconData tapeRuler = Icons.add_chart_rounded;
  static const IconData scaleRuler = Icons.aspect_ratio_rounded;
  static const IconData dividerRuler = Icons.view_week_rounded;
  static const IconData unitConverter = Icons.swap_horiz_rounded;
  static const IconData protractor = Icons.change_history_rounded;
  static const IconData distance = Icons.height_rounded;
  static const IconData area = Icons.crop_free_rounded;
  static const IconData outdoorArea = Icons.route_rounded;
  static const IconData level = Icons.horizontal_rule_rounded;
  static const IconData flashlight = Icons.flashlight_on_rounded;
  static const IconData compass = Icons.explore_rounded;
  static const IconData calibration = Icons.tune_rounded;

  static IconData forType(String toolType) {
    switch (toolType) {
      case 'ruler':
        return ruler;
      case 'tape_ruler':
        return tapeRuler;
      case 'scale_ruler':
        return scaleRuler;
      case 'divider_ruler':
        return dividerRuler;
      case 'unit_converter':
        return unitConverter;
      case 'protractor':
        return protractor;
      case 'distance':
        return distance;
      case 'area':
        return area;
      case 'outdoor_area':
        return outdoorArea;
      case 'level':
        return level;
      case 'flashlight':
        return flashlight;
      case 'compass':
        return compass;
      case 'calibration':
        return calibration;
      default:
        return Icons.build_rounded;
    }
  }
}
