import 'package:aoc_2022/helpers.dart';
import 'package:tuple/tuple.dart';
import "dart:io";
import 'dart:math';

Future<int> part1() async {
  var instructions = await readFileAsync("Day-17/input.txt");

  var game = TetrisGame(instructions.split(""));

  while (game.pieceCounter < 2022) {
    game.step();
  }

  // game.instructionRepeatMap.entries
  //     .where((element) => element.value > 1)
  //     .forEach((element) => print(
  //         "Repeated instruction at index ${element.key} ${element.value} times"));

  game.printGame();
  print("There are ${game.pieceCounter} pieces.");
  return game.getTowerHeight();
}

class TetrisGame {
  Map<int, int> instructionRepeatMap = {0: 0};
  int pieceCounter = 0;
  List<String> instructions;
  int instructionCounter = 0;
  List<String>? activePiece;
  Tuple2<int, int> pieceCoords = Tuple2(3, 0);
  List<String> horizonPiece = ["@@@@"];
  List<String> plusPiece = [
    ".@.",
    "@@@",
    ".@.",
  ];
  List<String> lPiece = [
    "..@",
    "..@",
    "@@@",
  ];
  List<String> linePiece = [
    "@",
    "@",
    "@",
    "@",
  ];
  List<String> squarePiece = [
    "@@",
    "@@",
  ];
  late List<List<String>> pieceList;
  List<String> playArea = ["+-------+"];

  TetrisGame(this.instructions) {
    pieceList = [horizonPiece, plusPiece, lPiece, linePiece, squarePiece];
    activePiece = horizonPiece;
    addPieceToPlayArea();
  }

  void step() {
    //If there are no moving pieces create a new one
    if (activePiece == null) {
      addPieceToPlayArea();
    }

    //Push piece left or right
    var nextInstruction = getNextInstruction();
    pushPiece(nextInstruction);
    //printGame();
    //Drop piece down
    dropPiece();
    //printGame();
  }

  List<String> getNextPiece() {
    return pieceList[pieceCounter % pieceList.length];
  }

  String getNextInstruction() {
    return instructions[instructionCounter % instructions.length];
  }

  int getTowerHeight() {
    for (var y = 0; y < playArea.length; y++) {
      if (playArea[y].contains("#")) {
        return playArea.length - (y + 1);
      }
    }
    return 0;
  }

  void pushPiece(String instruction) {
    if (instruction == "<") {
      //print("attempting to move left.");
      //Check to see if piece can go left
      if (pieceCanGoLeft()) {
        pieceCoords = Tuple2(pieceCoords.item1 - 1, pieceCoords.item2);
      }
    } else {
      //print("attempting to move right");
      //Check to see if piece can go right
      if (pieceCanGoRight()) {
        pieceCoords = Tuple2(pieceCoords.item1 + 1, pieceCoords.item2);
      }
    }
    renderActivePiece();
    instructionCounter++;
  }

  void dropPiece() {
    //Check to see if piece can go down
    if (pieceCanGoDown()) {
      //print("dropping piece");
      pieceCoords = Tuple2(pieceCoords.item1, pieceCoords.item2 + 1);
      renderActivePiece();
    } else {
      //print("locking piece in");
      renderCompletePiece();
    }
  }

  void addPieceToPlayArea() {
    activePiece = getNextPiece();
    pieceCoords = Tuple2(3, 0);
    var openLines = playArea.length - getTowerHeight() - 1;

    if (openLines > 0) {
      playArea.removeRange(0, openLines);
    }

    playArea.insertAll(
        0, List.generate(activePiece!.length + 3, (index) => "|.......|"));
    renderActivePiece();
  }

