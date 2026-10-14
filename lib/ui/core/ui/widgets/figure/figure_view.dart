import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:synamyk/domain/models/figure/figure.dart';
import 'package:synamyk/ui/core/ui/themes/app_colors.dart';

/// Draws a question [Figure] in a square area as wide as its parent.
class FigureView extends StatelessWidget {
  const FigureView({super.key, required this.figure});

  final Figure figure;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.divider),
        ),
        clipBehavior: Clip.antiAlias,
        child: CustomPaint(painter: FigurePainter(figure)),
      ),
    );
  }
}

class FigurePainter extends CustomPainter {
  FigurePainter(this.figure);

  final Figure figure;

  static const _ink = Color(0xFF1E293B);
  static const _defaultStroke = AppColors.primary;
  static const _pad = 14.0;

  late Size _size;

  double get _w => _size.width - _pad * 2;
  double get _h => _size.height - _pad * 2;

  /// Math → canvas coordinates (Y grows upward in math space).
  Offset _map(Offset p) => Offset(
    _pad + (p.dx - figure.xMin) / (figure.xMax - figure.xMin) * _w,
    _pad + (figure.yMax - p.dy) / (figure.yMax - figure.yMin) * _h,
  );

  double get _unit => _w / (figure.xMax - figure.xMin);

  @override
  void paint(Canvas canvas, Size size) {
    _size = size;
    canvas.save();
    canvas.clipRect(Offset.zero & size);

    if (figure.type == FigureType.coordinatePlane) {
      if (figure.showGrid) _drawGrid(canvas);
      if (figure.showAxes) _drawAxes(canvas);
    }

    final elements = figure.elements;
    // Fills first so strokes and points stay on top.
    for (final e in elements) {
      if (e.fill != null &&
          (e.kind == FigureElementKind.polygon ||
              e.kind == FigureElementKind.circle)) {
        _drawFill(canvas, e);
      }
    }
    for (final e in elements) {
      switch (e.kind) {
        case FigureElementKind.segment:
        case FigureElementKind.line:
        case FigureElementKind.ray:
        case FigureElementKind.vector:
        case FigureElementKind.polygon:
        case FigureElementKind.polyline:
        case FigureElementKind.circle:
        case FigureElementKind.arc:
        case FigureElementKind.angle:
        case FigureElementKind.function:
          _drawShape(canvas, e);
        case FigureElementKind.point:
        case FigureElementKind.text:
          break;
      }
    }
    for (final e in elements) {
      if (e.kind == FigureElementKind.point) {
        canvas.drawCircle(
          _map(e.points.first),
          4,
          Paint()..color = e.color ?? _ink,
        );
      }
    }
    for (final e in elements) {
      _drawLabels(canvas, e);
    }
    canvas.restore();
  }

  // ─── grid & axes ──────────────────────────────────────────

  void _drawGrid(Canvas canvas) {
    final paint = Paint()
      ..color = const Color(0xFFE7EDF5)
      ..strokeWidth = 1;
    final step = _safeStep();
    for (var x = _firstTick(figure.xMin, step); x <= figure.xMax; x += step) {
      final a = _map(Offset(x, figure.yMin)), b = _map(Offset(x, figure.yMax));
      canvas.drawLine(a, b, paint);
    }
    for (var y = _firstTick(figure.yMin, step); y <= figure.yMax; y += step) {
      final a = _map(Offset(figure.xMin, y)), b = _map(Offset(figure.xMax, y));
      canvas.drawLine(a, b, paint);
    }
  }

  /// Keeps at most ~40 grid lines per axis even for a tiny gridStep.
  double _safeStep() {
    var step = figure.gridStep;
    final span = math.max(figure.xMax - figure.xMin, figure.yMax - figure.yMin);
    while (span / step > 40) {
      step *= 2;
    }
    return step;
  }

  double _firstTick(double min, double step) => (min / step).ceil() * step;

