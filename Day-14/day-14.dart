import 'package:aoc_2022/helpers.dart';
import 'package:tuple/tuple.dart';
import "dart:io";
import 'dart:math';

Future<int> part1() async {
  var mapInput = await readFileLinesAsync('Day-14/input.txt');

  var mapMaxX = 1000;
  var mapMaxY = 200;
  var mapXOffset = 0;
  var infiniteFloorY = 166;

  //Populate Map
  var map = <List<String>>[];
  map = List.generate(mapMaxY, (index) => <String>[]);
  for (var x = 0; x < map.length; x++) {
    map[x] = List.generate(mapMaxX, (index) => ".");
  }

  for (var line in mapInput) {
    var splitLine = line.split(" -> ");
    for (var i = 0; i < splitLine.length; i++) {
      if (i > 0) {
        var point1Coords = splitLine[i - 1].split(",").map(int.parse).toList();
        var point2Coords = splitLine[i].split(",").map(int.parse).toList();
        var xCoord1 = point1Coords[0] - mapXOffset;
        var yCoord1 = point1Coords[1];
        var xCoord2 = point2Coords[0] - mapXOffset;
        var yCoord2 = point2Coords[1];

        drawLine(map, Tuple2(xCoord1, yCoord1), Tuple2(xCoord2, yCoord2));
      }
    }
  }

  //Add a floor foor part 2
  drawLine(map, Tuple2(0, infiniteFloorY), Tuple2(999, infiniteFloorY));

  var state = SandSimulationState(map, Tuple2(500, 0));
  var sim = SandSimulation(state);

  //while sand is still accumulating
  while (true) {
    sim.moveSand();
  }
}

void drawLine(
    List<List<String>> map, Tuple2<int, int> point1, Tuple2<int, int> point2) {
  if (point1.item1 != point2.item1) {
    //horizontal line
    var length = (point2.item1 - point1.item1).abs() + 1;
    var startingX = point2.item1 < point1.item1 ? point2.item1 : point1.item1;
    for (var i = 0; i < length; i++) {
      map[point1.item2][startingX + i] = "#";
    }
  } else {
    //vertical line
    var length = (point2.item2 - point1.item2).abs() + 1;
    var startingY = point2.item2 < point1.item2 ? point2.item2 : point1.item2;
    for (var i = 0; i < length; i++) {
      map[startingY + i][point1.item1] = "#";
    }
  }
}

void printMap(List<List<String>> map) {
  for (var y = 0; y < map.length; y++) {
    for (var x = 0; x < map[y].length; x++) {
      stdout.write(map[y][x]);
    }
    print("");
  }
  print("");
}

void printState(SandSimulationState state) {
  for (var y = 0; y < state.map.length; y++) {
    for (var x = 0; x < state.map[y].length; x++) {
      if (y == state.currentSand.item2 && x == state.currentSand.item1) {
        stdout.write("o");
      } else {
        stdout.write(state.map[y][x]);
      }
    }
    print("");
  }
  print("");
}

class SandSimulation {
  late SandSimulationState state;

  SandSimulation(this.state);

  void moveSand() {
    //Move down if possible
    var yYositionToCheck = state.currentSand.item2 + 1;
    var xPositionToCheck = state.currentSand.item1;

    if (yYositionToCheck >= state.map.length) {
      printState(state);
      print("Current sand count = ${state.sandCount}.");
      throw Exception("Flowing off edge.");
    }

    if (state.map[yYositionToCheck][xPositionToCheck] == ".") {
      state.currentSand = Tuple2(xPositionToCheck, yYositionToCheck);
      return;
    }

    //Move diagonally left down if possible
    xPositionToCheck = state.currentSand.item1 - 1;
    if (state.map[yYositionToCheck][xPositionToCheck] == ".") {
      state.currentSand = Tuple2(xPositionToCheck, yYositionToCheck);
      return;
    }

    //Move diagonally right down if possible
    xPositionToCheck = state.currentSand.item1 + 1;
    if (state.map[yYositionToCheck][xPositionToCheck] == ".") {
      state.currentSand = Tuple2(xPositionToCheck, yYositionToCheck);
      return;
    }

    state.map[state.currentSand.item2][state.currentSand.item1] = "o";
    state.sandCount++;

    if (state.currentSand.item2 == 0 && state.currentSand.item1 == 500) {
      printState(state);
      print("Current sand count = ${state.sandCount}.");
      throw Exception("Done filled up!");
    }

    state.currentSand = Tuple2(500, 0);
    //printState(state);
  }
}

class SandSimulationState {
  List<List<String>> map = <List<String>>[];
  Tuple2<int, int> currentSand = Tuple2(500, 0);
  int sandCount = 0;

  SandSimulationState(this.map, this.currentSand);
}
