import 'dart:ui';
import 'package:flutter/material.dart';

const _kTargetCanvasSize = 24.0;
const _kAnimationCurve = Curves.easeInQuart;
const _kAnimationDuration = 600;

/// An animated Yaru no network icon, similar to `network_wirless` and `network_wirless_disabled`
class YaruAnimatedNoNetworkIcon extends StatefulWidget {
  /// Create an animated Yaru no network icon, similar to `network_wirless` and `network_wirless_disabled`
  const YaruAnimatedNoNetworkIcon({
    this.size = 24.0,
    this.color,
    this.onCompleted,
    super.key,
  });

  /// Determines the icon canvas size
  /// To fit the original Yaru icons, the icon will be slightly smaller (20.0 on a 24.0 canvas)
  /// Defaults to 24.0  as the original Yaru icon
  final double size;

  /// Color used to draw the icon
  /// If null, defaults to colorScheme.onSurface
  final Color? color;

  /// Callback called once animation completeds
  final Function? onCompleted;

  @override
  _YaruAnimatedNoNetworkIconState createState() =>
      _YaruAnimatedNoNetworkIconState();
}

class _YaruAnimatedNoNetworkIconState extends State<YaruAnimatedNoNetworkIcon>
    with TickerProviderStateMixin {
  late final Animation<double> _animation;
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: _kAnimationDuration),
      vsync: this,
    );
    _animation = Tween(begin: 0.0, end: 1.0)
        .chain(CurveTween(curve: _kAnimationCurve))
        .animate(_controller);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && widget.onCompleted != null) {
        widget.onCompleted!();
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: SizedBox.square(
        dimension: widget.size,
        child: AnimatedBuilder(
          animation: _animation,
          builder: ((context, child) {
            return CustomPaint(
              painter: _YaruAnimatedNoNetworkIconPainter(
                widget.size,
                widget.color ?? Theme.of(context).colorScheme.onSurface,
                _animation.value,
              ),
            );
          }),
        ),
      ),
    );
  }
}

// Path created with the help of https://fluttershapemaker.com/
class _YaruAnimatedNoNetworkIconPainter extends CustomPainter {
  _YaruAnimatedNoNetworkIconPainter(
    this.size,
    this.color,
    this.animationPosition,
  ) : assert(animationPosition >= 0.0 && animationPosition <= 1.0) {
    wave1Metric = _getWave1Path().computeMetrics().single;
    wave2Metric = _getWave2Path().computeMetrics().single;
    wave3Metric = _getWave3Path().computeMetrics().single;
    wave4Metric = _getWave4Path().computeMetrics().single;
    stripe1Metric = _getStripe1Path().computeMetrics().single;
  }

  final double size;
  final Color color;
  final double animationPosition;

  late final PathMetric wave1Metric;
  late final PathMetric wave2Metric;
  late final PathMetric wave3Metric;
  late final PathMetric wave4Metric;
  late final PathMetric stripe1Metric;

  @override
  void paint(Canvas canvas, Size size) {
    final clipRect = Rect.fromCenter(
      center: Offset.zero,
      width: this.size * 2,
      height: this.size * 2,
    );
    final clipPath = Path.combine(
      PathOperation.difference,
      Path()..addRect(clipRect),
      _getStripe2Path(),
    );

    canvas.save();
    canvas.clipPath(clipPath);
    canvas.saveLayer(clipRect, Paint());

    _drawExtractedPathMetric(canvas, wave1Metric, 0, .4);
    _drawExtractedPathMetric(canvas, wave2Metric, 0.1, .5);
    _drawExtractedPathMetric(canvas, wave3Metric, 0.2, .6);
    _drawExtractedPathMetric(canvas, wave4Metric, 0.3, .7);
    _drawExtractedPathMetric(canvas, stripe1Metric, .4, .6);

    _drawDot(canvas);

    canvas.restore();
    canvas.restore();
  }

  Path _getWave1Path() {
    final wave = Path();
    wave.moveTo(size * 0.6466471, size * 0.6155599);
    wave.cubicTo(size * 0.6054710, size * 0.5812731, size * 0.5535823,
        size * 0.5624987, size * 0.5000000, size * 0.5625000);
    wave.cubicTo(size * 0.4464713, size * 0.5626250, size * 0.3946749,
        size * 0.5814829, size * 0.3535970, size * 0.6158040);

    return wave;
  }

