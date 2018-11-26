import 'dart:core';
import 'dart:math';
import 'matrix.dart';

enum VectorType { row, column }

/// The Vector class
///
/// Most of the class code is not optimized for high
/// performance but for readability. You should be
/// able to read the functions and understand what
/// is going on with basic linear algebra knowledge.
///
/// The vector can be either a row or column vector.
class Vector {
  Vector._(this._matrix, this._vectorType) {
    if (_vectorType == VectorType.row && this._matrix.m != 1) {
      throw MatrixInvalidDimensions("A row vector must have m=1");
    }
    if (_vectorType == VectorType.column && this._matrix.n != 1) {
      throw MatrixInvalidDimensions("A row vector must have n=1");
    }
  }

  /// Converts a [Matrix] to a [Vector] if one of its dimensions is 1
  /// will throw [MatrixInvalidDimensions] if that is not the case.
  factory Vector.fromMatrix(Matrix matrix) {
    if (matrix.m == 1) {
      return Vector._(matrix, VectorType.row);
    } else if (matrix.n == 1) {
      return Vector._(matrix, VectorType.column);
    }
    throw MatrixInvalidDimensions(
        "n or m must be 1 to be able to cast to a vector.");
  }

  /// Creates a row vector from the list of values given.
  ///
  /// ```dart
  /// Vector v = Vector.row([1.0,2.0,3.0]);
  /// print(v)
  /// ```
  ///
  /// prints
  /// [1.0,2.0,3.0]
  factory Vector.row(List<double> values) {
    return Vector._(Matrix([values]), VectorType.row);
  }

  /// Creates a column vector from the list of values given.
  ///
  /// ```dart
  /// Vector v = Vector.column([1.0,2.0,3.0]);
  /// print(v)
  /// ```
  ///
  /// prints
  /// [
  ///   1.0,
  ///   2.0,
  ///   3.0
  /// ]
  factory Vector.column(List<double> values) {
    return Vector._(
        Matrix(List<List<double>>.generate(values.length, (index) {
          return List<double>.filled(1, values[index]);
        })),
        VectorType.column);
  }

  /// Creates a row vector with [count] elements filled with [fill]
  ///
  /// ```dart
  /// Vector v = Vector.row(3, 1.0);
  /// print(v)
  /// ```
  ///
  /// prints
  /// [1.0,1.0,1.0]
  factory Vector.fillRow(int count, [double fill = 0.0]) {
    return Vector.row(List<double>.filled(count, fill));
  }

  /// Creates a column vector with [count] elements filled with [fill]
  ///
  /// ```dart
  /// Vector v = Vector.fillColumn(3, 1.0);
  /// print(v)
  /// ```
  ///
  /// prints
  /// [
  ///   1.0,
  ///   1.0,
  ///   1.0
  /// ]
  factory Vector.fillColumn(int count, [double fill = 0.0]) {
    return Vector.column(List<double>.filled(count, fill));
  }

  final VectorType _vectorType;
  final Matrix _matrix;

  /// Access the [element]'s value in the vector.
  ///
  /// ```dart
  /// Vector v = Vector.column([1.0,2.0,3.0]);
  /// print(v[1])
  /// ```
  ///
  /// prints
  /// 2.0
  ///
  double operator [](int element) {
    if (_vectorType == VectorType.row) {
      return _matrix[0][element];
    } else {
      return _matrix[element][0];
    }
  }

  /// Returns the number of elements in the vector.
  int get elements => _vectorType == VectorType.row ? _matrix.n : _matrix.m;

  /// Returns the [VectorType] of the vector.
  VectorType get type => _vectorType;

  /// Returns the magnitude or length of the vector.
  ///
  /// ```dart
  /// Vector v = Vector([1.0, 1.0, 1.0]);
  /// print(v.magnitude());
  /// ```
  ///
  /// will print 1.7320508
  ///
  double magnitude() {
    double v = 0.0;
    for (int i = 0; i < elements; i++) {
      v += this[i] * this[i];
    }
    return sqrt(v);
  }

  /// Transposes a Vector from row or column to column or row.
  ///
  /// ```dart
  /// Vector v = Vector.fillRow(3, 1.0);
  /// print(v.transpose())
  /// ```
  ///
  /// prints
  /// [
  ///   1.0,
  ///   1.0,
  ///   1.0
  /// ]
  Vector transpose() {
    return Vector._(_matrix.transpose(),
        _vectorType == VectorType.row ? VectorType.column : VectorType.row);
  }

  /// Adds two vectors
  ///
  /// ```dart
  /// Vector a = Vector.fillRow(3, 1.0);
  /// Vector b = Vector.fillRow(3, 2.0);
  /// print( a + b )
  /// ```
  ///
  /// prints
  /// [3.0,3.0,3.0]
  Vector operator +(Vector other) {
    return Vector._(other._matrix + this._matrix, _vectorType);
  }

  /// Subtracts two vectors
  ///
  /// ```dart
  /// Vector a = Vector.fillRow(3, 3.0);
  /// Vector b = Vector.fillRow(3, 1.0);
  /// print( a + b )
  /// ```
  ///
  /// prints
  /// [2.0,2.0,2.0]
  Vector operator -(Vector other) {
    return Vector._(this._matrix - other._matrix, _vectorType);
  }

  /// Negate all values
  ///
  /// This is the same as multiplying the vector with -1.
  Vector operator ~() {
    return map((x) => -x);
  }

  /// Multiplies two vectors, note the return value is a [Matrix]!
  ///
  /// ```dart
  /// Vector a = Vector.fillRow(3, 3.0);
  /// Vector b = Vector.column(3, 3.0);
  /// print( a * b )
  /// ```
  ///
  /// prints
  /// [27.0]
  Matrix operator *(dynamic other) {
    return this._matrix * other;
  }

  /// Returns true if the vectors are the same ( or close with 1e-9 relative )
  @override
  bool operator ==(dynamic other) {
    return this._matrix == other;
  }

  /// Maps this [Vector] via function [f] to a new Vector.
  ///
  /// ```dart
  /// Vector a = Vector.fillRow(3, 3.0);
  /// Vector b = a.map((v) => v*2);
  /// print( b )
  /// ```
  ///
  /// prints
  /// [6.0, 6.0, 6.0]
  Vector map(MatrixMapFunc f) {
    Matrix toReturn = new Matrix.fill(this._matrix.m, this._matrix.n);
    for (int i = 0; i < this._matrix.m; i++) {
      for (int j = 0; j < this._matrix.n; j++) {
        toReturn[i][j] = f(this._matrix[i][j]);
      }
    }
    return Vector._(toReturn, _vectorType);
  }

  /// Normalizes this [Vector] to have magnitude 1.0
  ///
  /// ```dart
  /// Vector a = Vector.fillRow(4, 4.0);
  /// Vector b = a.normalize()
  /// print( b )
  /// ```
  ///
  /// prints
  /// [0.5, 0.5, 0.5, 0.5]
  Vector normalize() {
    return Vector.fromMatrix(this._matrix * (1.0 / magnitude()));
  }

  /// Returns the [hashCode] for the matrix.
  @override
  int get hashCode => _matrix.hashCode;

  /// Prints the content of the matrix.
  @override
  String toString() {
    if (_vectorType == VectorType.row) {
      return _matrix[0].toString();
    } else {
      String l = '[\n';
      for (int i = 0; i < elements; i++) {
        l += "\t${_matrix[i][0]},\n";
      }
      l += ']\n';
      return l;
    }
  }

  /// Returns the [Matrix] representation of this [Vector]
  Matrix toMatrix() {
    return _matrix;
  }
}
