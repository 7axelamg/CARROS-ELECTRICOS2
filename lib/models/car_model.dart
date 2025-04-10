class Car {
  final String id;
  final String? conductor;

  const Car({
    required this.id,
    this.conductor,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['id']?.toString() ?? '',
      conductor: json['conductor']?.toString(),
    );
  }
}