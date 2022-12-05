import 'package:aoc_2022/helpers.dart';

List<Stack<String>> populateStacks() {
  List<Stack<String>> rv = <Stack<String>>[];
  rv.add(Stack<String>());
  rv[0].push("Z");
  rv[0].push("T");
  rv[0].push("F");
  rv[0].push("R");
  rv[0].push("W");
  rv[0].push("J");
  rv[0].push("G");

  rv.add(Stack<String>());
  rv[1].push("G");
  rv[1].push("W");
  rv[1].push("M");

  rv.add(Stack<String>());
  rv[2].push("J");
  rv[2].push("N");
  rv[2].push("H");
  rv[2].push("G");

  rv.add(Stack<String>());
  rv[3].push("J");
  rv[3].push("R");
  rv[3].push("C");
  rv[3].push("N");
  rv[3].push("W");

  rv.add(Stack<String>());
  rv[4].push("W");
  rv[4].push("F");
  rv[4].push("S");
  rv[4].push("B");
  rv[4].push("G");
  rv[4].push("Q");
  rv[4].push("V");
  rv[4].push("M");

  rv.add(Stack<String>());
  rv[5].push("S");
  rv[5].push("R");
  rv[5].push("T");
  rv[5].push("D");
  rv[5].push("V");
  rv[5].push("W");
  rv[5].push("C");

  rv.add(Stack<String>());
  rv[6].push("H");
  rv[6].push("B");
  rv[6].push("N");
  rv[6].push("C");
  rv[6].push("D");
  rv[6].push("Z");
  rv[6].push("G");
  rv[6].push("V");

  rv.add(Stack<String>());
  rv[7].push("S");
  rv[7].push("J");
  rv[7].push("N");
  rv[7].push("M");
  rv[7].push("G");
  rv[7].push("C");

  rv.add(Stack<String>());
  rv[8].push("G");
  rv[8].push("P");
  rv[8].push("N");
  rv[8].push("W");
  rv[8].push("C");
  rv[8].push("J");
  rv[8].push("D");
  rv[8].push("L");

  return rv;
}

Future<String> part1() async {
  var instructions = await readFileLinesAsync('Day-05/input.txt');
  var stacks = populateStacks();

  for (var instruction in instructions) {
    var digits = extractDigitsFromInstruction(instruction);
    performStackInstruction(digits[0], digits[1], digits[2], stacks);
  }

  return stacks.fold<String>("", (prev, next) => prev + next.peek);
}

Future<String> part2() async {
  var instructions = await readFileLinesAsync('Day-05/input.txt');
  var stacks = populateStacks();

  for (var instruction in instructions) {
    var digits = extractDigitsFromInstruction(instruction);
    performQueueInstruction(digits[0], digits[1], digits[2], stacks);
  }

  return stacks.fold<String>("", (prev, next) => prev + next.peek);
}

void performStackInstruction(
    int num, int source, int dest, List<Stack<String>> stacks) {
  //Pop the num from source and push to dest
  for (var i = 0; i < num; i++) {
    stacks[dest - 1].push(stacks[source - 1].pop());
  }
}

void performQueueInstruction(
    int num, int source, int dest, List<Stack<String>> stacks) {
  //Grab the last num from source and append to dest
  stacks[dest - 1].pushList(stacks[source - 1].popNum(num));
}

List<int> extractDigitsFromInstruction(String instruction) {
  return RegExp(r"(\d+)")
      .allMatches(instruction)
      .map((m) => m[0]!)
      .map(int.parse)
      .toList();
}
