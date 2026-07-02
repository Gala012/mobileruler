import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobilem/db_mobilem/db_mobilem_helper.dart';
import 'package:mobilem/lang/lang.dart';
import 'package:mobilem/utils/tool_icons.dart';

class ToolItem {
  const ToolItem({
    required this.title,
    required this.icon,
    required this.route,
    required this.toolType,
    this.featured = false,
  });

  final String title;
  final IconData icon;
  final String route;
  final String toolType;
  final bool featured;
}

class ToolsLogic extends GetxController {
  final totalMeasurements = 0.obs;

  static const allTools = [
    ToolItem(
      title: Lang.toolRuler,
      icon: ToolIcons.ruler,
      route: '/ruler',
      toolType: 'ruler',
      featured: true,
    ),
    ToolItem(
      title: Lang.toolTapeRuler,
      icon: ToolIcons.tapeRuler,
      route: '/tape_ruler',
      toolType: 'tape_ruler',
      featured: true,
    ),
    ToolItem(
      title: Lang.toolScaleRuler,
      icon: ToolIcons.scaleRuler,
      route: '/scale_ruler',
      toolType: 'scale_ruler',
    ),
    ToolItem(
      title: Lang.toolDividerRuler,
      icon: ToolIcons.dividerRuler,
      route: '/divider_ruler',
      toolType: 'divider_ruler',
    ),
    ToolItem(
      title: Lang.toolUnitConverter,
      icon: ToolIcons.unitConverter,
      route: '/unit_converter',
      toolType: 'unit_converter',
    ),
    ToolItem(
      title: Lang.toolProtractor,
      icon: ToolIcons.protractor,
      route: '/protractor',
      toolType: 'protractor',
    ),
    ToolItem(
      title: Lang.toolDistance,
      icon: ToolIcons.distance,
      route: '/distance',
      toolType: 'distance',
    ),
    ToolItem(
      title: Lang.toolArea,
      icon: ToolIcons.area,
      route: '/area',
      toolType: 'area',
    ),
    ToolItem(
      title: Lang.toolOutdoorArea,
      icon: ToolIcons.outdoorArea,
      route: '/outdoor_area',
      toolType: 'outdoor_area',
    ),
    ToolItem(
      title: Lang.toolLevel,
      icon: ToolIcons.level,
      route: '/level',
      toolType: 'level',
    ),
    ToolItem(
      title: Lang.toolFlashlight,
      icon: ToolIcons.flashlight,
      route: '/flashlight',
      toolType: 'flashlight',
      featured: true,
    ),
    ToolItem(
      title: Lang.toolCompass,
      icon: ToolIcons.compass,
      route: '/compass',
      toolType: 'compass',
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    loadStats();
  }

  Future<void> loadStats() async {
    totalMeasurements.value = await DbMobilemHelper.instance.getTotalMeasurements();
  }

  Future<void> openTool(ToolItem item) async {
    await Get.toNamed(item.route);
    await loadStats();
  }
}
