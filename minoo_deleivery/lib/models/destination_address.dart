class Destination {
  final int id;
  final int deliveryCenterId;
  final String name;
  final String slug;
  final String distance; // string in API

  Destination({
    required this.id,
    required this.deliveryCenterId,
    required this.name,
    required this.slug,
    required this.distance,
  });

  factory Destination.fromJson(Map<String, dynamic> json) {
    return Destination(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      deliveryCenterId:
          int.tryParse(json['delivery_center_id']?.toString() ?? '') ?? 0,
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      distance: json['distance']?.toString() ?? '0.0',
    );
  }
}
