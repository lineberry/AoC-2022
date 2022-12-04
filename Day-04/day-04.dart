import 'package:aoc_2022/helpers.dart' as helpers;

Future<int> part1() async {
  var assignments = await helpers.readFileLinesAsync('Day-04/input.txt');

  return assignments
      .map((e) => e.split(RegExp(r",|-")).map(int.parse).toList())
      .map((e) => doesAssignmentCompletelyOverlap(e))
      .reduce((value, element) => value + element);
}

Future<int> part2() async {
  var assignments = await helpers.readFileLinesAsync('Day-04/input.txt');

  return assignments
      .map((e) => e.split(RegExp(r",|-")).map(int.parse).toList())
      .map((e) => doesAssignmentPartiallyOverlap(e))
      .reduce((value, element) => value + element);
}

int doesAssignmentCompletelyOverlap(List<int> assignmentBounds) {
  //Does 1 contain 2?
  if (assignmentBounds[0] <= assignmentBounds[2] &&
      assignmentBounds[1] >= assignmentBounds[3]) {
    return 1;
  }
  //Does 2 contain 1?
  if (assignmentBounds[2] <= assignmentBounds[0] &&
      assignmentBounds[3] >= assignmentBounds[1]) {
    return 1;
  }
  return 0;
}

int doesAssignmentPartiallyOverlap(List<int> assignmentBounds) {
  if (assignmentBounds[1] < assignmentBounds[2] ||
      assignmentBounds[3] < assignmentBounds[0]) {
    return 0;
  }
  return 1;
}
