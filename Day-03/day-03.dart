import 'package:aoc_2022/helpers.dart' as helpers;

Future<int> part1() async {
  var sacks = await helpers.readFileLinesAsync('Day-03/input.txt');

  return sacks
      .map((sack) => calculatePriority(sack))
      .reduce((value, element) => value + element);
}

Future<int> part2() async {
  var sacks = await helpers.readFileLinesAsync('Day-03/input.txt');
  var pSum = 0;
  for (var i = 0; i < sacks.length; i += 3) {
    pSum += calculateGroupPriority(sacks[i], sacks[i + 1], sacks[i + 2]);
  }

  return pSum;
}

int calculatePriority(String sack) {
  var sackMiddlePosition = sack.length ~/ 2;
  var firstCompartment = sack.substring(0, sackMiddlePosition);
  var secondCompartment = sack.substring(sackMiddlePosition);

  var overlap = firstCompartment.runes
      .toSet()
      .intersection(secondCompartment.runes.toSet());

  return convertRuneToPriority(overlap.first);
}

int calculateGroupPriority(String sack1, String sack2, String sack3) {
  var overlap = sack1.runes
      .toSet()
      .intersection(sack2.runes.toSet().intersection(sack3.runes.toSet()));

  return convertRuneToPriority(overlap.first);
}

int convertRuneToPriority(int rune) {
  final letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
  return letters.indexOf(String.fromCharCode(rune)) + 1;
}