  void _drawAxes(Canvas canvas) {
    final paint = Paint()
      ..color = _ink
      ..strokeWidth = 1.4;
    final hasX = figure.yMin <= 0 && figure.yMax >= 0;
    final hasY = figure.xMin <= 0 && figure.xMax >= 0;
    final axisY = hasX ? 0.0 : figure.yMin;
    final axisX = hasY ? 0.0 : figure.xMin;

    final xa = _map(Offset(figure.xMin, axisY));
    final xb = _map(Offset(figure.xMax, axisY));
    canvas.drawLine(xa, xb.translate(_pad - 2, 0), paint);
    _arrowHead(canvas, xb.translate(_pad - 2, 0), 0, paint);

    final ya = _map(Offset(axisX, figure.yMin));
    final yb = _map(Offset(axisX, figure.yMax));
    canvas.drawLine(ya, yb.translate(0, -_pad + 2), paint);
    _arrowHead(canvas, yb.translate(0, -_pad + 2), -math.pi / 2, paint);

    final step = _safeStep();
    final labelEvery = math.max(
      1,
      (((figure.xMax - figure.xMin) / step) / 12).ceil(),
    );
    var i = 0;
    for (
      var x = _firstTick(figure.xMin, step);
      x <= figure.xMax;
      x += step, i++
    ) {
      if (x.abs() < 1e-9 || i % labelEvery != 0) continue;
      final p = _map(Offset(x, axisY));
      canvas.drawLine(p.translate(0, -3), p.translate(0, 3), paint);
      _text(
        canvas,
        _fmt(x),
        p.translate(0, 9),
        size: 9,
        color: AppColors.textSecondary,
      );
    }
    i = 0;
    for (
      var y = _firstTick(figure.yMin, step);
      y <= figure.yMax;
      y += step, i++
    ) {
      if (y.abs() < 1e-9 || i % labelEvery != 0) continue;
      final p = _map(Offset(axisX, y));
      canvas.drawLine(p.translate(-3, 0), p.translate(3, 0), paint);
      _text(
        canvas,
        _fmt(y),
        p.translate(-10, 0),
        size: 9,
        color: AppColors.textSecondary,
      );
    }
    if (hasX && hasY) {
      _text(
        canvas,
        '0',
        _map(Offset.zero).translate(-7, 8),
        size: 9,
        color: AppColors.textSecondary,
      );
    }
    _text(
      canvas,
      figure.xLabel ?? 'x',
      xb.translate(4, -10),
      size: 12,
      italic: true,
    );
    _text(
      canvas,
      figure.yLabel ?? 'y',
      yb.translate(10, -4),
      size: 12,
      italic: true,
    );
  }

  String _fmt(double v) =>
      v == v.roundToDouble() ? v.toInt().toString() : v.toStringAsFixed(1);

  // ─── shapes ───────────────────────────────────────────────

  Paint _stroke(FigureElement e) => Paint()
    ..color = e.color ?? _defaultStroke
    ..strokeWidth = 2
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;

  void _drawFill(Canvas canvas, FigureElement e) {
    final paint = Paint()..color = e.fill!;
    if (e.kind == FigureElementKind.circle) {
      canvas.drawCircle(_map(e.points.first), e.radius! * _unit, paint);
    } else {
      canvas.drawPath(_polyPath(e.points, close: true), paint);
    }
  }

