import 'dart:async';
import 'package:get/get.dart';
import 'package:torch_light/torch_light.dart';

class FlashlightLogic extends GetxController {
  final isOn = false.obs;
  final sosMode = false.obs;
  final available = true.obs;
  Timer? _sosTimer;
  var _sosState = false;

  @override
  void onInit() {
    super.onInit();
    _checkAvailability();
  }

  Future<void> _checkAvailability() async {
    try {
      available.value = await TorchLight.isTorchAvailable();
    } catch (_) {
      available.value = false;
    }
  }

  Future<void> toggle() async {
    if (!available.value) return;
    if (isOn.value) {
      await _turnOff();
    } else {
      await _turnOn();
    }
  }

  Future<void> _turnOn() async {
    final ok = await _safeEnableTorch();
    if (ok) {
      isOn.value = true;
    }
  }

  Future<void> _turnOff() async {
    _stopSos();
    await _safeDisableTorch();
    isOn.value = false;
  }

  void toggleSos() {
    if (!available.value) return;
    if (sosMode.value) {
      _stopSos();
      sosMode.value = false;
      unawaited(_turnOff());
    } else {
      sosMode.value = true;
      _startSos();
    }
  }

  void _startSos() {
    _sosTimer?.cancel();
    _sosTimer = Timer.periodic(const Duration(milliseconds: 500), (_) async {
      _sosState = !_sosState;
      if (_sosState) {
        final ok = await _safeEnableTorch();
        isOn.value = ok;
      } else {
        await _safeDisableTorch();
        isOn.value = false;
      }
    });
  }

  void _stopSos() {
    _sosTimer?.cancel();
    _sosTimer = null;
  }

  Future<bool> _safeEnableTorch() async {
    try {
      await TorchLight.enableTorch();
      return true;
    } catch (_) {
      available.value = false;
      return false;
    }
  }

  Future<void> _safeDisableTorch() async {
    try {
      await TorchLight.disableTorch();
    } catch (_) {}
  }

  @override
  void onClose() {
    _stopSos();
    unawaited(_safeDisableTorch());
    super.onClose();
  }
}
