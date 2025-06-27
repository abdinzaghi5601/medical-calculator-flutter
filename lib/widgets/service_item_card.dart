import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/bill_item.dart';
import '../services/data_service.dart';

class ServiceItemCard extends StatefulWidget {
  final ServiceItem serviceItem;
  final int index;
  final DataService dataService;
  final String selectedPatientType;
  final Function(int, ServiceItem) onUpdate;
  final Function(int)? onRemove;

  const ServiceItemCard({
    super.key,
    required this.serviceItem,
    required this.index,
    required this.dataService,
    required this.selectedPatientType,
    required this.onUpdate,
    this.onRemove,
  });

  @override
  State<ServiceItemCard> createState() => _ServiceItemCardState();
}

class _ServiceItemCardState extends State<ServiceItemCard> {
  late TextEditingController _chargeCodeController;
  late TextEditingController _descriptionController;
  late TextEditingController _categoryController;
  late TextEditingController _rateController;
  late TextEditingController _quantityController;
  late TextEditingController _discountController;
  late TextEditingController _grossAmountController;
  late TextEditingController _netAmountController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _chargeCodeController = TextEditingController(
      text: widget.serviceItem.chargeCode?.toString() ?? ''
    );
    _descriptionController = TextEditingController(
      text: widget.serviceItem.serviceDescription
    );
    _categoryController = TextEditingController(
      text: widget.serviceItem.category
    );
    _rateController = TextEditingController(
      text: widget.serviceItem.rate.toStringAsFixed(2)
    );
    _quantityController = TextEditingController(
      text: widget.serviceItem.quantity.toString()
    );
    _discountController = TextEditingController(
      text: widget.serviceItem.discount.toStringAsFixed(2)
    );
    _grossAmountController = TextEditingController(
      text: widget.serviceItem.grossAmount.toStringAsFixed(2)
    );
    _netAmountController = TextEditingController(
      text: widget.serviceItem.netAmount.toStringAsFixed(2)
    );
  }

  @override
  void dispose() {
    _chargeCodeController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _rateController.dispose();
    _quantityController.dispose();
    _discountController.dispose();
    _grossAmountController.dispose();
    _netAmountController.dispose();
    super.dispose();
  }

  Future<void> _onChargeCodeChanged(String value) async {
    if (value.isEmpty || value.length < 3) return;
    
    final chargeCode = int.tryParse(value);
    if (chargeCode == null) return;

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 500)); // Debounce

    final chargeItem = widget.dataService.getChargeItem(chargeCode);
    
    setState(() {
      _isLoading = false;
    });

    if (chargeItem != null) {
      final updatedItem = ServiceItem(
        chargeCode: chargeCode,
        serviceDescription: chargeItem.chargeName,
        category: chargeItem.chargeCategory,
        rate: chargeItem.getPriceForPatientType(widget.selectedPatientType),
        quantity: widget.serviceItem.quantity,
        discount: widget.serviceItem.discount,
      );

      _descriptionController.text = updatedItem.serviceDescription;
      _categoryController.text = updatedItem.category;
      _rateController.text = updatedItem.rate.toStringAsFixed(2);
      _updateAmounts(updatedItem);
      widget.onUpdate(widget.index, updatedItem);
    } else {
      _descriptionController.text = 'Code not found';
      _categoryController.text = 'N/A';
      _rateController.text = '0.00';
      _updateAmounts(widget.serviceItem);
    }
  }

  void _updateAmounts(ServiceItem item) {
    _grossAmountController.text = item.grossAmount.toStringAsFixed(2);
    _netAmountController.text = item.netAmount.toStringAsFixed(2);
  }

  void _onQuantityChanged(String value) {
    final quantity = int.tryParse(value) ?? 1;
    final updatedItem = ServiceItem(
      chargeCode: widget.serviceItem.chargeCode,
      serviceDescription: widget.serviceItem.serviceDescription,
      category: widget.serviceItem.category,
      rate: widget.serviceItem.rate,
      quantity: quantity,
      discount: widget.serviceItem.discount,
    );
    _updateAmounts(updatedItem);
    widget.onUpdate(widget.index, updatedItem);
  }

  void _onDiscountChanged(String value) {
    final discount = double.tryParse(value) ?? 0.0;
    final updatedItem = ServiceItem(
      chargeCode: widget.serviceItem.chargeCode,
      serviceDescription: widget.serviceItem.serviceDescription,
      category: widget.serviceItem.category,
      rate: widget.serviceItem.rate,
      quantity: widget.serviceItem.quantity,
      discount: discount,
    );
    _updateAmounts(updatedItem);
    widget.onUpdate(widget.index, updatedItem);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // First Row: Service Code, Description, Category
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Service Code', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      TextField(
                        controller: _chargeCodeController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          suffixIcon: _isLoading 
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                              )
                            : null,
                        ),
                        onChanged: _onChargeCodeChanged,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Service Description', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      TextField(
                        controller: _descriptionController,
                        readOnly: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Category', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      TextField(
                        controller: _categoryController,
                        readOnly: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Second Row: Rate, Quantity, Gross Amount, Discount, Net Amount, Remove
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Rate', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      TextField(
                        controller: _rateController,
                        readOnly: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Qty.', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      TextField(
                        controller: _quantityController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        ),
                        onChanged: _onQuantityChanged,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Gross Amount', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      TextField(
                        controller: _grossAmountController,
                        readOnly: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Discount', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      TextField(
                        controller: _discountController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        ),
                        onChanged: _onDiscountChanged,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Net Amount (QR)', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      TextField(
                        controller: _netAmountController,
                        readOnly: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                if (widget.onRemove != null)
                  Column(
                    children: [
                      const SizedBox(height: 20),
                      IconButton(
                        onPressed: () => widget.onRemove!(widget.index),
                        icon: const Icon(Icons.delete, color: Colors.red),
                        tooltip: 'Remove item',
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}