  void _drawShape(Canvas canvas, FigureElement e) {
    final paint = _stroke(e);
    switch (e.kind) {
      case FigureElementKind.segment:
        _line(canvas, _map(e.points[0]), _map(e.points[1]), paint, e.dashed);
      case FigureElementKind.vector:
        final a = _map(e.points[0]), b = _map(e.points[1]);
        _line(canvas, a, b, paint, e.dashed);
        _arrowHead(
          canvas,
          b,
          (b - a).direction,
          paint..style = PaintingStyle.stroke,
        );
      case FigureElementKind.line:
      case FigureElementKind.ray:
        final a = e.points[0], b = e.points[1];
        final d = b - a;
        if (d.distance == 0) return;
        final far = (figure.xMax - figure.xMin + figure.yMax - figure.yMin) * 4;
        final unit = d / d.distance;
        final start = e.kind == FigureElementKind.ray ? a : a - unit * far;
        _line(canvas, _map(start), _map(a + unit * far), paint, e.dashed);
      case FigureElementKind.polygon:
      case FigureElementKind.polyline:
        final path = _polyPath(
          e.points,
          close: e.kind == FigureElementKind.polygon,
        );
        e.dashed
            ? _dashedPath(canvas, path, paint)
            : canvas.drawPath(path, paint);
      case FigureElementKind.circle:
        final path = Path()
          ..addOval(
            Rect.fromCircle(
              center: _map(e.points.first),
              radius: e.radius! * _unit,
            ),
          );
        e.dashed
            ? _dashedPath(canvas, path, paint)
            : canvas.drawPath(path, paint);
      case FigureElementKind.arc:
        final start = (e.startAngle ?? 0) * math.pi / 180;
        final end = (e.endAngle ?? 360) * math.pi / 180;
        final path = Path()
          ..addArc(
            Rect.fromCircle(
              center: _map(e.points.first),
              radius: e.radius! * _unit,
            ),
            -start, // canvas angles run clockwise
            -(end - start),
          );
        e.dashed
            ? _dashedPath(canvas, path, paint)
            : canvas.drawPath(path, paint);
      case FigureElementKind.angle:
        _drawAngle(canvas, e, paint);
      case FigureElementKind.function:
        _drawFunction(canvas, e, paint);
      case FigureElementKind.point:
      case FigureElementKind.text:
        break;
    }
  }

  void _drawAngle(Canvas canvas, FigureElement e, Paint paint) {
    final v = _map(e.points[0]);
    final a = _map(e.points[1]) - v;
    final b = _map(e.points[2]) - v;
    if (a.distance == 0 || b.distance == 0) return;
    paint.strokeWidth = 1.6;
    const r = 22.0;
    if (e.right) {
      final ua = a / a.distance * 12, ub = b / b.distance * 12;
      canvas.drawPath(
        Path()
          ..moveTo(v.dx + ua.dx, v.dy + ua.dy)
          ..lineTo(v.dx + ua.dx + ub.dx, v.dy + ua.dy + ub.dy)
          ..lineTo(v.dx + ub.dx, v.dy + ub.dy),
        paint,
      );
      return;
    }
    final start = a.direction;
    var sweep = b.direction - start;
    // Always draw the inner (smaller) angle.
    while (sweep > math.pi) {
      sweep -= 2 * math.pi;
    }
    while (sweep < -math.pi) {
      sweep += 2 * math.pi;
    }
    canvas.drawArc(
      Rect.fromCircle(center: v, radius: r),
      start,
      sweep,
      false,
      paint,
    );
  }

  void _drawFunction(Canvas canvas, FigureElement e, Paint paint) {
    final fn = _compile(e.expression!);
    if (fn == null) return;
    final from = math.max(e.xFrom ?? figure.xMin, figure.xMin);
    final to = math.min(e.xTo ?? figure.xMax, figure.xMax);
    if (from >= to) return;

    final step = (figure.xMax - figure.xMin) / 400;
    final height = figure.yMax - figure.yMin;
    final path = Path();
    var penDown = false;
    double? prevY;
    for (var x = from; x <= to + step / 2; x += step) {
      final y = fn(math.min(x, to));
      final valid = y.isFinite && y.abs() < height * 1e3;
      final jump = prevY != null && valid && (y - prevY).abs() > height;
      if (!valid || jump) {
        penDown = false;
        prevY = valid ? y : null;
        if (!valid) continue;
      }
      final p = _map(Offset(math.min(x, to), y));
      if (penDown) {
        path.lineTo(p.dx, p.dy);
      } else {
        path.moveTo(p.dx, p.dy);
        penDown = true;
      }
      prevY = y;
    }
    e.dashed ? _dashedPath(canvas, path, paint) : canvas.drawPath(path, paint);
  }

