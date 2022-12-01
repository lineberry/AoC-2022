import 'package:aoc_2022/helpers.dart' as helpers;

//Find out how many calories the elf with the most calories has
Future<int> part1() async {
  var contents = await helpers.readFileParagraphsAsync('Day-01/part1.txt');
  var calorieList = <int>[];

  //Sum up all the calories for each elf into a new list
  for (var elfSnacks in contents) {
    calorieList.add(
        elfSnacks.map(int.parse).reduce((value, element) => value + element));
  }

  calorieList.sort(); //Sorts low to high
  return calorieList.reversed.first;
}

//Find out how many calories the top 3 elfs with the most calories have
Future<int> part2() async {
  var contents = await helpers.readFileParagraphsAsync('Day-01/part1.txt');
  var calorieList = <int>[];

  //Sum up all the calories for each elf into a new list
  for (var elfSnacks in contents) {
    calorieList.add(
        elfSnacks.map(int.parse).reduce((value, element) => value + element));
  }

  calorieList.sort(); //Sorts low to high
  return calorieList.reversed
      .take(3)
      .reduce((value, element) => value + element);
}
