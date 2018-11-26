![CI](https://travis-ci.com/altera2015/linalg.svg?branch=master) [![Pub](https://img.shields.io/pub/v/linalg.svg)](https://pub.dartlang.org/packages/linalg) [![Coverage Status](https://coveralls.io/repos/github/altera2015/linalg/badge.svg?branch=master)](https://coveralls.io/github/altera2015/linalg?branch=master)

# linalg

A Simple Linear Algebra Package. 

This package is intended to be a portable easy to use linear algebra package. It does not have any dependencies outside of flutter itself, thus making it portable and easy to integrate.

Our goal is to keep the code readable, documented and maintainable.

## Short Example

Just a quick example on how to do matrix multiplication.

```dart
final Matrix a = Matrix([[1, 2], [3, 4]]);
final Vector b = Vector.column([2, 3]);
final Matrix e = Matrix([[8], [18]]);
Matrix result = a * b;
print(result);
print(result == e);
```
This prints
```dart
[[8.0], [18.0]]
true
```

## Complete Example

A more extensive example with various matrix operations. See the [Matrix API](https://pub.dartlang.org/documentation/linalg/latest/linalg/Matrix-class.html) for the full details.

```dart
import 'package:linalg/linalg.dart';

void example() {
	// *****************************
	// Lets solve a linear equation.
	// *****************************
	//
	// A * B = E
	//
	// We have B and E, we have to find A.
	//
	// A * B * B' = E * B'
	//
	// Were B' = inverse of B.
	//
	// A * I = E * B'
	//
	// Where I = identity matrix
	//
	// A = E * B'
	final Matrix B = Matrix([[2, 0], [1, 2]]);
	final Matrix E = Matrix([[4, 4], [10, 8]]);


	Matrix Bi = B.inverse();
	Matrix A_calc = E * Bi;

	final Matrix A = Matrix([[1, 2], [3, 4]]);
	print("The calculated A_calc = $A_calc, the expected A is $A, they are ${A_calc==A?'':'not'} the same.");
	// Expected: The calculated A = [[1.0, 2.0], [3.0, 4.0]], the expected A is [[1.0, 2.0], [3.0, 4.0]], they are  the same.



	// *****************************
	// Lets do some more matrix math
	// *****************************
	//
	// Next let multiply Matrix A by 3.
	Matrix Am = A * 3.0;
	print(Am);
	// Expecting: [[3.0, 6.0], [9.0, 12.0]]

	// Now add matrix B to A
	Matrix AmPlusB = Am + B;
	print(AmPlusB);
	// Expecting: [[5.0, 6.0], [10.0, 14.0]]

	// What is the determinant of the A matrix?
	print("The determinant of A = ${A.det()}");
	// Expecting The determinant of A = -2.0
}
```

## Installation

Add linalg as a dependency to your flutter project.

```yaml
dependencies:
  linalg: ^0.0.5
```

and at the top of your dart file add:

```dart
import 'package:linalg/linalg.dart';
```

## Attribution

Original code came from:
https://pub.dartlang.org/packages/toaster_linear

We ended up rewriting considerable parts of the code and 
adding tests and documentation.