  static final Map<String, double Function(double)?> _compiled = {};

  /// Parses `y = f(x)` once per expression; `null` when it can't be parsed.
  static double Function(double)? _compile(String source) {
    return _compiled.putIfAbsent(source, () {
      try {
        final parser = _FigureExpressionParser();
        final expr = parser.parse(_normalizeExpression(source));
        final x = Variable('x');
        final context = ContextModel();
        final evaluator = RealEvaluator(context);
        return (double value) {
          context.bindVariable(x, Number(value));
          try {
            return evaluator.evaluate(expr).toDouble();
          } catch (_) {
            return double.nan;
          }
        };
      } catch (_) {
        return null;
      }
    });
  }

  // ─── labels ───────────────────────────────────────────────

  void _drawLabels(Canvas canvas, FigureElement e) {
    final color = e.color ?? _ink;
    switch (e.kind) {
      case FigureElementKind.text:
        _text(
          canvas,
          e.text ?? e.label ?? '',
          _map(e.points.first),
          size: 13,
          color: color,
        );
      case FigureElementKind.point:
        if (e.label != null) {
          _text(
            canvas,
            e.label!,
            _map(e.points.first).translate(10, -10),
            size: 13,
            color: color,
            bold: true,
          );
        }
      case FigureElementKind.segment:
      case FigureElementKind.vector:
        if (e.label != null) {
          final a = _map(e.points[0]), b = _map(e.points[1]);
          final mid = (a + b) / 2;
          final d = b - a;
          final normal = d.distance == 0
              ? Offset.zero
              : Offset(-d.dy, d.dx) / d.distance * 12;
          _text(canvas, e.label!, mid + normal, size: 12, color: color);
        }
      case FigureElementKind.polygon:
        final centroid =
            e.points.reduce((a, b) => a + b) / e.points.length.toDouble();
        for (var i = 0; i < e.points.length && i < e.labels.length; i++) {
          final p = _map(e.points[i]);
          final away = p - _map(centroid);
          final offset = away.distance == 0
              ? Offset.zero
              : away / away.distance * 12;
          _text(
            canvas,
            e.labels[i],
            p + offset,
            size: 13,
            color: _ink,
            bold: true,
          );
        }
        if (e.label != null) {
          _text(canvas, e.label!, _map(centroid), size: 12, color: color);
        }
      case FigureElementKind.angle:
        if (e.label != null) {
          final v = _map(e.points[0]);
          final a = _map(e.points[1]) - v, b = _map(e.points[2]) - v;
          if (a.distance == 0 || b.distance == 0) return;
          final bis = a / a.distance + b / b.distance;
          final dir = bis.distance == 0
              ? Offset(-a.dy, a.dx) / a.distance
              : bis / bis.distance;
          _text(canvas, e.label!, v + dir * 36, size: 12, color: color);
        }
      case FigureElementKind.circle:
      case FigureElementKind.arc:
        if (e.label != null) {
          final c = _map(e.points.first);
          _text(
            canvas,
            e.label!,
            c.translate(
              e.radius! * _unit * 0.7 + 8,
              -e.radius! * _unit * 0.7 - 8,
            ),
            size: 12,
            color: color,
          );
        }
      case FigureElementKind.line:
      case FigureElementKind.ray:
      case FigureElementKind.polyline:
        if (e.label != null && e.points.length >= 2) {
          _text(
            canvas,
            e.label!,
            _map(e.points[1]).translate(10, -10),
            size: 12,
            color: color,
          );
        }
      case FigureElementKind.function:
        if (e.label != null) {
          _text(
            canvas,
            e.label!,
            Offset(_size.width - _pad - 30, _pad + 10),
            size: 12,
            color: color,
            italic: true,
          );
        }
    }
  }

