import 'dart:ui';

import 'package:synamyk/domain/models/common/json_read.dart';

enum FigureType { coordinatePlane, geometry }

/// A question drawing: a coordinate plane (X horizontal, Y vertical) or a
/// free geometry sketch. Format: ORT_FLUTTER_CLIENT_PROMPT.md §6.2.
class Figure {
  const Figure({
    required this.type,
    required this.xMin,
    required this.xMax,
    required this.yMin,
    required this.yMax,
    required this.gridStep,
    required this.showGrid,
    required this.showAxes,
    required this.xLabel,
    required this.yLabel,
    required this.elements,
  });

  final FigureType type;
  final double xMin;
  final double xMax;
  final double yMin;
  final double yMax;
  final double gridStep;
  final bool showGrid;
  final bool showAxes;
  final String? xLabel;
  final String? yLabel;
  final List<FigureElement> elements;

  /// `null` for a missing or malformed figure — the question still renders.
  static Figure? tryParse(Object? json) {
    if (json is! Map<String, dynamic>) return null;
    final type = switch (json['type']) {
      'COORDINATE_PLANE' => FigureType.coordinatePlane,
      'GEOMETRY' => FigureType.geometry,
      _ => null,
    };
    if (type == null) return null;

    final elements = readMapList(
      json['elements'],
    ).map(FigureElement.tryParse).whereType<FigureElement>().toList();

    if (type == FigureType.coordinatePlane) {
      final xMin = readDouble(json['xMin']) ?? -5;
      final xMax = readDouble(json['xMax']) ?? 5;
      final yMin = readDouble(json['yMin']) ?? -5;
      final yMax = readDouble(json['yMax']) ?? 5;
      if (xMin >= xMax || yMin >= yMax) return null;
      final step = readDouble(json['gridStep']);
      return Figure(
        type: type,
        xMin: xMin,
        xMax: xMax,
        yMin: yMin,
        yMax: yMax,
        gridStep: step != null && step > 0 ? step : 1,
        showGrid: readBool(json['showGrid'], true),
        showAxes: readBool(json['showAxes'], true),
        xLabel: readString(json['xLabel']),
        yLabel: readString(json['yLabel']),
        elements: elements,
      );
    }

    final bounds = _geometryBounds(elements);
    return Figure(
      type: type,
      xMin: bounds.left,
      xMax: bounds.right,
      yMin: bounds.top,
      yMax: bounds.bottom,
      gridStep: 1,
      showGrid: false,
      showAxes: false,
      xLabel: null,
      yLabel: null,
      elements: elements,
    );
  }

  /// Bounding box of every point in the drawing, padded by 10% so labels
  /// and stroke widths near the edge stay visible. `top`/`bottom` hold the
  /// min/max Y in math coordinates (not screen coordinates).
  static Rect _geometryBounds(List<FigureElement> elements) {
    final xs = <double>[];
    final ys = <double>[];
    void add(Offset p) {
      xs.add(p.dx);
      ys.add(p.dy);
    }

    for (final e in elements) {
      e.points.forEach(add);
      if (e.radius != null && e.points.isNotEmpty) {
        final c = e.points.first;
        add(c.translate(-e.radius!, -e.radius!));
        add(c.translate(e.radius!, e.radius!));
      }
    }
    if (xs.isEmpty) return const Rect.fromLTRB(-5, -5, 5, 5);

    var minX = xs.reduce((a, b) => a < b ? a : b);
    var maxX = xs.reduce((a, b) => a > b ? a : b);
    var minY = ys.reduce((a, b) => a < b ? a : b);
    var maxY = ys.reduce((a, b) => a > b ? a : b);
    // Keep the aspect square so shapes aren't distorted in the square canvas.
    final size = [
      maxX - minX,
      maxY - minY,
      1.0,
    ].reduce((a, b) => a > b ? a : b);
    final cx = (minX + maxX) / 2, cy = (minY + maxY) / 2;
    final half = size * 1.2 / 2;
    minX = cx - half;
    maxX = cx + half;
    minY = cy - half;
    maxY = cy + half;
    return Rect.fromLTRB(minX, minY, maxX, maxY);
  }
}

enum FigureElementKind {
  point,
  text,
  segment,
  line,
  ray,
  vector,
  polygon,
  polyline,
  circle,
  arc,
  angle,
  function,
}

