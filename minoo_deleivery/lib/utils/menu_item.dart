import 'package:minoo_deleivery/config/api_config.dart';

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
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  String get imageUrl {
    if (menuImg.isEmpty) return '';
    return ApiConfig.imageUrl(menuImg);
  }
}
