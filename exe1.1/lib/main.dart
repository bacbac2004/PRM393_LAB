// Bài: Thiết kế hệ thống phương tiện giao thông

// TODO 1: Định nghĩa class Vehicle
class Vehicle {
  String brand;
  int year;

  // Default Constructor
  Vehicle(this.brand, this.year);

  // Hàm khởi động phương tiện
  void startEngine() {
    print("Khởi động phương tiện...");
  }
}

// TODO 2: Định nghĩa class Car kế thừa từ Vehicle
class Car extends Vehicle {
  bool isElectric;

  // TODO 3: Constructor mặc định
  Car(String brand, int year, bool isElectric)
      : isElectric = isElectric,
        super(brand, year);

  // Named Constructor
  Car.tesla(int year)
      : isElectric = true,
        super("Tesla", year);

  // TODO 4: Ghi đè hàm startEngine()
  @override
  void startEngine() {
    if (isElectric) {
      print("$brand $year: Xe điện khởi động êm ái...");
    } else {
      print("$brand $year: Xe xăng khởi động với tiếng động cơ...");
    }
  }
}

void main() {
  // TODO 5: Khởi tạo một xe Car bình thường
  Car car1 = Car("Toyota", 2024, false);

  print("Xe 1:");
  print("Brand: ${car1.brand}");
  print("Year: ${car1.year}");
  print("Electric: ${car1.isElectric}");
  car1.startEngine();

  print("");

  // TODO 6: Khởi tạo Car bằng Named Constructor
  Car car2 = Car.tesla(2025);

  print("Xe 2:");
  print("Brand: ${car2.brand}");
  print("Year: ${car2.year}");
  print("Electric: ${car2.isElectric}");
  car2.startEngine();
}