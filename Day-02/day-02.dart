import 'dart:math';
import 'package:aoc_2022/helpers.dart' as helpers;

Future<int> part1() async {
  var rounds = await helpers.readFileLinesAsync('Day-02/part1.txt');
  var totalScore = 0;
  for (var round in rounds) {
    totalScore += calculateScore(round);
  }
  return totalScore;
}

Future<int> part2() async {
  var rounds = await helpers.readFileLinesAsync('Day-02/part1.txt');
  var totalScore = 0;
  for (var round in rounds) {
    totalScore += calculateShape(round);
  }
  return totalScore;
}

int calculateScore(String round) {
  var score = 0;

  if (round.endsWith("X")) {
    score += 1;
  }
  if (round.endsWith("Y")) {
    score += 2;
  }
  if (round.endsWith("Z")) {
    score += 3;
  }

  switch (round) {
    case "A X": //Ties
    case "B Y":
    case "C Z":
      score += 3;
      break;
    case "A Y": //Wins
    case "B Z":
    case "C X":
      score += 6;
      break;
  }
  return score;
}

int calculateShape(String round) {
  var score = 0;
  var mine = round.split(" ")[1];

  //Ties
  if (mine == "Y") {
    score += 3;
  }
  //Wins
  if (mine == "Z") {
    score += 6;
  }

  switch (round) {
    case "A Y": //Rock
    case "B X":
    case "C Z":
      score += 1;
      break;
    case "B Y": //Paper
    case "C X":
    case "A Z":
      score += 2;
      break;
    case "C Y": //Scissor
    case "A X":
    case "B Z":
      score += 3;
      break;
  }

  return score;
}
