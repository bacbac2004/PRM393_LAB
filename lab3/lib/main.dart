import 'dart:async';
import 'dart:convert';

// ================= EXERCISE 1 =================

class Product {
  int id;
  String name;
  double price;
  Product(this.id, this.name, this.price);
}
class ProductRepository {
  List<Product> products = [
    Product(1, "Laptop", 1200),
    Product(2, "Phone", 800),
  ];
  // Tạo Stream để theo dõi sản phẩm mới được thêm
  StreamController<Product> controller =
  StreamController<Product>.broadcast();
  // Trả về danh sách sản phẩm bằng Future
  Future<List<Product>> getAll() async {
    return products;
  }
  // Trả về Stream chứa sản phẩm mới
  Stream<Product> liveAdded() {
    return controller.stream;
  }
  // Thêm sản phẩm mới và gửi sản phẩm vào Stream
  void addProduct(Product product) {
    products.add(product);
    controller.add(product);
  }
}
Future<void> exercise1() async {
  print("===== EXERCISE 1: =====");
  ProductRepository repo = ProductRepository();
  // gọi khi có sản phẩm mới
  repo.liveAdded().listen((product) {
    print(
      "New product added: ID = ${product.id}, "
          "Name = ${product.name}, "
          "Price = ${product.price}",
    );
  });
  // Lấy danh sách sản phẩm
  List<Product> list = await repo.getAll();
  print("Current product list:");
  for (Product product in list) {
    print(
      "Product ID: ${product.id}, "
          "Name: ${product.name}, "
          "Price: ${product.price}",
    );
  }
  // Thêm một sản phẩm mới
  repo.addProduct(Product(3, "Tablet", 500));
  await Future.delayed(Duration(milliseconds: 100));
  await repo.controller.close();
}

// ================= EXERCISE 2 =================

class User {
  String name;
  String email;
  User(this.name, this.email);
  // Chuyển dữ liệu JSON thành đối tượng User
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      json["name"],
      json["email"],
    );
  }
}
Future<List<User>> getUsers() async {
  // Giả lập dữ liệu JSON nhận từ API
  String jsonData = '''
  [
    {
      "name": "Nguyen Xuan Bac",
      "email": "bac@gmail.com"
    }
  ]
  ''';
  // Chuyển chuỗi JSON thành danh sách Dart
  List data = jsonDecode(jsonData);
  List<User> users = [];
  // Chuyển từng phần tử JSON thành User
  for (var item in data) {
    users.add(User.fromJson(item));
  }
  return users;
}
Future<void> exercise2() async {
  print("\n===== EXERCISE 2: =====");
  List<User> users = await getUsers();
  print("User list parsed from JSON:");
  // In danh sách người dùng
  for (User user in users) {
    print(
      "User Name: ${user.name}, "
          "Email: ${user.email}",
    );
  }
}

// ================= EXERCISE 3 =================

Future<void> exercise3() async {
  print("\n===== EXERCISE 3: =====");
  print("Step 1: Start program");
  // Microtask được thực hiện trước Future
  scheduleMicrotask(() {
    print("Step 3: Microtask is executed");
  });
  // Future được đưa vào Event Queue
  Future(() {
    print("Step 4: Future event is executed");
  });
  print("Step 2: End synchronous code");
  await Future.delayed(Duration(milliseconds: 100));
}

// ================= EXERCISE 4 =================

Future<void> exercise4() async {
  print("\n===== EXERCISE 4: =====");
  // Tạo Stream chứa các số từ 1 đến 5
  Stream<int> numbers =
  Stream.fromIterable([1, 2, 3, 4, 5]);
  // Bình phương từng số bằng map()
  Stream<int> squareNumbers =
  numbers.map((number) => number * number);
  // Lọc và chỉ giữ lại các số chẵn
  Stream<int> evenNumbers =
  squareNumbers.where((number) => number.isEven);
  print("Even square numbers:");
  // Đọc và in từng giá trị của Stream
  await for (int number in evenNumbers) {
    print("Stream value: $number");
  }
}

// ================= EXERCISE 5 =================
class Settings {
  // Chỉ tạo duy nhất một đối tượng Settings
  static final Settings _instance =
  Settings._internal();
  // Constructor private
  Settings._internal();
  // Factory luôn trả về cùng một đối tượng
  factory Settings() {
    return _instance;
  }
}
void exercise5() {
  print("\n===== EXERCISE 5: =====");
  Settings a = Settings();
  Settings b = Settings();
  // Kiểm tra a và b có phải cùng một đối tượng hay không
  bool sameObject = identical(a, b);
  print(
    "Are Settings object A and object B the same object? "
        "$sameObject",
  );
  if (sameObject) {
    print("Result: Both variables refer to the same Settings object.",);
  } else {
    print("Result: They are different objects.",);
  }
}

Future<void> main() async {
  await exercise1();
  await exercise2();
  await exercise3();
  await exercise4();
  exercise5();
}