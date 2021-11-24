class Device {
  final int id;
  final String token;
  final String name;

  Device(this.id, this.name, this.token);

  Device.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        token = json['token'],
        name = json['name'];

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'token': token,
      'name': name,
    };
  }
}
