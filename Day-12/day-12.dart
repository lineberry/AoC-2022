import 'package:aoc_2022/helpers.dart';
import 'package:collection/collection.dart';
import 'package:tuple/tuple.dart';
import "dart:io";

//482 is too high
//481 is too high
//480 is too high
//479 is too high
//478 is too high

Future<int> part1() async {
  var mapInput = await readFileLinesAsync('Day-12/input.txt');
  var map = <List<int>>[];
  var originalMap = <List<String>>[];

  for (var line in mapInput) {
    map.add(List.generate(line.length, (index) => line.split("")[index])
        .map(convertLetterToElevation)
        .toList());

    originalMap
        .add(List.generate(line.length, (index) => line.split("")[index]));
  }

  //return traverseMap(map, Tuple2(0, 0), Tuple2(5, 2), originalMap);
  //return traverseMap(map, Tuple2(0, 20), Tuple2(120, 20), originalMap);

  var shortestPath = 999999999;
  for (var y = 0; y < map.length; y++) {
    var pathLength =
        traverseMap(map, Tuple2(0, y), Tuple2(120, 20), originalMap);

    if (pathLength < shortestPath) {
      shortestPath = pathLength;
    }
  }

  return shortestPath;
}

int traverseMap(List<List<int>> map, Tuple2<int, int> startIndex,
    Tuple2<int, int> endIndex, List<List<String>> originalMap) {
  var openSet = PriorityQueue<Tuple2<int, int>>(((p0, p1) =>
      getGridDistance(p1, endIndex).compareTo(getGridDistance(p0, endIndex))));

  var cameFrom = <Tuple2<int, int>, Tuple2<int, int>>{};
  var gScore = <Tuple2<int, int>, int>{};
  var fScore = <Tuple2<int, int>, int>{};

  for (var y = 0; y < map.length; y++) {
    for (var x = 0; x < map[y].length; x++) {
      gScore[Tuple2(x, y)] = 9999999;
      fScore[Tuple2(x, y)] = 9999999;
    }
  }

  gScore[startIndex] = 0;
  fScore[startIndex] = getGridDistance(startIndex, endIndex);

  openSet.add(startIndex);

  while (openSet.isNotEmpty) {
    var current = openSet.first;
    if (current == endIndex) {
      //printPath(cameFrom, current, originalMap);
      return getPathLength(cameFrom, current);
    }

    openSet.remove(current);
    for (var neighbor in map.getNeighbors(current)) {
      var currentElevation = map[current.item2][current.item1];
      var neighborElevation = map[neighbor.item2][neighbor.item1];
      if (neighborElevation - currentElevation >= 2) {
        //Can only step 1 up, but down any number
        continue;
      }

      var tentativeGScore = gScore[current]! + 1;
      if (tentativeGScore < gScore[neighbor]!) {
        cameFrom[neighbor] = current;
        gScore[neighbor] = tentativeGScore;
        fScore[neighbor] =
            tentativeGScore + getGridDistance(neighbor, endIndex);
        if (!openSet.contains(neighbor)) {
          openSet.add(neighbor);
        }
      }
    }
  }

  return 999999999;
}

void printPath(Map<Tuple2<int, int>, Tuple2<int, int>> cameFrom,
    Tuple2<int, int> current, List<List<String>> originalMap) {
  var rv = <Tuple2<int, int>>[];
  rv.add(current);

  while (cameFrom.containsKey(current)) {
    current = cameFrom[current]!;
    rv.add(current);
  }

  for (var coord in rv) {
    originalMap[coord.item2][coord.item1] = "0";
  }

  for (var y = 0; y < originalMap.length; y++) {
    for (var x = 0; x < originalMap[y].length; x++) {
      stdout.write(originalMap[y][x]);
    }
    print("");
  }
}

int getPathLength(Map<Tuple2<int, int>, Tuple2<int, int>> cameFrom,
    Tuple2<int, int> current) {
  var rv = <Tuple2<int, int>>[];
  rv.add(current);

  while (cameFrom.containsKey(current)) {
    current = cameFrom[current]!;
    rv.add(current);
  }

  return rv.length - 1;
}

int convertLetterToElevation(String letter) {
  if (letter == "S") {
    return 0;
  }
  if (letter == "E") {
    return 25;
  }

  final letters = "abcdefghijklmnopqrstuvwxyz";
  return letters.indexOf(letter);
}
