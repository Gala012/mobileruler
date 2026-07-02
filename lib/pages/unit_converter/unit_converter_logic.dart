import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobilem/db_mobilem/db_mobilem_helper.dart';
import 'package:mobilem/lang/lang.dart';

class UnitConverterLogic extends GetxController {
  final inputController = TextEditingController(text: '1');
  final fromUnit = 'cm'.obs;
  final toUnit = 'inch'.obs;
  final inputRevision = 0.obs;

  static const units = ['mm', 'cm', 'm', 'inch', 'ft'];

  static const unitLabels = {
    'mm': Lang.unitMm,
    'cm': Lang.unitCm,
    'm': Lang.unitM,
    'inch': Lang.unitInch,
    'ft': Lang.unitFt,
  };

  static const unitShortNames = {
    'mm': Lang.unitShortMm,
    'cm': Lang.unitShortCm,
    'm': Lang.unitShortM,
    'inch': Lang.unitShortInch,
    'ft': Lang.unitShortFt,
  };

  @override
  void onInit() {
    super.onInit();
    DbMobilemHelper.instance.incrementUsage('unit_converter');
    inputController.addListener(() => inputRevision.value++);
  }

  @override
  void onClose() {
    inputController.dispose();
    super.onClose();
  }

  void setFromUnit(String unit) => fromUnit.value = unit;

  void setToUnit(String unit) => toUnit.value = unit;

  void swapUnits() {
    final from = fromUnit.value;
    fromUnit.value = toUnit.value;
    toUnit.value = from;
  }

  double _toMm(double value, String unit) {
    switch (unit) {
      case 'mm':
        return value;
      case 'cm':
        return value * 10;
      case 'm':
        return value * 1000;
      case 'inch':
        return value * 25.4;
      case 'ft':
        return value * 304.8;
      default:
        return value;
    }
  }

  double _fromMm(double mm, String unit) {
    switch (unit) {
      case 'mm':
        return mm;
      case 'cm':
        return mm / 10;
      case 'm':
        return mm / 1000;
      case 'inch':
        return mm / 25.4;
      case 'ft':
        return mm / 304.8;
      default:
        return mm;
    }
  }

  String get resultText {
    inputRevision.value;
    final raw = double.tryParse(inputController.text.trim());
    if (raw == null) return '--';
    final mm = _toMm(raw, fromUnit.value);
    return _fromMm(mm, toUnit.value).toStringAsFixed(2);
  }

  String unitLabel(String unit) => unitLabels[unit] ?? unit;

  String unitShortName(String unit) => unitShortNames[unit] ?? unit;
}