  Path _getWave2Path() {
    final wave = Path();
    wave.moveTo(size * 0.7352702, size * 0.5269368);
    wave.cubicTo(size * 0.6704428, size * 0.4693235, size * 0.5867288,
        size * 0.4375000, size * 0.5000000, size * 0.4375000);
    wave.cubicTo(size * 0.4133234, size * 0.4376250, size * 0.3297026,
        size * 0.4695350, size * 0.2649740, size * 0.5271810);

    return wave;
  }

  Path _getWave3Path() {
    final wave = Path();
    wave.moveTo(size * 0.8237305, size * 0.4384766);
    wave.cubicTo(size * 0.7353761, size * 0.3574702, size * 0.6198688,
        size * 0.3125217, size * 0.5000000, size * 0.3125000);
    wave.cubicTo(size * 0.3802343, size * 0.3127771, size * 0.2649141,
        size * 0.3578946, size * 0.1767578, size * 0.4389648);

    return wave;
  }

  Path _getWave4Path() {
    final wave = Path();
    wave.moveTo(size * 0.9121094, size * 0.3500977);
    wave.cubicTo(size * 0.8002838, size * 0.2456712, size * 0.6530028,
        size * 0.1875615, size * 0.5000000, size * 0.1875000);
    wave.cubicTo(size * 0.3471336, size * 0.1879029, size * 0.2001027,
        size * 0.2462382, size * 0.08854167, size * 0.3507487);

    return wave;
  }

  Path _getStripe1Path() {
    final stripe = Path();
    stripe.moveTo(size * 0.1666667, size * 0.1250000);
    stripe.lineTo(size * 0.7916667, size * 0.7500000);

    return stripe;
  }

  Path _getStripe2Path() {
    final start1 = Offset(this.size * 0.2108561, this.size * 0.08081055);
    final start2 = Offset(this.size * 0.1813965, this.size * 0.1102702);
    final end1 = Offset(this.size * 0.8358561, this.size * 0.7058105);
    final end2 = Offset(this.size * 0.8063965, this.size * 0.7352702);

    final localAnimationPosition = _computeLocalAnimationPosition(.4, .6);

    print(localAnimationPosition);

    final drawEnd1 = Offset.lerp(start1, end1, localAnimationPosition)!;
    final drawEnd2 = Offset.lerp(start2, end2, localAnimationPosition)!;

    final stripe2 = Path();
    stripe2.moveTo(start1.dx, start1.dy);
    stripe2.lineTo(drawEnd1.dx, drawEnd1.dy);
    stripe2.lineTo(drawEnd2.dx, drawEnd2.dy);
    stripe2.lineTo(start2.dx, start2.dy);
    stripe2.close();

    return stripe2;
  }

  void _drawExtractedPathMetric(
    Canvas canvas,
    PathMetric metric,
    double start,
    double duration,
  ) {
    final drawPath = metric.extractPath(
        0, metric.length * _computeLocalAnimationPosition(start, duration));

    canvas.drawPath(drawPath, _getStrokePaint());
  }

  void _drawDot(Canvas canvas) {
    canvas.drawCircle(
      Offset(this.size * 0.5, this.size * 0.7916667),
      (this.size * 0.08333333) * _computeLocalAnimationPosition(0, .1),
      _getFillPaint(),
    );
  }

  Paint _getFillPaint() {
    return Paint()
      ..style = PaintingStyle.fill
      ..color = color;
  }

  Paint _getStrokePaint() {
    return Paint()
      ..style = PaintingStyle.stroke
      ..color = color
      ..strokeWidth = 1 / (_kTargetCanvasSize / size);
  }

  double _computeLocalAnimationPosition(double start, double duration) {
    assert(start >= 0.0 && start <= 1.0);
    assert(duration >= 0.0 && duration <= 1.0);
    assert(start + duration <= 1.0);

    final localAnimationPosition = animationPosition >= start
        ? (animationPosition - start) * (1.0 / duration)
        : 0.0;

    return localAnimationPosition < 1.0 ? localAnimationPosition : 1.0;
  }

  @override
  bool shouldRepaint(_YaruAnimatedNoNetworkIconPainter oldDelegate) {
    return oldDelegate.animationPosition != animationPosition ||
        oldDelegate.size != size ||
        oldDelegate.color != color;
  }
}