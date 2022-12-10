import 'dart:io';
import 'dart:math';
import 'package:tuple/tuple.dart';

int calculate() {
  return 6 * 7;
}

Future<String> readFileAsync(String path) async {
  var results = await File(path).readAsString();
  return results;
}

Future<List<String>> readFileLinesAsync(String path) async {
  var results = await File(path).readAsLines();
  return results;
}

Future<List<List<String>>> readFileParagraphsAsync(String path) async {
  var lines = await File(path).readAsLines();
  List<List<String>> rv = List.empty(growable: true);
  List<String> paragraph = List.empty(growable: true);
  for (var line in lines) {
    if (line.isNotEmpty) {
      paragraph.add(line);
    } else {
      rv.add(paragraph);
      paragraph = List.empty(growable: true);
    }
  }
  rv.add(paragraph);
  return rv;
}

class Stack<E> {
  final _list = <E>[];

  void push(E value) => _list.add(value);

  E pop() => _list.removeLast();

  List<E> popNum(int num) {
    var rv = _list.getRange(_list.length - num, _list.length).toList();
    _list.removeRange(_list.length - num, _list.length);
    return rv;
  }

  void pushList(List<E> list) {
    _list.addAll(list);
  }

  E get peek => _list.last;

  bool get isEmpty => _list.isEmpty;
  bool get isNotEmpty => _list.isNotEmpty;

  @override
  String toString() => _list.toString();
}

class ElfFile {
  String name;
  int size;

  ElfFile(this.name, this.size);
}

class ElfDirectory {
  String name;
  ElfDirectory? parent;
  int totalFileSize = 0;
  Map<String, ElfDirectory> children = <String, ElfDirectory>{};
  Map<String, ElfFile> files = <String, ElfFile>{};

  ElfDirectory(this.name, this.parent);
}

class ElfFileSystem {
  late ElfDirectory currentDirectory;
  late ElfDirectory root;
  List<ElfDirectory> directories = [];
}

double getDistance(Tuple2<int, int> point1, Tuple2<int, int> point2) {
  return sqrt(pow(point2.item1 - point1.item1, 2) +
      pow(point2.item2 - point1.item2, 2));
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
          _moveTail();
          break;
        case "D":
          head = Tuple2(head.item1, head.item2 - 1);
          _moveTail();
          break;
        case "L":
          head = Tuple2(head.item1 - 1, head.item2);
          _moveTail();
          break;
        case "R":
          head = Tuple2(head.item1 + 1, head.item2);
          _moveTail();
          break;
      }
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
        follower = Tuple2(
            follower.item1 + leader.item1.compareTo(follower.item1),
            follower.item2 + leader.item2.compareTo(follower.item2));
        tailList[i] = follower;
      }
      if (i == tailList.length - 1) {
        tailTrail.add(follower);
      }
    }
  }
}
