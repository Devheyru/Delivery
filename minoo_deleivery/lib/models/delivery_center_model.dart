class DeliveryCenter {
  final int id;
  final String name;
  final String slug;

  DeliveryCenter({required this.id, required this.name, required this.slug});

  factory DeliveryCenter.fromJson(Map<String, dynamic> json) {
    return DeliveryCenter(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
    );
  }
}
