import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'yaru_animated_icon.dart';

const _kTargetCanvasSize = 24.0;
const _kDefaultIconSize = 18.0;
const _kSizeDifference = (_kTargetCanvasSize - _kDefaultIconSize) / 2;
const _kHalfIconSize = _kDefaultIconSize / 2 - _kSizeDifference;
const _kBarsStartOffsets = [0.2, 0.8, 0.4, 1.0, 0.6];
const _kDefaultIndicatorThickness = 1.0;

const _kDefaultDuration = Duration(milliseconds: 800);

class YaruAnimatedMusicIndicator extends YaruAnimatedIconData {
  const YaruAnimatedMusicIndicator({this.linearlyAnimate = false});

  final bool linearlyAnimate;

  @override
  Duration get defaultDuration => _kDefaultDuration;

  @override
  Widget build(
    BuildContext context,
    Animation<double> progress,
    double? size,
    Color? color,
  ) {
    return YaruAnimatedMusicIndicatorWidget(
      progress: progress,
      size: size ?? _kTargetCanvasSize,
      color: color,
      linearlyAnimate: linearlyAnimate,
    );
  }
}

class YaruAnimatedMusicIndicatorWidget extends StatelessWidget {
  const YaruAnimatedMusicIndicatorWidget({
    required this.progress,
    this.color,
    this.size = _kTargetCanvasSize,
    this.linearlyAnimate = false,
    super.key,
  });

  final Animation<double> progress;
  final double size;
  final Color? color;
  final bool linearlyAnimate;

  @override
  Widget build(BuildContext context) {
    final values = _kBarsStartOffsets
        .map(
          (e) => _transform(progress.value, offset: e, linear: linearlyAnimate),
        )
        .toList();

    return RepaintBoundary(
      child: SizedBox.square(
        dimension: size,
        child: AnimatedBuilder(
          animation: progress,
          builder: (context, _) {
            return CustomPaint(
              painter: _MusicIndicatorPainter(
                values: values,
                size: size,
                color: color ?? Theme.of(context).colorScheme.onSurface,
                thickness: _kDefaultIndicatorThickness,
              ),
              size: Size.square(size),
            );
          },
        ),
      ),
    );
  }
}

double _transform(
  double v, {
  double offset = 0,
  bool linear = true,
}) {
  double cos(x) => math.cos((x + offset / 2) * 2 * math.pi);

  if (linear) return math.acos(cos(v)) / math.pi;

  return cos(v) / 2 + 0.5;
}

class _MusicIndicatorPainter extends CustomPainter {
  const _MusicIndicatorPainter({
    required this.values,
    this.size = 24.0,
    this.color,
    this.thickness = 2.0,
  });

  final List<double> values;
  final double size;
  final Color? color;
  final double thickness;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(this.size / _kTargetCanvasSize);

    final inbetweenSpace =
        (_kDefaultIconSize - thickness) / (values.length - 1);

    for (var i = 0; i < values.length; i++) {
      final dx = (inbetweenSpace * i) + _kSizeDifference + thickness / 2;
      final fraction = values[i];
      final portion = (fraction * _kHalfIconSize) + _kSizeDifference;

      canvas.drawLine(
        Offset(dx, _kSizeDifference * 2 + _kHalfIconSize - portion),
        Offset(dx, _kSizeDifference * 2 + _kHalfIconSize + portion),
        getBarPaint(),
      );
    }
  }

  Paint getBarPaint() {
    return Paint()
      ..color = color ?? Colors.black
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square
      ..strokeWidth = thickness;
  }

  @override
  bool shouldRepaint(covariant _MusicIndicatorPainter old) {
    return !listEquals(values, old.values) ||
        color != old.color ||
        thickness != old.thickness;
  }
}
