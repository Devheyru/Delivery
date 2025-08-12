class MenuItem {
  final int id;
  final String vendorId;
  final String publicId;
  final String menuName;
  final String menuDescription;
  final double menuPrice;
  final String menuImg;
  final String? menuCategory;
  final DateTime createdAt;
  final DateTime updatedAt;

  MenuItem({
    required this.id,
    required this.vendorId,
    required this.publicId,
    required this.menuName,
    required this.menuDescription,
    required this.menuPrice,
    required this.menuImg,
    this.menuCategory,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    final price = double.tryParse(json['menu_price']?.toString() ?? '') ?? 0.0;

    return MenuItem(
      id: int.tryParse(json['id'].toString()) ?? 0,
      vendorId: json['vendor_id']?.toString() ?? '',
      publicId: json['public_id']?.toString() ?? '',
      menuName: json['menu_name']?.toString() ?? '',
      menuDescription: json['menu_description']?.toString() ?? '',
      menuPrice: price,
      menuImg: json['menu_img']?.toString() ?? '',
      menuCategory: json['menu_category']?.toString(),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  String get imageUrl {
    if (menuImg.startsWith('http')) return menuImg;
    if (menuImg.startsWith('public/'))
      return 'https://minoodelivery.com/$menuImg';
    return 'https://minoodelivery.com/public/$menuImg';
  }
}
