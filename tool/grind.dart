// import 'dart:async';
//
// import 'package:grinder/grinder.dart';
// // import 'package:coverage/coverage.dart';
// // import 'dart:io';
// // import 'package:grinder_coveralls/grinder_coveralls.dart' as coveralls;
//
// /// Starts the build system.
// Future<void> main(List<String> args) => grind(args);
//
// @Task('Uploads the results of the code coverage')
// Future<void> upload() async {
//   // final coverage = await getFile('lcov.info').readAsString();
//   // await coveralls.uploadCoverage(coverage);
// }
//
// @Task('Runs the test suites')
// Future<void> test() async {
//   await coveralls.collectCoverage(getFile('test/test_all.dart'), saveAs: 'lcov.info', basePath: Directory.current.path, reportOn: ["lib"]);
// }