  /// Draws text centered on [at]. `$…$` delimiters are stripped: canvas text
  /// can't host a TeX widget, and short labels read fine without them.
  void _text(
    Canvas canvas,
    String text,
    Offset at, {
    double size = 12,
    Color color = _ink,
    bool bold = false,
    bool italic = false,
  }) {
    final clean = text
        .replaceAll(r'$', '')
        .replaceAll(r'\circ', '°')
        .replaceAll(r'^\circ', '°');
    if (clean.isEmpty) return;
    final tp = TextPainter(
      text: TextSpan(
        text: clean,
        style: TextStyle(
          fontSize: size,
          color: color,
          fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
          fontStyle: italic ? FontStyle.italic : FontStyle.normal,
          backgroundColor: Colors.white.withValues(alpha: 0.75),
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, at - Offset(tp.width / 2, tp.height / 2));
  }

  // ─── primitives ───────────────────────────────────────────

  Path _polyPath(List<Offset> points, {required bool close}) {
    final path = Path();
    for (var i = 0; i < points.length; i++) {
      final p = _map(points[i]);
      i == 0 ? path.moveTo(p.dx, p.dy) : path.lineTo(p.dx, p.dy);
    }
    if (close) path.close();
    return path;
  }

  void _line(Canvas canvas, Offset a, Offset b, Paint paint, bool dashed) {
    if (!dashed) {
      canvas.drawLine(a, b, paint);
      return;
    }
    _dashedPath(
      canvas,
      Path()
        ..moveTo(a.dx, a.dy)
        ..lineTo(b.dx, b.dy),
      paint,
    );
  }

  void _dashedPath(Canvas canvas, Path path, Paint paint) {
    const dash = 7.0, gap = 5.0;
    for (final metric in path.computeMetrics()) {
      var d = 0.0;
      while (d < metric.length) {
        canvas.drawPath(
          metric.extractPath(d, math.min(d + dash, metric.length)),
          paint,
        );
        d += dash + gap;
      }
    }
  }

  void _arrowHead(Canvas canvas, Offset tip, double direction, Paint paint) {
    const len = 9.0, spread = 0.45;
    final p1 = tip - Offset.fromDirection(direction - spread, len);
    final p2 = tip - Offset.fromDirection(direction + spread, len);
    canvas.drawPath(
      Path()
        ..moveTo(p1.dx, p1.dy)
        ..lineTo(tip.dx, tip.dy)
        ..lineTo(p2.dx, p2.dy),
      Paint()
        ..color = paint.color
        ..strokeWidth = paint.strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(FigurePainter oldDelegate) => oldDelegate.figure != figure;
}

/// Adds the spec's `cot`, one-argument `log` (base 10) and `exp` on top of
/// math_expressions' grammar.
class _FigureExpressionParser extends GrammarParser {
  _FigureExpressionParser() {
    functionsC['cot'] = (args) => 1 / math.tan(args[0]);
    functionsC['log'] = (args) => math.log(args[0]) / math.ln10;
  }
}

/// `exp(` → `e^(` (the grammar would read `e` as the constant), and implicit
/// multiplication like `2x`, `2(x+1)`, `)(`, `x(` → explicit `*`.
String _normalizeExpression(String source) {
  var s = source.replaceAll(' ', '').replaceAll('exp(', 'e^(');
  s = s.replaceAllMapped(RegExp(r'(\d)([a-z(])'), (m) => '${m[1]}*${m[2]}');
  s = s.replaceAll(')(', ')*(');
  s = s.replaceAllMapped(RegExp(r'\)([a-z\d])'), (m) => ')*${m[1]}');
  s = s.replaceAllMapped(RegExp(r'\bx\('), (_) => 'x*(');
  return s;
}

@visibleForTesting
double? evaluateFigureExpression(String source, double x) =>
    FigurePainter._compile(source)?.call(x);
