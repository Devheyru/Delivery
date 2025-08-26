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
      id: json['id'],
      deliveryCenterId: int.parse(json['delivery_center_id'].toString()),
      name: json['name'],
      slug: json['slug'],
      distance: json['distance'].toString(),
    );
  }
}
