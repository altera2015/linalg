import 'package:linalg/linalg.dart';

/// Example code for using the Matrix class.
void main() {

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
  final Matrix B = Matrix([[2.0, 0.0], [1.0, 2.0]]);
  final Matrix E = Matrix([[4.0, 4.0], [10.0, 8.0]]);


  Matrix Bi = B.inverse();
  Matrix A_calc = E * Bi;

  final Matrix A = Matrix([[1.0, 2.0], [3.0, 4.0]]);
  print("The calculated A = $A_calc, the expected A is $A, they are ${A_calc==A?'':'not'} the same.");
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