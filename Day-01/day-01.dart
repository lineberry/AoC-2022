import 'package:aoc_2022/helpers.dart' as helpers;

Future<int> part1() async {
  var contents = await helpers.readFileLinesAsync('Day-01/part1.txt');
  var maxSeen = 0;
  var currentElfCalories = 0;

  for (var line in contents) {
    if (line.isNotEmpty) {
      var snackCalories = int.parse(line);
      currentElfCalories += snackCalories;
    } else {
      if (currentElfCalories > maxSeen) {
        maxSeen = currentElfCalories;
      }
      currentElfCalories = 0;
    }
  }

  return maxSeen;
}

Future<int> part2() async {
  var contents = await helpers.readFileLinesAsync('Day-01/part1.txt');

  var currentElfCalories = 0;
  var calorieList = <int>[];

  for (var line in contents) {
    if (line.isNotEmpty) {
      var snackCalories = int.parse(line);
      currentElfCalories += snackCalories;
    } else {
      calorieList.add(currentElfCalories);
      currentElfCalories = 0;
    }
  }
  calorieList.sort(); //Sorts low to high
  return calorieList.reversed
      .take(3)
      .reduce((value, element) => value + element);
}
