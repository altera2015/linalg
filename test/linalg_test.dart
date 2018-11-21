import 'package:flutter_test/flutter_test.dart';

import 'package:linalg/linalg.dart';

void main() {

  test('Matrix value access tests', () {
    final Matrix mt = Matrix( [ [1.0, 3.0 ], [5.0,-2.0] ]);
    expect(mt[0][0], 1.0);
    expect(mt[0][1], 3.0);
    expect(mt[1][0], 5.0);
    expect(mt[1][1], -2.0);
  });

  test('Matrix fill test', () {
    final Matrix m = Matrix.fill(2,2,10.0);
    expect(m[0][0], 10.0);
    expect(m[0][1], 10.0);
    expect(m[1][0], 10.0);
    expect(m[1][1], 10.0);
  });

  test('Matrix Cut test', () {

    final Matrix m = Matrix( [
      [1.0, 2.0, 3.0],
      [4.0, 5.0, 6.0],
      [7.0, 8.0, 9.0],
    ]);

    final Matrix expected = Matrix( [
      [1.0, 3.0],
      [7.0, 9.0]
    ]);

    expect(m.cut(1,1), expected);
  });

  test('2x2 Matrix Determinant test', () {

    expect(Matrix( [ [1.0, 3.0 ],  [5.0, -2.0]]).det(), -17);
    expect(Matrix( [ [2.0, 1.0 ],  [4.0,  2.0]]).det(), 0);
    expect(Matrix( [ [4.0, -1.0 ], [-3.0, 2.0]]).det(), 5);
    expect(Matrix( [ [4.0, -3.0 ], [1.0,  2.0]]).det(), 11);

  });

  test('3x3 Matrix Determinant test', () {

    expect(Matrix( [ [1.0, 3.0, 2.0 ],  [4.0,1.0,3.0],  [2.0,2.0,0.0  ]]).det(), 24);
    expect(Matrix( [ [1.0, 0.0, 2.0 ],  [1.0,3.0,4.0],  [0.0,6.0,0.0  ]]).det(), -12);
    expect(Matrix( [ [3.0, -2.0, 4.0 ], [2.0,-4.0,5.0], [1.0,8.0,2.0  ]]).det(), -66);
    expect(Matrix( [ [8.0, -1.0, 9.0 ], [3.0,1.0,8.0],  [11.0,0.0,17.0]]).det(), 0);

  });

  test('4x4 Matrix Determinant test', () {
    expect(Matrix( [ [1.0, 2.0, 1.0, 0.0 ], [0.0,3.0,1.0, 1.0], [-1.0,0.0,3.0,1.0], [3.0,1.0,2.0,0.0]]).det(), 16);
  });

  test('4x4 Matrix Determinant test', () {
    expect(Matrix( [ [1.0, 2.0, 1.0, 0.0 ], [0.0,3.0,1.0, 1.0], [-1.0,0.0,3.0,1.0], [3.0,1.0,2.0,0.0]]).det(), 16);
  });

  test('Co Factors Matrix test', () {
    expect(Matrix([ [3.0, 0.0, 2.0], [2.0, 0.0, -2.0], [0.0, 1.0, 1.0]]).coFactors(), Matrix([ [2.0, -2.0, 2.0], [2.0, 3.0, -3.0], [0.0, 10.0, 0.0]]));
  });

  test("Matrix Multiplication test", () {
    final Matrix a1 = Matrix([[1, 2], [3, 4]]);
    final Matrix b1 = Matrix([[2, 0], [1, 2]]);
    final Matrix e1 = Matrix([[4, 4], [10, 8]]);
    expect(a1 * b1, e1);

    final Matrix a2 = Matrix([[1, 2], [3, 4], [1, 2]]);
    final Matrix b2 = Matrix([[2, 0], [1, 2]]);
    final Matrix e2 = Matrix([[4, 4], [10, 8], [4, 4]]);
    expect(a2 * b2, e2);
  });

  test("Matrix inversion", () {
    final Matrix a = Matrix([[4.0,7.0],[2.0,6.0]]);
    expect(a.inverse(), Matrix([[0.6, -0.7],[-0.2,0.4]]));
  });


}
