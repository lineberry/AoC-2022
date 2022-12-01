import 'package:aoc_2022/helpers.dart' as helpers;

Future<String> part1() async {
  var contents = helpers.readFileAsync('Day-01/part1.txt');
  return contents;
}

Future<List<String>> part2() async {
  var contents = helpers.readFileLinesAsync('Day-01/part2.txt');
  return contents;
}
