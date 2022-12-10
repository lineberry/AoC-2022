import 'package:aoc_2022/helpers.dart';
import 'package:tuple/tuple.dart';

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

class Rope {
  Tuple2<int, int> head = Tuple2<int, int>(0, 0);
  List<Tuple2<int, int>> tailList = [];
  Set<Tuple2<int, int>> tailTrail = <Tuple2<int, int>>{};

  Rope(int tailSize) {
    for (var i = 0; i < tailSize; i++) {
      tailList.add(Tuple2<int, int>(0, 0));
    }
  }

  void move(String direction, int distance) {
    for (var i = 0; i < distance; i++) {
      switch (direction) {
        case "U":
          head = Tuple2(head.item1, head.item2 + 1);
          break;
        case "D":
          head = Tuple2(head.item1, head.item2 - 1);
          break;
        case "L":
          head = Tuple2(head.item1 - 1, head.item2);
          break;
        case "R":
          head = Tuple2(head.item1 + 1, head.item2);
          break;
      }
      _moveTail();
    }
  }

  void _moveTail() {
    for (var i = 0; i < tailList.length; i++) {
      var leader = head;
      if (i > 0) {
        leader = tailList[i - 1];
      }
      var follower = tailList[i];
      if (getDistance(leader, follower) >= 2) {
        tailList[i] = Tuple2(
            follower.item1 + leader.item1.compareTo(follower.item1),
            follower.item2 + leader.item2.compareTo(follower.item2));
      }
      if (i == tailList.length - 1) {
        tailTrail.add(follower);
      }
    }
  }
}
