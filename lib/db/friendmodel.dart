class Friend {
  int id;
  String name;
  String email;
  String phone;
  String website;

  Friend({this.id, this.name, this.email, this.phone, this.website});
  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      website: json['website'],
    );
  }
}