  void renderActivePiece() {
    for (var y = 0; y < playArea.length; y++) {
      playArea[y] = playArea[y].replaceAll("@", ".");
    }
    if (activePiece == horizonPiece) {
      playArea[pieceCoords.item2] = playArea[pieceCoords.item2]
          .replaceRange(pieceCoords.item1, pieceCoords.item1 + 4, "@@@@");
    }
    if (activePiece == plusPiece) {
      playArea[pieceCoords.item2] = playArea[pieceCoords.item2]
          .replaceRange(pieceCoords.item1 + 1, pieceCoords.item1 + 2, "@");
      playArea[pieceCoords.item2 + 1] = playArea[pieceCoords.item2 + 1]
          .replaceRange(pieceCoords.item1, pieceCoords.item1 + 3, "@@@");
      playArea[pieceCoords.item2 + 2] = playArea[pieceCoords.item2 + 2]
          .replaceRange(pieceCoords.item1 + 1, pieceCoords.item1 + 2, "@");
    }
    if (activePiece == lPiece) {
      playArea[pieceCoords.item2] = playArea[pieceCoords.item2]
          .replaceRange(pieceCoords.item1 + 2, pieceCoords.item1 + 3, "@");
      playArea[pieceCoords.item2 + 1] = playArea[pieceCoords.item2 + 1]
          .replaceRange(pieceCoords.item1 + 2, pieceCoords.item1 + 3, "@");
      playArea[pieceCoords.item2 + 2] = playArea[pieceCoords.item2 + 2]
          .replaceRange(pieceCoords.item1, pieceCoords.item1 + 3, "@@@");
    }
    if (activePiece == linePiece) {
      playArea[pieceCoords.item2] = playArea[pieceCoords.item2]
          .replaceRange(pieceCoords.item1, pieceCoords.item1 + 1, "@");
      playArea[pieceCoords.item2 + 1] = playArea[pieceCoords.item2 + 1]
          .replaceRange(pieceCoords.item1, pieceCoords.item1 + 1, "@");
      playArea[pieceCoords.item2 + 2] = playArea[pieceCoords.item2 + 2]
          .replaceRange(pieceCoords.item1, pieceCoords.item1 + 1, "@");
      playArea[pieceCoords.item2 + 3] = playArea[pieceCoords.item2 + 3]
          .replaceRange(pieceCoords.item1, pieceCoords.item1 + 1, "@");
    }
    if (activePiece == squarePiece) {
      playArea[pieceCoords.item2] = playArea[pieceCoords.item2]
          .replaceRange(pieceCoords.item1, pieceCoords.item1 + 2, "@@");
      playArea[pieceCoords.item2 + 1] = playArea[pieceCoords.item2 + 1]
          .replaceRange(pieceCoords.item1, pieceCoords.item1 + 2, "@@");
    }
  }

  void renderCompletePiece() {
    for (var y = 0; y < playArea.length; y++) {
      playArea[y] = playArea[y].replaceAll("@", "#");
    }
    if (activePiece == horizonPiece) {
      var instructionIndex = instructionCounter % instructions.length;
      if (instructionIndex == 1190) {
        print("Rock count is ${pieceCounter + 1}");
        print("Instruction index is $instructionIndex.");
        print("Rock index is ${pieceCounter % pieceList.length}.");
        print("Tower height is ${getTowerHeight()}");
        print("");
      }
      if (instructionRepeatMap.containsKey(instructionIndex)) {
        var value = instructionRepeatMap[instructionIndex]!;
        instructionRepeatMap[instructionIndex] = value + 1;
      } else {
        instructionRepeatMap[instructionIndex] = 1;
      }
    }
    activePiece = null;
    pieceCounter++;
  }

  bool pieceCanGoLeft() {
    if (activePiece == horizonPiece) {
      if (playArea[pieceCoords.item2][pieceCoords.item1 - 1] != ".") {
        return false;
      }
    }
    if (activePiece == squarePiece) {
      if (playArea[pieceCoords.item2][pieceCoords.item1 - 1] != "." ||
          playArea[pieceCoords.item2 + 1][pieceCoords.item1 - 1] != ".") {
        return false;
      }
    }
    if (activePiece == plusPiece) {
      if (playArea[pieceCoords.item2][pieceCoords.item1] != "." ||
          playArea[pieceCoords.item2 + 1][pieceCoords.item1 - 1] != "." ||
          playArea[pieceCoords.item2 + 2][pieceCoords.item1] != ".") {
        return false;
      }
    }
    if (activePiece == lPiece) {
      if (playArea[pieceCoords.item2][pieceCoords.item1 + 1] != "." ||
          playArea[pieceCoords.item2 + 1][pieceCoords.item1 + 1] != "." ||
          playArea[pieceCoords.item2 + 2][pieceCoords.item1 - 1] != ".") {
        return false;
      }
    }
    if (activePiece == linePiece) {
      if (playArea[pieceCoords.item2][pieceCoords.item1 - 1] != "." ||
          playArea[pieceCoords.item2 + 1][pieceCoords.item1 - 1] != "." ||
          playArea[pieceCoords.item2 + 2][pieceCoords.item1 - 1] != "." ||
          playArea[pieceCoords.item2 + 3][pieceCoords.item1 - 1] != ".") {
        return false;
      }
    }
    return true;
  }

