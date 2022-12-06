import 'package:aoc_2022/helpers.dart';

Future<int> part1() async {
  var dataStream = await readFileAsync('Day-06/input.txt');

  for (var i = 0; i < dataStream.length - 4; i++) {
    var packetSet = dataStream.substring(i, i + 4).runes.toSet();
    if (packetSet.length == 4) {
      return i + 4;
    }
  }
  return 0;
}

Future<int> part2() async {
  var dataStream = await readFileAsync('Day-06/input.txt');

  for (var i = 0; i < dataStream.length - 14; i++) {
    var packetSet = dataStream.substring(i, i + 14).runes.toSet();
    if (packetSet.length == 14) {
      return i + 14;
    }
  }
  return 0;
}
