import 'dart:math';
import 'package:aoc_2022/helpers.dart';
import 'package:tuple/tuple.dart';
import "dart:io";

//4397 is too low
Future<int> part1() async {
  var mapInput = await readFileLinesAsync('Day-18/input.txt');
  var map = <List<List<int>>>[];
  var cubeCoords = <Tuple3<int, int, int>>[];

  var maxLength = 30;

  //Build empty space
  map = List.generate(maxLength, (index) => <List<int>>[]);
  for (var z = 0; z < maxLength; z++) {
    map[z] = List.generate(maxLength, (index) => <int>[]);
    for (var y = 0; y < maxLength; y++) {
      map[z][y] = List.generate(maxLength, (index) => 0);
    }
  }

  //Mark cubes
  for (var line in mapInput) {
    var splitCoords = line.split(",").map((e) => int.parse(e) + 1).toList();
    cubeCoords.add(Tuple3(splitCoords[0], splitCoords[1], splitCoords[2]));
    map[splitCoords[2]][splitCoords[1]][splitCoords[0]] = 1;
  }

  var surfaceArea = 0;
  for (var current in cubeCoords) {
    var neighbors = map.getNeighbors(current);
    for (var neighbor in neighbors) {
      if (map[neighbor.item3][neighbor.item2][neighbor.item1] == 0) {
        surfaceArea++;
      }
    }
  }

  return surfaceArea;
}

Future<int> part2() async {
  var mapInput = await readFileLinesAsync('Day-18/input.txt');
  var map = <List<List<int>>>[];
  var cubeCoords = <Tuple3<int, int, int>>[];

  var maxLength = 30;

  //Build empty space
  map = List.generate(maxLength, (index) => <List<int>>[]);
  for (var z = 0; z < maxLength; z++) {
    map[z] = List.generate(maxLength, (index) => <int>[]);
    for (var y = 0; y < maxLength; y++) {
      map[z][y] = List.generate(maxLength, (index) => 0);
    }
  }

  //Mark cubes
  for (var line in mapInput) {
    var splitCoords = line.split(",").map((e) => int.parse(e) + 1).toList();
    cubeCoords.add(Tuple3(splitCoords[0], splitCoords[1], splitCoords[2]));
    map[splitCoords[2]][splitCoords[1]][splitCoords[0]] = 2;
  }

  floodFill(map, maxLength);

  var surfaceArea = 0;
  for (var current in cubeCoords) {
    var neighbors = map.getNeighbors(current);
    for (var neighbor in neighbors) {
      if (map[neighbor.item3][neighbor.item2][neighbor.item1] == 1) {
        surfaceArea++;
      }
    }
  }

  printLava(map);
  return surfaceArea;
}

//Is this position the same material and connected?
bool isValid(List<List<List<int>>> map, Tuple3<int, int, int> coord, int target,
    int maxLength) {
  if (coord.item3 >= maxLength ||
      coord.item2 >= maxLength ||
      coord.item1 >= maxLength) {
    return false;
  }
  if (map[coord.item3][coord.item2][coord.item1] == target) {
    return true;
  }
  return false;
}

void floodFill(List<List<List<int>>> map, int maxLength) {
  var queue = <Tuple3<int, int, int>>[];
  queue.add(Tuple3(0, 0, 0));
  map[0][0][0] = 1;

  while (queue.isNotEmpty) {
    var current = queue.removeAt(0);

    for (var neighbor in map.getNeighbors(current)) {
      if (isValid(map, neighbor, 0, maxLength)) {
        map[neighbor.item3][neighbor.item2][neighbor.item1] = 1;
        queue.add(neighbor);
      }
    }
  }
}

void printLava(List<List<List<int>>> map) {
  for (var z = 0; z < map.length; z++) {
    for (var y = 0; y < map[z].length; y++) {
      for (var x = 0; x < map[z][y].length; x++) {
        stdout.write(map[z][y][x]);
      }
      print("");
    }
    print("");
  }
}
