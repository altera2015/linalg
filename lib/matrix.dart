import 'dart:math';
import 'dart:core';
import 'vector.dart';

typedef double MatrixMapFunc(double x);

/// Base class of all Matrix class exceptions.
class MatrixException implements Exception {
  MatrixException(this.cause);
  String cause;
}

/// An exception that is thrown when [invert] is called on a non-invertable matrix.
class MatrixNoInverseException extends MatrixException {
  MatrixNoInverseException([String cause = "No inverse for this matrix"])
      : super(cause);
}

/// An exception that is thrown if the dimensions are invalid for the operation.
class MatrixInvalidDimensions extends MatrixException {
  MatrixInvalidDimensions([String cause = "Invalid dimensions"]) : super(cause);
}

/// An exception that is thrown if the operations is not supported on the type passed.
class MatrixUnsupportedOperation extends MatrixException {
  MatrixUnsupportedOperation([String cause = "Unsupported operation"])
      : super(cause);
}

/// The Matrix class
///
/// Most of the class code is not optimized for high
/// performance but for readability. You should be
/// able to read the functions and understand what
/// is going on with basic linear algebra knowledge.
///
/// ```dart
///final Matrix a = Matrix([[1, 2], [3, 4]]);
///final Vector b = Vector.column([2, 3]);
///final Matrix e = Matrix([[8], [18]]);
///Matrix result = a * b;
///print(result);
///print(result == e);
///```
///This prints
///```dart
///[[8.0], [18.0]]
///true
///```
class Matrix {
  /// Constructs a matrix from a List<List<double>> value.
  ///
  /// ```dart
  /// Matrix a = Matrix([[1.0,2.0],[3.0,4.0],[5.0,6.0]])
  /// ```
  Matrix(this._values);

  /// Constructs a [m]x[n] (rows x cols) Matrix fill with [fill=0.0].
  ///
  /// m and n must be positive and larger than 0.
  Matrix.fill(int m, int n, [double fill = 0.0])
      : _values = _createStore(m, n, fill);

  /// Constructs an identity matrix of [size]
  Matrix.eye(int size) : _values = _createStore(size, size, 0.0) {
    for (int i = 0; i < size; i++) {
      _values[i][i] = 1.0;
    }
  }

  final List<List<double>> _values;

  /// Returns the number of rows
  int get m => _values.length;

  /// Returns the number of columns
  int get n => _values[0].length;

  static List<List<double>> _createStore(int m, int n, double fill) {
    if (m <= 0 || n <= 0) {
      throw MatrixInvalidDimensions("m and n must be positive.");
    }
    List<List<double>> toRet = List<List<double>>();
    for (int i = 0; i < m; i++) {
      List<double> sub = [];
      for (int j = 0; j < n; j++) {
        sub.add(fill);
      }
      toRet.add(sub);
    }
    return toRet;
  }

  /// Access a row of data from the matrix
  ///
  /// To access a specific value use double brackets
  ///
  /// ```dart
  /// Matrix a = Matrix.eye(2)
  /// print( a[1][1] )
  /// ```
  ///
  /// Unlike math class indexes start at zero.
  List<double> operator [](int m) => _values[m];

  /// Multiply an Matrix with a Matrix or a scalar
  ///
  /// ```dart
  /// Matrix a = Matrix.eye(2);
  /// Matrix b = Matrix.fill(2,2, 10);
  ///
  /// print( a * b );
  /// ```
  ///
  /// Throws an [MatrixUnsupportedOperation] error if the
  /// requested multiplication is not valid. For example
  /// if matrices with the wrong dimensions are passed in.
  Matrix operator *(dynamic other) {
    double cutDot(Matrix other, int thisRow, int otherColumn) {
      double sum = 0.0;
      for (int i = 0; i < this.n; i++) {
        sum += this[thisRow][i] * other[i][otherColumn];
      }
      return sum;
    }

    if (other is Vector) {
      other = other.toMatrix();
    }

    if (other is Matrix) {
      if (this.n == other.m) {
        Matrix toReturn = Matrix.fill(this.m, other.n);
        for (int r = 0; r < toReturn.m; r++) {
          for (int c = 0; c < toReturn.n; c++) {
            toReturn[r][c] = cutDot(other, r, c);
          }
        }
        return toReturn;
      } else {
        throw MatrixInvalidDimensions();
      }
    } else if (other is num) {
      // scalar
      return this.map((x) => x * (other as num));
    } else
      throw MatrixUnsupportedOperation();
  }

