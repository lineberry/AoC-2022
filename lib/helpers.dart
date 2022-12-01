import 'dart:io';

int calculate() {
  return 6 * 7;
}

Future<String> readFileAsync(String path) async {
  var results = await File(path).readAsString();
  return results;
}

Future<List<String>> readFileLinesAsync(String path) async {
  var results = await File(path).readAsLines();
  return results;
}