/// One drawable element. [points] holds the kind-specific points in a fixed
/// order: POINT/TEXT `[p]`; SEGMENT/LINE/RAY/VECTOR `[from, to]`;
/// POLYGON/POLYLINE the vertices; CIRCLE/ARC `[center]`;
/// ANGLE `[vertex, from, to]`; FUNCTION none.
class FigureElement {
  const FigureElement({
    required this.kind,
    required this.points,
    this.label,
    this.text,
    this.color,
    this.fill,
    this.dashed = false,
    this.radius,
    this.startAngle,
    this.endAngle,
    this.right = false,
    this.labels = const [],
    this.expression,
    this.xFrom,
    this.xTo,
  });

  final FigureElementKind kind;
  final List<Offset> points;
  final String? label;
  final String? text;
  final Color? color;
  final Color? fill;
  final bool dashed;
  final double? radius;
  final double? startAngle;
  final double? endAngle;
  final bool right;
  final List<String> labels;
  final String? expression;
  final double? xFrom;
  final double? xTo;

  static FigureElement? tryParse(Map<String, dynamic> json) {
    final kind = switch (json['kind']) {
      'POINT' => FigureElementKind.point,
      'TEXT' => FigureElementKind.text,
      'SEGMENT' => FigureElementKind.segment,
      'LINE' => FigureElementKind.line,
      'RAY' => FigureElementKind.ray,
      'VECTOR' => FigureElementKind.vector,
      'POLYGON' => FigureElementKind.polygon,
      'POLYLINE' => FigureElementKind.polyline,
      'CIRCLE' => FigureElementKind.circle,
      'ARC' => FigureElementKind.arc,
      'ANGLE' => FigureElementKind.angle,
      'FUNCTION' => FigureElementKind.function,
      _ => null,
    };
    if (kind == null) return null;

    List<Offset>? points;
    switch (kind) {
      case FigureElementKind.point:
      case FigureElementKind.text:
        final x = readDouble(json['x']), y = readDouble(json['y']);
        if (x != null && y != null) points = [Offset(x, y)];
      case FigureElementKind.segment:
      case FigureElementKind.line:
      case FigureElementKind.ray:
      case FigureElementKind.vector:
        points = _points([json['from'], json['to']]);
      case FigureElementKind.polygon:
      case FigureElementKind.polyline:
        final raw = json['points'];
        points = raw is List ? _points(raw) : null;
        if (points != null && points.length < 2) points = null;
      case FigureElementKind.circle:
      case FigureElementKind.arc:
        points = _points([json['center']]);
      case FigureElementKind.angle:
        points = _points([json['vertex'], json['from'], json['to']]);
      case FigureElementKind.function:
        points = const [];
    }
    if (points == null) return null;

    final radius = readDouble(json['radius']);
    if ((kind == FigureElementKind.circle || kind == FigureElementKind.arc) &&
        (radius == null || radius <= 0)) {
      return null;
    }
    final expression = readString(json['expression']);
    if (kind == FigureElementKind.function &&
        (expression == null || expression.trim().isEmpty)) {
      return null;
    }

    return FigureElement(
      kind: kind,
      points: points,
      label: readString(json['label']),
      text: readString(json['text']),
      color: parseHexColor(json['color']),
      fill: parseHexColor(json['fill']),
      dashed: readBool(json['dashed']),
      radius: radius,
      startAngle: readDouble(json['startAngle']),
      endAngle: readDouble(json['endAngle']),
      right: readBool(json['right']),
      labels: readStringList(json['labels']),
      expression: expression,
      xFrom: readDouble(json['xFrom']),
      xTo: readDouble(json['xTo']),
    );
  }

  /// All-or-nothing: one malformed point drops the element.
  static List<Offset>? _points(List<dynamic> raw) {
    final result = <Offset>[];
    for (final p in raw) {
      if (p is! List || p.length != 2) return null;
      final x = readDouble(p[0]), y = readDouble(p[1]);
      if (x == null || y == null) return null;
      result.add(Offset(x, y));
    }
    return result;
  }
}

/// `#RRGGBB` or `#AARRGGBB`.
Color? parseHexColor(Object? value) {
  if (value is! String) return null;
  final hex = value.startsWith('#') ? value.substring(1) : value;
  final parsed = int.tryParse(hex, radix: 16);
  if (parsed == null) return null;
  return switch (hex.length) {
    6 => Color(0xFF000000 | parsed),
    8 => Color(parsed),
    _ => null,
  };
}