  /// Add two matrices of same dimensions.
  ///
  /// Throws [MatrixInvalidDimensions] if dimensions do not match.
  Matrix operator +(Matrix other) {
    if (this.m != other.m || this.n != other.n)
      throw new MatrixInvalidDimensions();
    Matrix toReturn = new Matrix.fill(m, n);
    for (int i = 0; i < m; i++) {
      for (int j = 0; j < n; j++) {
        toReturn[i][j] = this[i][j] + other[i][j];
      }
    }
    return toReturn;
  }

  /// Subtract two matrices of same dimensions.
  ///
  /// Throws [MatrixInvalidDimensions] if dimensions do not match.
  Matrix operator -(Matrix other) {
    if (this.m != other.m || this.n != other.n)
      throw new MatrixInvalidDimensions();
    return this + ~other;
  }

  /// Negate all values
  ///
  /// This is the same as multiplying the matrix with -1.
  Matrix operator ~() {
    return this.map((x) => -x);
  }

  static bool _isClose(double a, double b,
      [double relTol = 1e-9, double absTol = 0.0]) {
    // double diff = a - b;
    // diff = diff.abs();
    return (a - b).abs() <= max(relTol * max(a.abs(), b.abs()), absTol);
  }

  /// Equality check for each element in the matrix.
  @override
  bool operator ==(dynamic other) {
    if (other is Vector) {
      other = other.toMatrix();
    }

    if (other is Matrix) {
      if (this.m == other.m && this.n == other.n) {
        for (int i = 0; i < m; i++) {
          for (int j = 0; j < n; j++) {
            if (!_isClose(this[i][j], other[i][j])) {
              return false;
            }
          }
        }
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  /// Returns the [hashCode] for the matrix.
  @override
  int get hashCode => _values.hashCode;

  /// Calls [f] for each element in the matrix and stores the result in a new matrix.
  ///
  /// ```dart
  /// Matrix a = Matrix.eye(3)
  /// a.map( (double v) {
  ///    return v*v;
  /// });
  /// print(a)
  /// ```
  /// with print
  /// ```dart
  /// [[ 9.0, 0.0, 0.0], [0.0, 9.0, 0.0], [0.0, 0.0, 9.0]]
  /// ```
  Matrix map(MatrixMapFunc f) {
    Matrix toReturn = new Matrix.fill(m, n);
    for (int i = 0; i < m; i++) {
      for (int j = 0; j < n; j++) {
        toReturn[i][j] = f(this[i][j]);
      }
    }
    return toReturn;
  }

  /// Transposes the matrix
  ///
  /// ```dart
  /// Matrix a = Matrix([[1.0,2.0],[3.0,4.0],[5.0,6.0]])
  /// print(a.transpose())
  /// ```
  ///
  /// will print
  ///
  /// ```
  /// [[1.0, 3.0, 5.0],[2.0,4.0,6.0]]
  /// ```
  Matrix transpose() {
    Matrix toReturn = new Matrix.fill(n, m);
    for (int i = 0; i < m; i++) {
      for (int j = 0; j < n; j++) {
        toReturn[j][i] = this[i][j];
      }
    }
    return toReturn;
  }

  /// Cuts the given column [m] and row [n] from the matrix and returns the remainder.
  ///
  /// ```dart
  /// Matrix m = Matrix( [
  ///   [1.0, 2.0, 3.0],
  ///   [4.0, 5.0, 6.0],
  ///   [7.0, 8.0, 9.0],
  /// ]);
  /// print(m.cut(1,1))
  /// ```
  ///
  /// prints
  ///
  /// ```dart
  /// [[1.0, 3.0], [7.0, 9.0]]
  /// ```
  Matrix cut(int m, int n) {
    Matrix cm = Matrix.fill(this.m - 1, this.n - 1, 0.0);

    int dr = 0;
    for (int r = 0; r < this.m; r++) {
      int dc = 0;
      if (r == m) {
        continue;
      }
      for (int c = 0; c < this.n; c++) {
        if (c == n) {
          continue;
        }
        cm[dr][dc] = _values[r][c];
        dc++;
      }
      dr++;
    }

    return cm;
  }

  /// Calculates the [determinant](https://en.wikipedia.org/wiki/Determinant) of the matrix.
  ///
  /// Throws [MatrixInvalidDimensions] if matrix is not square and at least a 2x2
  double det() {
    if (this.m != this.n) {
      throw new MatrixInvalidDimensions();
    }

    if (this.m < 2) {
      throw new MatrixInvalidDimensions();
    }

    if (this.m == 2) {
      return _values[0][0] * _values[1][1] - _values[1][0] * _values[0][1];
    }

    // should really pick a row or column with a lot of zeros.
    int bestColumnCount = 0;
    int bestColumn = -1;
    for (int c = 0; c < this.n; c++) {
      int count = 0;
      for (int r = 0; r < this.m; r++) {
        if (_values[r][c] == 0.0) {
          count++;
        }
      }
      if (count >= bestColumnCount) {
        bestColumnCount = count;
        bestColumn = c;
      }
    }

    int bestRowCount = 0;
    int bestRow = -1;
    for (int r = 0; r < this.m; r++) {
      int count = 0;
      for (int c = 0; c < this.n; c++) {
        if (_values[r][c] == 0.0) {
          count++;
        }
      }
      if (count >= bestRowCount) {
        bestRowCount = count;
        bestRow = r;
      }
    }

    if (bestColumnCount > bestRowCount) {
      double det = 0.0;
      int c = bestColumn;
      for (int r = 0; r < this.m; r++) {
        double v = this[r][c];
        if (v != 0.0) {
          Matrix sub = cut(r, c);
          double coFactor = pow(-1, r + c) * sub.det();
          det += v * coFactor;
        }
      }
      return det;
    } else {
      double det = 0.0;
      int r = bestRow;
      for (int c = 0; c < this.n; c++) {
        double v = this[r][c];
        if (v != 0.0) {
          Matrix sub = cut(r, c);
          double coFactor = pow(-1, r + c) * sub.det();
          det += v * coFactor;
        }
      }
      return det;
    }
  }

  /// Calculates the [Cofactors](https://en.wikipedia.org/wiki/Minor_(linear_algebra)) of the matrix.
  ///
  /// Throws [MatrixInvalidDimensions] if matrix is not square and at least a 3x3
  Matrix coFactors() {
    if (this.m != this.n) {
      throw MatrixInvalidDimensions();
    }

    if (this.m < 3) {
      throw MatrixInvalidDimensions();
    }

    Matrix cf = Matrix.fill(m, n, 0.0);

    for (int r = 0; r < this.m; r++) {
      for (int c = 0; c < this.n; c++) {
        Matrix sub = cut(r, c);
        double v = pow(-1, r + c) * sub.det();
        cf[r][c] = v;
      }
    }

    return cf;
  }

  /// Calculates the matrix [inverse](https://www.mathsisfun.com/algebra/matrix-inverse.html).
  ///
  /// Throws [MatrixNoInverseException] if there is no inverse of this matrix.
  /// Throws [MatrixInvalidDimensions] if the matrix was not square.
  Matrix inverse() {
    double d = det();
    if (_isClose(d, 0.0)) {
      throw new MatrixNoInverseException();
    }

    if (m == 2) {
      Matrix i = Matrix.fill(m, n);
      i[0][0] = this[1][1];
      i[1][1] = this[0][0];
      i[0][1] = -1.0 * this[0][1];
      i[1][0] = -1.0 * this[1][0];
      return i * (1 / d);
    } else {
      Matrix i = coFactors();
      i = i.transpose();
      return i * (1 / d);
    }
  }

  /// Prints the content of the matrix.
  @override
  String toString() => _values.toString();

  /// Returns the [Vector] representation of this [Matrix] if
  /// one of it's dimensions is 1.
  ///
  /// Throws [MatrixInvalidDimensions] if m or n are not 1.
  Vector toVector() {
    return Vector.fromMatrix(this);
  }
}
