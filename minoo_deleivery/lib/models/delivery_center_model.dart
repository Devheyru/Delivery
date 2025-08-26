class DeliveryCenter {
  final int id;
  final String name;
  final String slug;

  DeliveryCenter({required this.id, required this.name, required this.slug});

  factory DeliveryCenter.fromJson(Map<String, dynamic> json) {
    return DeliveryCenter(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
    );
  }
}
