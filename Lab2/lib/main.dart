import 'package:flutter/material.dart';

Future<void> main() async {
  runExercise1();
  runExercise2();
  runExercise3();
  runExercise4();
  await runExercise5();

  runApp(const MyApp());
}

// =====================================================
// EXERCISE 1 - BASIC SYNTAX & DATA TYPES
// =====================================================

void runExercise1() {
  print("\n===== EXERCISE 1 =====");
  int age = 20;
  double height = 1.75;
  String name = "Nguyen Xuan Bac";
  bool isStudent = true;
  print("Name: $name");
  print("Age: $age");
  print("Height: $height meters");
  print("Is student: $isStudent");
  print("Next year, $name will be ${age + 1} years old.");
}

// =====================================================
// EXERCISE 2 - COLLECTIONS & OPERATORS
// =====================================================

void runExercise2() {
  print("\n===== EXERCISE 2 =====");
  List<int> numbers = [10, 20, 30];
  numbers.add(40);
  numbers.remove(10);
  print("List numbers: $numbers");
  print("First element (index 0): ${numbers[0]}");
  int sum = numbers[0] + numbers[1];
  bool isGreater = numbers[1] > numbers[0];
  String status = (sum >= 50) ? "Passed" : "Failed";
  print("Sum of first two elements: $sum");
  print("Is second item greater than first? $isGreater");
  print("Status: $status");
  Set<String> categories = {
    "Flutter",
    "Dart",
    "Flutter"
  };
  categories.add("Mobile");
  print("Unique Set: $categories");
  Map<String, String> course = {
    "code": "PRM392",
    "title": "Mobile Programming"
  };
  course["room"] = "LAB301";
  print("Course Map: $course");
  print("Course Code: ${course['code']}");
  print("Course Title: ${course['title']}");
}

// =====================================================
// EXERCISE 3 - CONTROL FLOW & FUNCTIONS
// =====================================================

void runExercise3() {
  print("\n===== EXERCISE 3 =====");
  int score = 8;
  if (score >= 8) {
    print("Result: Excellent");
  } else if (score >= 5) {
    print("Result: Passed");
  } else {
    print("Result: Failed");
  }
  int day = 2;
  switch (day) {
    case 1:
      print("Monday");
      break;
    case 2:
      print("Tuesday");
      break;
    case 3:
      print("Wednesday");
      break;
    default:
      print("Invalid day");
  }
  List<String> fruits = [
    "Apple",
    "Banana",
    "Orange"
  ];
  print("For Loop:");
  for (int i = 0; i < fruits.length; i++) {
    print(fruits[i]);
  }
  print("For-In Loop:");
  for (String fruit in fruits) {
    print(fruit);
  }
  print("ForEach:");
  fruits.forEach((fruit) {
    print(fruit);
  });
  int sum = addNumbers(5, 3);
  print("5 + 3 = $sum");
  int result = multiplyNumbers(5, 3);
  print("5 x 3 = $result");
}
int addNumbers(int a, int b) {
  return a + b;
}
int multiplyNumbers(int a, int b) => a * b;

// =====================================================
// EXERCISE 4 - INTRO TO OOP
// =====================================================

class Car {
  String brand;
  Car(this.brand);
  Car.defaultCar() : brand = "Toyota";
  void showInfo() {
    print("Car brand: $brand");
  }
}
class ElectricCar extends Car {
  int battery;
  ElectricCar(String brand, this.battery)
      : super(brand);
  @override
  void showInfo() {
    print("Electric Car: $brand");
    print("Battery: $battery%");
  }
}

void runExercise4() {
  print("\n===== EXERCISE 4 =====");
  Car car1 = Car("Honda");
  car1.showInfo();
  Car car2 = Car.defaultCar();
  car2.showInfo();
  ElectricCar car3 = ElectricCar(
    "Tesla",
    90,
  );
  car3.showInfo();
}

// =====================================================
// EXERCISE 5 - ASYNC, FUTURE, NULL SAFETY & STREAM
// =====================================================

Future<String> loadData() async {
  print("Loading data...");
  await Future.delayed(
    const Duration(seconds: 2),
  );

  return "Data loaded successfully";
}
Stream<int> numberStream() async* {
  for (int i = 1; i <= 5; i++) {
    yield i;
  }
}

Future<void> runExercise5() async {
  print("\n===== EXERCISE 5 =====");
  String result = await loadData();

  print(result);
  String? username;
  print("Username: $username");
  print(
    "Username default: ${username ?? 'Guest'}",
  );
  username = "Nguyen Xuan Bac";
  print(
    "Username length: ${username!.length}",
  );
  print("Stream values:");

  await for (int value in numberStream()) {
    print("Stream value: $value");
  }
}

// =====================================================
// FLUTTER UI
// =====================================================

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,

      home: Scaffold(
        body: Center(
          child: Text(
            "Lab 2 - Dart Essentials\n"
                "Exercise 1 - 5 completed\n"
                "Check console for output.",
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}