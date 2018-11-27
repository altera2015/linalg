library linalg.test.vector;

import 'package:test/test.dart';
import 'package:linalg/linalg.dart';
import 'dart:math';

void main() {
  group("Vector", () {
    test("Row Vector Creation", () {
      final Vector a = Vector.row([1.0, 2.0, 3.0]);
      expect(a[0], 1.0);
      expect(a[1], 2.0);
      expect(a[2], 3.0);
    });
    test("Filled Row Vector Creation", () {
      final Vector b = Vector.fillRow(3, 1.0);
      expect(b[0], 1.0);
      expect(b[1], 1.0);
      expect(b[2], 1.0);
    });
    test("Column Vector Creation", () {
      final Vector c = Vector.column([1.0, 2.0, 3.0]);
      expect(c[0], 1.0);
      expect(c[1], 2.0);
      expect(c[2], 3.0);
    });
    test("Filled Column Vector Creation", () {
      final Vector d = Vector.fillColumn(3, 1.0);
      expect(d[0], 1.0);
      expect(d[1], 1.0);
      expect(d[2], 1.0);
    });

    test("from Matrix 1x3", () {
      final Matrix m = Matrix([
        [1.0, 2.0, 3.0]
      ]);
      final Vector v = m.toVector();
      expect(v, Vector.row([1.0, 2.0, 3.0]));
      expect(v.type, VectorType.row);
    });

    test("from Matrix 3x1", () {
      final Matrix m = Matrix([
        [1.0],
        [2.0],
        [3.0]
      ]);
      final Vector v = m.toVector();
      expect(v, Vector.column([1.0, 2.0, 3.0]));
      expect(v.type, VectorType.column);
    });

    test("magnitude", () {
      final Vector c = Vector.column([1.0, 2.0, 3.0]);
      expect(c.magnitude(), sqrt(14));
    });

    test("transpose", () {
      final Vector c = Vector.column([1.0, 2.0, 3.0]);
      final Vector tc = c.transpose();
      expect(tc, Vector.row([1.0, 2.0, 3.0]));
    });

    test("add", () {
      final Vector a = Vector.column([1.0, 2.0, 3.0]);
      final Vector b = Vector.fillColumn(3, 1.0);
      expect(a + b, Vector.column([2.0, 3.0, 4.0]));
    });

    test("subtract", () {
      final Vector a = Vector.column([1.0, 2.0, 3.0]);
      final Vector b = Vector.fillColumn(3, 1.0);
      expect(a - b, Vector.column([0.0, 1.0, 2.0]));
    });

    test("multiply Vector x Vector", () {
      final Vector a = Vector.row([2.0, 3.0, 4.0]);
      final Vector b = Vector.column([1.0, 2.0, 3.0]);
      expect(
          a * b,
          Matrix([
            [20.0]
          ]));
    });

    test("multiply Matrix x Vector", () {
      final Matrix a = Matrix([
        [2.0, 3.0, 4.0],
        [3.0, 4.0, 5.0]
      ]);
      final Vector b = Vector.column([1.0, 2.0, 3.0]);
      expect(
          a * b,
          Matrix([
            [20.0],
            [26.0]
          ]));
    });

    test("equality", () {
      final Vector a = Vector.column([1.0, 2.0, 3.0]);
      final Vector b = Vector.column([1.0, 2.0, 3.0]);
      expect(a == b, true);
    });

    test("map", () {
      final Vector a = Vector.column([1.0, 2.0, 3.0]);
      expect(a.map((double a) => a * 2), Vector.column([2.0, 4.0, 6.0]));
    });

    test("normalize", () {
      final Vector a = Vector.fillRow(4, 4.0);
      expect(a.normalize(), Vector.row([0.5, 0.5, 0.5, 0.5]));
    });

    test("negate", () {
      final Vector a = Vector.fillRow(4, 4.0);
      expect(~a, Vector.fillRow(4, -4.0));
    });

    test("toString row", () {
      final Vector a = Vector.fillRow(4, 4.0);
      expect(a.toString(), "[4.0, 4.0, 4.0, 4.0]");
    });

    test("toString column", () {
      final Vector a = Vector.fillColumn(4, 4.0);
      expect(a.toString(), "[\n\t4.0,\n\t4.0,\n\t4.0,\n\t4.0\n]\n");
    });

    test("crossProduct", () {
      final Vector a = Vector.column([2.0, 3.0, 4.0]);
      final Vector b = Vector.column([5.0, 6.0, 7.0]);
      expect(a.crossProduct(b), Vector.column([-3.0, 6.0, -3.0]));
    });

    test("dotProduct", () {
      final Vector a = Vector.column([2.0, 3.0, 4.0]);
      final Vector b = Vector.column([5.0, 6.0, 7.0]);
      expect(a.dotProduct(b), 56.0);
    });

    test("Exception: Matrix to Vector that is not a vector", () {
      final Matrix a = Matrix.eye(2);
      expect(() => Vector.fromMatrix(a),
          throwsA(TypeMatcher<MatrixInvalidDimensions>()));
    });

    test("Exception: crossProduct on 4d Vector", () {
      final Vector a = Vector.fillColumn(4);
      final Vector b = Vector.fillColumn(4);
      expect(() => a.crossProduct(b),
          throwsA(TypeMatcher<MatrixUnsupportedOperation>()));
    });

    test("Exception: crossProduct on disparate vectors", () {
      final Vector a = Vector.fillColumn(3);
      final Vector b = Vector.fillColumn(2);
      expect(() => a.crossProduct(b),
          throwsA(TypeMatcher<MatrixInvalidDimensions>()));
    });

    test("Exception: dotProduct on disparate vectors", () {
      final Vector a = Vector.fillColumn(3);
      final Vector b = Vector.fillColumn(2);
      expect(() => a.dotProduct(b),
          throwsA(TypeMatcher<MatrixInvalidDimensions>()));
    });
  });
}
