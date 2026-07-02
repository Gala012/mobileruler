import 'package:flutter/material.dart';
import 'package:mobilem/utils/app_colors.dart';
import 'package:mobilem/utils/tool_icons.dart';

class StatsToolMeta {
  StatsToolMeta._();

  static IconData iconFor(String toolType) => ToolIcons.forType(toolType);

  static Color colorFor(String toolType) {
    switch (toolType) {
      case 'ruler':
      case 'flashlight':
      case 'calibration':
      case 'tape_ruler':
      case 'scale_ruler':
        return AppColors.cta;
      default:
        return AppColors.primary;
    }
  }
}
