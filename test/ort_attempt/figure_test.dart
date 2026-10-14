import 'package:flutter_test/flutter_test.dart';
import 'package:synamyk/domain/models/figure/figure.dart';
import 'package:synamyk/ui/core/ui/widgets/figure/figure_view.dart';

void main() {
  group('Figure.tryParse', () {
    test('parses a coordinate plane with defaults', () {
      final f = Figure.tryParse({
        'type': 'COORDINATE_PLANE',
        'xMin': -5,
        'xMax': 5,
        'yMin': -3,
        'yMax': 3.5,
        'elements': [
          {'kind': 'POINT', 'x': 1, 'y': 2, 'label': 'A'},
          {'kind': 'SEGMENT', 'from': [0, 0], 'to': [2, 2], 'color': '#FF0000'},
          {'kind': 'FUNCTION', 'expression': 'x^2'},
        ],
      })!;
      expect(f.type, FigureType.coordinatePlane);
      expect(f.showGrid, isTrue);
      expect(f.showAxes, isTrue);
      expect(f.gridStep, 1);
      expect(f.yMax, 3.5);
      expect(f.elements, hasLength(3));
      expect(f.elements[1].color!.toARGB32(), 0xFFFF0000);
    });

    test('drops malformed elements but keeps the figure', () {
      final f = Figure.tryParse({
        'type': 'GEOMETRY',
        'elements': [
          {'kind': 'POLYGON', 'points': [[0, 0], [4, 0], [0, 3]], 'labels': ['A', 'B', 'C']},
          {'kind': 'SEGMENT', 'from': [0], 'to': [1, 1]},
          {'kind': 'CIRCLE', 'center': [0, 0], 'radius': -1},
          {'kind': 'UNKNOWN'},
        ],
      })!;
      expect(f.elements.map((e) => e.kind), [FigureElementKind.polygon]);
      // Square, padded bounds around the triangle.
      expect(f.xMin, lessThan(0));
      expect(f.xMax, greaterThan(4));
      expect(f.xMax - f.xMin, closeTo(f.yMax - f.yMin, 1e-9));
    });

    test('returns null for unknown type or inverted ranges', () {
      expect(Figure.tryParse({'type': 'PIE'}), isNull);
      expect(Figure.tryParse({'type': 'COORDINATE_PLANE', 'xMin': 5, 'xMax': 1, 'yMin': 0, 'yMax': 1}), isNull);
      expect(Figure.tryParse(null), isNull);
    });

    test('parses #AARRGGBB colors', () {
      expect(parseHexColor('#80112233')!.toARGB32(), 0x80112233);
      expect(parseHexColor('red'), isNull);
    });
  });

  group('function expressions', () {
    test('supports the spec operators, functions and constants', () {
      expect(evaluateFigureExpression('x^2 + 1', 3), closeTo(10, 1e-9));
      expect(evaluateFigureExpression('sin(pi/2)', 0), closeTo(1, 1e-9));
      expect(evaluateFigureExpression('cot(x)', 1), closeTo(0.642092616, 1e-6));
      expect(evaluateFigureExpression('log(x)', 100), closeTo(2, 1e-9));
      expect(evaluateFigureExpression('ln(e)', 0), closeTo(1, 1e-9));
      expect(evaluateFigureExpression('exp(x)', 1), closeTo(2.718281828, 1e-6));
      expect(evaluateFigureExpression('sqrt(abs(x))', -9), closeTo(3, 1e-9));
    });

    test('accepts implicit multiplication', () {
      expect(evaluateFigureExpression('2x + 1', 2), closeTo(5, 1e-9));
      expect(evaluateFigureExpression('3(x-1)', 2), closeTo(3, 1e-9));
    });

    test('invalid input yields null instead of throwing', () {
      expect(evaluateFigureExpression('x +* )', 1), isNull);
    });
  });
}
