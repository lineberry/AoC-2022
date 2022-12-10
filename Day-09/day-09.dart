import 'package:aoc_2022/helpers.dart';

Future<int> part1() async {
  var instructions = await readFileLinesAsync('Day-09/input.txt');
  var rope = Rope(1);

  for (var instruction in instructions) {
    step(instruction, rope);
  }

  return rope.tailTrail.length;
}

Future<int> part2() async {
  var instructions = await readFileLinesAsync('Day-09/input.txt');
  var rope = Rope(9);

  for (var instruction in instructions) {
    step(instruction, rope);
  }

  return rope.tailTrail.length;
}

void step(String instruction, Rope rope) {
  var direction = instruction.split(" ")[0];
  var distance = int.parse(instruction.split(" ")[1]);
  rope.move(direction, distance);
}
