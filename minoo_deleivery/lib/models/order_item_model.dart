/// Model representing a single line item within an order.
class OrderItem {
  final int id;
  final int orderId;
  final int menuId;
  final String menuName;
  final String menuImageUrl;
  final String vendorId;
  final double unitPrice;
  final int quantity;
  final double lineTotal;

  const OrderItem({
    required this.id,
    required this.orderId,
    required this.menuId,
    required this.menuName,
    required this.menuImageUrl,
    required this.vendorId,
    required this.unitPrice,
    required this.quantity,
    required this.lineTotal,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    final unit = double.tryParse(json['unit_price']?.toString() ?? '') ?? 0.0;
    final qty = int.tryParse(json['quantity']?.toString() ?? '') ?? 1;
    final total = double.tryParse(json['line_total']?.toString() ?? '') ?? (unit * qty);

    return OrderItem(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      orderId: int.tryParse(json['order_id']?.toString() ?? '') ?? 0,
      menuId: int.tryParse(json['menu_id']?.toString() ?? '') ?? 0,
      menuName: json['menu_name']?.toString() ?? '',
      menuImageUrl: json['menu_image_url']?.toString() ?? '',
      vendorId: json['vendor_id']?.toString() ?? '',
      unitPrice: unit,
      quantity: qty,
      lineTotal: total,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'menu_id': menuId,
      'menu_name': menuName,
      'menu_image_url': menuImageUrl,
      'vendor_id': vendorId,
      'unit_price': unitPrice,
      'quantity': quantity,
      'line_total': lineTotal,
    };
  }
}
