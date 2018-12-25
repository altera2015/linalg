## [0.3.1] -- 12/24/2018

* Fixed Vector.toList and Vector.toMatrix to return deepCopies by default. Added optional parameters
  to return references where possible for optimization use.

## [0.3.0] -- 12/24/2018

* Added matrix.columnVector, Matrix.rowVector and Matrix.copy
* Changed toVector to create a deep copy by default, but allowed it to reuse Matrix storage for performance.

## [0.2.0] -- 12/15/2018

* Added Vector.sum, Vector.mean, Vector.norm, Vector.manhattanNorm and Vector.toList with tests and docs.
* Deprecated Vector.distance for the better name Vector.norm.

## [0.1.1] -- 11/27/2018

* Documentation updates
* Added Matrix.trace, Vector.crossProduct and Vector.dotProduct

## [0.1.0] -- 11/26/2018

* Slight documentation modifications.

## [0.0.6] -- 11/26/2018

* Added Vector class.

## [0.0.5] -- 11/21/2018

* Dart minimum back to 2.0.0 fixed linter errors.

## [0.0.4] -- 11/21/2018

* Increased Dart minimum to 2.1.0 to allow int to double assignments.

## [0.0.3] -- 11/21/2018

* Removed flutter dependency

## [0.0.2] - 11/21/2018

* Added examples
* Added Travis CI
* Improved readme

## [0.0.1] - 11/21/2018.

* Initial release

