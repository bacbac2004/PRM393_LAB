class User {
  int id;
  String name;
  String? email;
  User({
    required this.id,
    required this.name,
    this.email,
  });
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'] ?? "Bắc",
      email: json['email'],
    );
  }
  void showProfile() {
    print("ID: $id | Tên: $name | Email: ${email ?? "bacnxhe180801@fpt.edu.vn"}");}
}
void main() {
  Map<String, dynamic> data1 = {"id": 1, "name": "Nam", "email": "nam@fpt.edu.vn"};
  Map<String, dynamic> data2 = {"id": 2, "name": null, "email": null};
  User user1 = User.fromJson(data1);
  User user2 = User.fromJson(data2);
  user1.showProfile();
  user2.showProfile();
}