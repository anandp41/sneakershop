class UserData {
  final String name;
  final String email;
  final String phoneno;
  final String address;
  final String password;
  final String? imagePath;
  final List<Map<String, dynamic>> cart;
  final List<Map<String, dynamic>> orderHistory;
  final List<String> favList;
  UserData(
      {required this.name,
      required this.email,
      required this.phoneno,
      required this.address,
      required this.password,
      this.imagePath,
      this.cart = const [],
      this.orderHistory = const [],
      this.favList = const []});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phoneno': phoneno,
      'address': address,
      'password': password,
      'imagePath': imagePath,
      'cart': cart,
      'orderHistory': orderHistory,
      'favList': favList,
    };
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phoneno: map['phoneno'] ?? '',
      address: map['address'] ?? '',
      password: map['password'] ?? '',
      imagePath: map['imagePath'],
      cart: List<Map<String, dynamic>>.from(
          map['cart'] //?.map((x) => Map<String, int>.fromMap(x))
          ),
      orderHistory: List<Map<String, dynamic>>.from(
          map['orderHistory'] //?.map((x) => Map<String, dynamic>.fromMap(x))

          ),
      favList: List<String>.from(map['favList']),
    );
  }

  // String toJson() => json.encode(toMap());

  // factory UserData.fromJson(String source) =>
  //     UserData.fromMap(json.decode(source));
}
