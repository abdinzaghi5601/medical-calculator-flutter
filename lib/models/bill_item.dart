class BillItem {
  final int chargeCode;
  final String name;
  final String category;
  final int quantity;
  final double unitPrice;
  final double discount;
  final String? error;

  BillItem({
    required this.chargeCode,
    required this.name,
    required this.category,
    required this.quantity,
    required this.unitPrice,
    this.discount = 0.0,
    this.error,
  });

  double get grossAmount => unitPrice * quantity;
  double get netAmount => grossAmount - discount;

  bool get hasError => error != null;
}

class ServiceItem {
  int? chargeCode;
  String serviceDescription;
  String category;
  double rate;
  int quantity;
  double discount;

  ServiceItem({
    this.chargeCode,
    this.serviceDescription = '',
    this.category = '',
    this.rate = 0.0,
    this.quantity = 1,
    this.discount = 0.0,
  });

  double get grossAmount => rate * quantity;
  double get netAmount => grossAmount - discount;

  bool get isValid => chargeCode != null && serviceDescription.isNotEmpty;
}