  bool pieceCanGoRight() {
    if (activePiece == horizonPiece) {
      if (playArea[pieceCoords.item2][pieceCoords.item1 + 4] != ".") {
        return false;
      }
    }
    if (activePiece == squarePiece) {
      if (playArea[pieceCoords.item2][pieceCoords.item1 + 2] != "." ||
          playArea[pieceCoords.item2 + 1][pieceCoords.item1 + 2] != ".") {
        return false;
      }
    }
    if (activePiece == lPiece) {
      if (playArea[pieceCoords.item2][pieceCoords.item1 + 3] != "." ||
          playArea[pieceCoords.item2 + 1][pieceCoords.item1 + 3] != "." ||
          playArea[pieceCoords.item2 + 2][pieceCoords.item1 + 3] != ".") {
        return false;
      }
    }
    if (activePiece == plusPiece) {
      if (playArea[pieceCoords.item2][pieceCoords.item1 + 2] != "." ||
          playArea[pieceCoords.item2 + 1][pieceCoords.item1 + 3] != "." ||
          playArea[pieceCoords.item2 + 2][pieceCoords.item1 + 2] != ".") {
        return false;
      }
    }
    if (activePiece == linePiece) {
      if (playArea[pieceCoords.item2][pieceCoords.item1 + 1] != "." ||
          playArea[pieceCoords.item2 + 1][pieceCoords.item1 + 1] != "." ||
          playArea[pieceCoords.item2 + 2][pieceCoords.item1 + 1] != "." ||
          playArea[pieceCoords.item2 + 3][pieceCoords.item1 + 1] != ".") {
        return false;
      }
    }

    return true;
  }

  bool pieceCanGoDown() {
    if (activePiece == horizonPiece) {
      if (playArea[pieceCoords.item2 + 1][pieceCoords.item1] != "." ||
          playArea[pieceCoords.item2 + 1][pieceCoords.item1 + 1] != "." ||
          playArea[pieceCoords.item2 + 1][pieceCoords.item1 + 2] != "." ||
          playArea[pieceCoords.item2 + 1][pieceCoords.item1 + 3] != ".") {
        return false;
      }
    }
    if (activePiece == plusPiece) {
      if (playArea[pieceCoords.item2 + 2][pieceCoords.item1] != "." ||
          playArea[pieceCoords.item2 + 3][pieceCoords.item1 + 1] != "." ||
          playArea[pieceCoords.item2 + 2][pieceCoords.item1 + 2] != ".") {
        return false;
      }
    }
    if (activePiece == lPiece) {
      if (playArea[pieceCoords.item2 + 3][pieceCoords.item1] != "." ||
          playArea[pieceCoords.item2 + 3][pieceCoords.item1 + 1] != "." ||
          playArea[pieceCoords.item2 + 3][pieceCoords.item1 + 2] != ".") {
        return false;
      }
    }
    if (activePiece == linePiece) {
      if (playArea[pieceCoords.item2 + 4][pieceCoords.item1] != ".") {
        return false;
      }
    }
    if (activePiece == squarePiece) {
      if (playArea[pieceCoords.item2 + 2][pieceCoords.item1] != "." ||
          playArea[pieceCoords.item2 + 2][pieceCoords.item1 + 1] != ".") {
        return false;
      }
    }
    return true;
  }

  void printGame() {
    // for (var line in playArea) {
    //   print(line);
    // }
    for (var i = 0; i < 15; i++) {
      if (i < playArea.length) {
        print(playArea[i]);
      }
    }
    print("");
  }
}
