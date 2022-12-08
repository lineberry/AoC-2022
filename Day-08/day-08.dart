import 'package:aoc_2022/helpers.dart';

Future<int> part1() async {
  var treeMatrixLines = await readFileLinesAsync('Day-08/input.txt');

  var treeMatrix = <List<int>>[];

  for (var y = 0; y < treeMatrixLines.length; y++) {
    treeMatrix.add(treeMatrixLines[y].split("").map(int.parse).toList());
  }

  var visibleCounter = 0;
  for (var y = 0; y < treeMatrix.length; y++) {
    for (var x = 0; x < treeMatrix[y].length; x++) {
      visibleCounter += isTreeVisisble(treeMatrix, x, y);
    }
  }

  return visibleCounter;
}

Future<int> part2() async {
  var treeMatrixLines = await readFileLinesAsync('Day-08/input.txt');

  var treeMatrix = <List<int>>[];

  for (var y = 0; y < treeMatrixLines.length; y++) {
    treeMatrix.add(treeMatrixLines[y].split("").map(int.parse).toList());
  }

  var highestScenicScore = 0;
  for (var y = 0; y < treeMatrix.length; y++) {
    for (var x = 0; x < treeMatrix[y].length; x++) {
      var scenicScore = getTreeScenicScore(treeMatrix, x, y);
      if (scenicScore > highestScenicScore) {
        highestScenicScore = scenicScore;
      }
    }
  }

  return highestScenicScore;
}

int isTreeVisisble(List<List<int>> treeMatrix, int xIndex, int yIndex) {
  if ([0, 98].contains(xIndex) || [0, 98].contains(yIndex)) {
    return 1; //If the tree is on the edge, it is visible
  }

  var visibleNorth = true;
  var visibleSouth = true;
  var visibleEast = true;
  var visibleWest = true;

  //Check North
  for (var y = 0; y < yIndex; y++) {
    if (treeMatrix[y][xIndex] >= treeMatrix[yIndex][xIndex]) {
      visibleNorth = false;
      break;
    }
  }
  //Don't check other directions if we know it is visible already
  if (visibleNorth) {
    return 1;
  }
  //Check South
  for (var y = 98; y > yIndex; y--) {
    if (treeMatrix[y][xIndex] >= treeMatrix[yIndex][xIndex]) {
      visibleSouth = false;
      break;
    }
  }
  //Don't check other directions if we know it is visible already
  if (visibleSouth) {
    return 1;
  }
  //Check East
  for (var x = 98; x > xIndex; x--) {
    if (treeMatrix[yIndex][x] >= treeMatrix[yIndex][xIndex]) {
      visibleEast = false;
      break;
    }
  }
  //Don't check other directions if we know it is visible already
  if (visibleEast) {
    return 1;
  }
  //Check West
  for (var x = 0; x < xIndex; x++) {
    if (treeMatrix[yIndex][x] >= treeMatrix[yIndex][xIndex]) {
      visibleWest = false;
      break;
    }
  }
  if (visibleWest) {
    return 1;
  }

  return 0;
}

int getTreeScenicScore(List<List<int>> treeMatrix, int xIndex, int yIndex) {
  if ([0, 98].contains(xIndex) || [0, 98].contains(yIndex)) {
    return 0; //If the tree is on the edge, it's score will be 0
  }

  var northScore = 0;
  var southScore = 0;
  var eastScore = 0;
  var westScore = 0;

  //Look North
  for (var y = yIndex - 1; y >= 0; y--) {
    northScore += 1;
    if (treeMatrix[y][xIndex] >= treeMatrix[yIndex][xIndex]) {
      break;
    }
  }
  //Look South
  for (var y = yIndex + 1; y <= 98; y++) {
    southScore += 1;
    if (treeMatrix[y][xIndex] >= treeMatrix[yIndex][xIndex]) {
      break;
    }
  }
  //Look East
  for (var x = xIndex + 1; x <= 98; x++) {
    eastScore += 1;
    if (treeMatrix[yIndex][x] >= treeMatrix[yIndex][xIndex]) {
      break;
    }
  }
  //Look West
  for (var x = xIndex - 1; x >= 0; x--) {
    westScore += 1;
    if (treeMatrix[yIndex][x] >= treeMatrix[yIndex][xIndex]) {
      break;
    }
  }

  return northScore * southScore * eastScore * westScore;
}
