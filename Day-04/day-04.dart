import 'package:aoc_2022/helpers.dart' as helpers;

class Assignment {
  int range1Lower = 0;
  int range1Upper = 0;
  int range2Lower = 0;
  int range2Upper = 0;

  Assignment(String stringAssignment) {
    var range1 = stringAssignment.split(",")[0];
    var range2 = stringAssignment.split(",")[1];
    range1Lower = int.parse(range1.split("-")[0]);
    range1Upper = int.parse(range1.split("-")[1]);
    range2Lower = int.parse(range2.split("-")[0]);
    range2Upper = int.parse(range2.split("-")[1]);
  }
}

Future<int> part1() async {
  var assignments = await helpers.readFileLinesAsync('Day-04/input.txt');

  return assignments
      .map((a) => Assignment(a))
      .map((ca) => doesAssignmentCompletelyOverlap(ca))
      .reduce((value, element) => value + element);
}

Future<int> part2() async {
  var assignments = await helpers.readFileLinesAsync('Day-04/input.txt');

  return assignments
      .map((a) => Assignment(a))
      .map((ca) => doesAssignmentPartiallyOverlap(ca))
      .reduce((value, element) => value + element);
}

int doesAssignmentCompletelyOverlap(Assignment assignment) {
  //Does 1 contain 2?
  if (assignment.range1Lower <= assignment.range2Lower &&
      assignment.range1Upper >= assignment.range2Upper) {
    return 1;
  }
  //Does 2 contain 1?
  if (assignment.range2Lower <= assignment.range1Lower &&
      assignment.range2Upper >= assignment.range1Upper) {
    return 1;
  }
  return 0;
}

int doesAssignmentPartiallyOverlap(Assignment assignment) {
  if (assignment.range1Upper < assignment.range2Lower ||
      assignment.range2Upper < assignment.range1Lower) {
    return 0;
  }
  return 1;
}
