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

Future<List<List<String>>> readFileParagraphsAsync(String path) async {
  var lines = await File(path).readAsLines();
  List<List<String>> rv = List.empty(growable: true);
  List<String> paragraph = List.empty(growable: true);
  for (var line in lines) {
    if (line.isNotEmpty) {
      paragraph.add(line);
    } else {
      rv.add(paragraph);
      paragraph = List.empty(growable: true);
    }
  }
  rv.add(paragraph);
  return rv;
}
