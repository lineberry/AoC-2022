import 'package:aoc_2022/helpers.dart';

Future<int> part1() async {
  var instructions = await readFileLinesAsync('Day-10/input.txt');

  var specialCycles = [20, 60, 100, 140, 180, 220];
  var x = 1;
  var cycle = 0;
  var signalStrength = 0;
  for (var instruction in instructions) {
    if (instruction.startsWith("addx")) {
      var param = int.parse(instruction.split(" ")[1]);
      cycle++;
      if (specialCycles.contains(cycle)) {
        signalStrength += cycle * x;
      }
      cycle++;
      if (specialCycles.contains(cycle)) {
        signalStrength += cycle * x;
      }
      x += param;
    } else {
      cycle++;
      if (specialCycles.contains(cycle)) {
        signalStrength += cycle * x;
      }
    }
  }

  return signalStrength;
}

Future<void> part2() async {
  var instructions = await readFileLinesAsync('Day-10/input.txt');
  var screen = <List<String>>[];
  for (int y = 0; y < 6; y++) {
    var line = <String>[];
    for (int x = 0; x < 40; x++) {
      line.add(" ");
    }
    screen.add(line);
  }
  var newLineCycles = [40, 80, 120, 160, 200, 240];
  var x = 1;
  var cycle = 0;
  var pixelPosition = 0;
  var currentLineIndex = 0;
  for (var instruction in instructions) {
    if (instruction.startsWith("addx")) {
      var param = int.parse(instruction.split(" ")[1]);
      cycle++;
      if ([x - 1, x, x + 1].contains(pixelPosition)) {
        screen[currentLineIndex][pixelPosition] = "#";
      }
      pixelPosition++;
      if (newLineCycles.contains(cycle)) {
        pixelPosition = 0;
        currentLineIndex++;
      }
      cycle++;
      if ([x - 1, x, x + 1].contains(pixelPosition)) {
        screen[currentLineIndex][pixelPosition] = "#";
      }
      pixelPosition++;
      if (newLineCycles.contains(cycle)) {
        pixelPosition = 0;
        currentLineIndex++;
      }
      x += param;
    } else {
      cycle++;
      if ([x - 1, x, x + 1].contains(pixelPosition)) {
        screen[currentLineIndex][pixelPosition] = "#";
      }
      pixelPosition++;
      if (newLineCycles.contains(cycle)) {
        pixelPosition = 0;
        currentLineIndex++;
      }
    }
  }
  for (var line in screen) {
    print(line.join(""));
  }
}
