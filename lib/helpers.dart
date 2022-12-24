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

int getGridDistance(Tuple2<int, int> point1, Tuple2<int, int> point2) {
  return (point2.item1 - point1.item1).abs() +
      (point2.item2 - point1.item2).abs();
}

List<int> extractDigitsFromString(String inputString) {
  return RegExp(r"(\d+)")
      .allMatches(inputString)
      .map((m) => m[0]!)
      .map(int.parse)
      .toList();
}

extension GridNeighbors<T> on List<List<T>> {
  List<Tuple2<int, int>> getNeighbors(Tuple2<int, int> current) {
    var rv = <Tuple2<int, int>>[];

    //add up
    if (current.item2 > 0) {
      rv.add(Tuple2(current.item1, current.item2 - 1));
    }
    //add down
    if (current.item2 < length - 1) {
      rv.add(Tuple2(current.item1, current.item2 + 1));
    }
    //add right
    if (length > 0 && current.item1 < this[0].length - 1) {
      rv.add(Tuple2(current.item1 + 1, current.item2));
    }
    //add left
    if (current.item1 > 0) {
      rv.add(Tuple2(current.item1 - 1, current.item2));
    }

    return rv;
  }
}

extension SpaceNeighbors<T> on List<List<List<T>>> {
  List<Tuple3<int, int, int>> getNeighbors(Tuple3<int, int, int> current) {
    var rv = <Tuple3<int, int, int>>[];

    //add Z
    if (current.item3 > 0) {
      rv.add(Tuple3(current.item1, current.item2, current.item3 - 1));
    }
    if (current.item3 < length) {
      rv.add(Tuple3(current.item1, current.item2, current.item3 + 1));
    }

    //add y
    if (current.item2 > 0) {
      rv.add(Tuple3(current.item1, current.item2 - 1, current.item3));
    }
    if (current.item2 < this[0].length) {
      rv.add(Tuple3(current.item1, current.item2 + 1, current.item3));
    }

    //add x
    if (current.item1 > 0) {
      rv.add(Tuple3(current.item1 - 1, current.item2, current.item3));
    }
    if (current.item1 < this[0][0].length) {
      rv.add(Tuple3(current.item1 + 1, current.item2, current.item3));
    }

    return rv;
  }
}
