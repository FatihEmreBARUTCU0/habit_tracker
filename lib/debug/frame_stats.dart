import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';

class FrameStats {
  static final FrameStats _i = FrameStats._();
  FrameStats._();
  static FrameStats get I => _i;

  final List<Duration> _ui = [];
  final List<Duration> _gpu = [];
  bool _running = false;

  void start() {
    if (_running) return;
    _running = true;
    SchedulerBinding.instance.addTimingsCallback(_onTimings);
  }

  void stopAndPrint({String label = 'FrameStats'}) {
    if (!_running) return;
    _running = false;
    SchedulerBinding.instance.removeTimingsCallback(_onTimings);
    if (_ui.isEmpty) {
      debugPrint('$label: no frames captured.');
      return;
    }
    double ms(Duration d) => d.inMicroseconds / 1000.0;
  double p(List<double> xs, double q) {
  if (xs.isEmpty) return 0;
  final sorted = [...xs]..sort(); // yeni kopya oluştur, sırala
  final i = max(0, (sorted.length * q).floor() - 1);
  return sorted[i];
}


    final uiMs = _ui.map(ms).toList()..sort();
    final gpuMs = _gpu.map(ms).toList()..sort();

    int over16 = uiMs.where((v) => v > 16.6).length;
    int over33 = uiMs.where((v) => v > 33.3).length;

    double avg(List<double> xs) => xs.isEmpty ? 0 : xs.reduce((a, b) => a + b) / xs.length;

    debugPrint('==== $label ====');
    debugPrint('Frames: ${uiMs.length}');
    debugPrint('UI avg=${avg(uiMs).toStringAsFixed(1)}ms  p90=${p(uiMs, .90).toStringAsFixed(1)}  p99=${p(uiMs, .99).toStringAsFixed(1)}');
    debugPrint('GPU avg=${avg(gpuMs).toStringAsFixed(1)}ms  p90=${p(gpuMs, .90).toStringAsFixed(1)}  p99=${p(gpuMs, .99).toStringAsFixed(1)}');
    debugPrint('UI >16.6ms: $over16  |  UI >33.3ms: $over33');
    debugPrint('===============');
    _ui.clear(); _gpu.clear();
  }

  void _onTimings(List<FrameTiming> timings) {
    for (final t in timings) {
      _ui.add(t.buildDuration);
      _gpu.add(t.rasterDuration);
    }
  }
}
