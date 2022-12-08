import 'package:aoc_2022/helpers.dart';

Future<int> part1() async {
  var terminalOutput = await readFileLinesAsync('Day-07/input.txt');
  var fs = ElfFileSystem();
  var root = ElfDirectory("/", null);
  fs.directories.add(root);
  fs.root = root;
  fs.currentDirectory = root;

  for (var line in terminalOutput) {
    parseLine(line, fs);
  }

  calculateDirSizes(fs);

  var rv = fs.directories.where((d) => d.totalFileSize <= 100000).fold(
      0, (previousValue, element) => previousValue + element.totalFileSize);

  //Just go ahead and solve part 2 in here so I don't have to rebuild the tree.
  var freeSpace = 70000000 - fs.root.totalFileSize;
  var additionalSpaceNeeded = 30000000 - freeSpace;

  fs.directories.sort((a, b) => a.totalFileSize.compareTo(b.totalFileSize));
  print(fs.directories
      .firstWhere((element) => element.totalFileSize >= additionalSpaceNeeded)
      .totalFileSize);

  return rv;
}

void parseLine(String line, ElfFileSystem fs) {
  if (line.startsWith(r"$")) {
    var command = line.split(" ")[1];
    if (command == "cd") {
      var parameter = line.split(" ")[2];
      if (parameter == "..") {
        fs.currentDirectory = fs.currentDirectory.parent!;
      } else if (parameter == "/") {
        fs.currentDirectory = fs.root;
      } else {
        fs.currentDirectory = fs.currentDirectory.children[parameter]!;
      }
    } //ls is a no-op
  } else {
    var part1 = line.split(" ")[0]; //"dir" for directories. File size for files
    var name = line.split(" ")[1];
    if (part1 == "dir") {
      var newDir = ElfDirectory(name, fs.currentDirectory);
      fs.currentDirectory.children[name] = newDir;
      fs.directories.add(newDir);
    } else {
      var newFile = ElfFile(name, int.parse(part1));
      fs.currentDirectory.files[name] = newFile;
    }
  }
}

void calculateDirSizes(ElfFileSystem fs) {
  propigateDirSizes(fs, fs.root);
}

int propigateDirSizes(ElfFileSystem fs, ElfDirectory current) {
  current.totalFileSize += current.files.values
      .fold(0, (previousValue, element) => previousValue + element.size);

  for (var child in current.children.values) {
    current.totalFileSize += propigateDirSizes(fs, child);
  }

  return current.totalFileSize;
}
