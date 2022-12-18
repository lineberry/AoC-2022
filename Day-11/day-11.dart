import 'package:aoc_2022/helpers.dart';

Future<int> part1() async {
  var monkeyInput = await readFileParagraphsAsync('Day-11/input.txt');

  //Parse and create monkeys
  var monkeys = parseMonkeys(monkeyInput);

  //Do 20 rounds of monkey business
  for (var i = 0; i < 20; i++) {
    doRoundOfMonkeyBusiness(monkeys);
  }

  //Find the two monkeys that inspected the most items;
  monkeys.sort((a, b) => b.inspectionCounter.compareTo(a.inspectionCounter));
  return monkeys[0].inspectionCounter * monkeys[1].inspectionCounter;
}

List<Monkey> parseMonkeys(List<List<String>> monkeyInput) {
  List<Monkey> monkeys = [];
  for (var monkeyLines in monkeyInput) {
    var monkey = Monkey();
    for (var i = 0; i < monkeyLines.length; i++) {
      if (i == 0) {
        monkey.id = extractDigitsFromString(monkeyLines[i])[0];
      }
      if (i == 1) {
        monkey.items =
            extractDigitsFromString(monkeyLines[i]).map(BigInt.from).toList();
      }
      if (i == 2) {
        var part2 = monkeyLines[i].split(" = ")[1];
        monkey.operator = part2.split(" ")[1];
        monkey.modifier = part2.split(" ")[2];
      }
      if (i == 3) {
        monkey.divisibleBy =
            BigInt.from(extractDigitsFromString(monkeyLines[i])[0]);
      }
      if (i == 4) {
        monkey.ifTrueThrowTo = extractDigitsFromString(monkeyLines[i])[0];
      }
      if (i == 5) {
        monkey.ifFalseThrowTo = extractDigitsFromString(monkeyLines[i])[0];
      }
    }
    monkeys.add(monkey);
  }
  return monkeys;
}

void doRoundOfMonkeyBusiness(List<Monkey> monkeys) {
  for (var monkey in monkeys) {
    for (var item in monkey.items) {
      monkey.inspectionCounter++;
      var newValue = monkey.operation(item);
      newValue = newValue ~/ BigInt.from(3);
      if (monkey.test(newValue)) {
        monkeys[monkey.ifTrueThrowTo].items.add(newValue);
      } else {
        monkeys[monkey.ifFalseThrowTo].items.add(newValue);
      }
    }
    monkey.items.clear();
  }
}

class Monkey {
  int id = 0;
  List<BigInt> items = [];
  BigInt divisibleBy = BigInt.from(1);
  int inspectionCounter = 0;
  int ifTrueThrowTo = 0;
  int ifFalseThrowTo = 0;
  String modifier = "old";
  String operator = "+";

  bool test(BigInt testValue) => testValue % divisibleBy == BigInt.from(0);
  BigInt operation(BigInt oldValue) {
    BigInt parsedModifier = BigInt.from(1);
    if (modifier == "old") {
      parsedModifier = oldValue;
    } else {
      parsedModifier = BigInt.parse(modifier);
    }
    switch (operator) {
      case "*":
        return oldValue * parsedModifier;
      case "+":
        return oldValue + parsedModifier;
    }
    return BigInt.from(0);
  }
}
