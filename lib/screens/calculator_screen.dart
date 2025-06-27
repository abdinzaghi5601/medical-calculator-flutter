import 'package:flutter/material.dart';
import '../models/bill_item.dart';
import '../utils/patient_types.dart';
import '../services/data_service.dart';
import '../widgets/service_item_card.dart';
import '../screens/receipt_screen.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final DataService _dataService = DataService();
  String _selectedPatientType = 'visitor';
  List<ServiceItem> _serviceItems = [ServiceItem()];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _dataService.loadData();
    setState(() {
      _isLoading = false;
    });
  }

  void _addServiceItem() {
    setState(() {
      _serviceItems.add(ServiceItem());
    });
  }

  void _removeServiceItem(int index) {
    if (_serviceItems.length > 1) {
      setState(() {
        _serviceItems.removeAt(index);
      });
    }
  }

  void _updateServiceItem(int index, ServiceItem updatedItem) {
    setState(() {
      _serviceItems[index] = updatedItem;
    });
  }

  void _generateReceipt() {
    final List<BillItem> billItems = [];
    
    for (final serviceItem in _serviceItems) {
      if (serviceItem.isValid) {
        billItems.add(BillItem(
          chargeCode: serviceItem.chargeCode!,
          name: serviceItem.serviceDescription,
          category: serviceItem.category,
          quantity: serviceItem.quantity,
          unitPrice: serviceItem.rate,
          discount: serviceItem.discount,
        ));
      }
    }

    if (billItems.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ReceiptScreen(
            billItems: billItems,
            patientType: _selectedPatientType,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one valid service item'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading medical data...'),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF1E3A8A),
      appBar: AppBar(
        title: const Text(
          'Medical Calculator',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1E3A8A),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                children: [
                  Text(
                    '🏥 Medical Calculator',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Finance Department',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Billing Information Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Patient Type Selection
                    const Text(
                      '👤 Billing Category:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedPatientType,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      items: PatientTypes.types.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(PatientTypes.getDisplayName(type)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedPatientType = value;
                            // Update prices for all service items
                            for (int i = 0; i < _serviceItems.length; i++) {
                              if (_serviceItems[i].chargeCode != null) {
                                final chargeItem = _dataService.getChargeItem(_serviceItems[i].chargeCode!);
                                if (chargeItem != null) {
                                  _serviceItems[i].rate = chargeItem.getPriceForPatientType(_selectedPatientType);
                                }
                              }
                            }
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 24),

                    // Service Order Details
                    Row(
                      children: [
                        const Icon(Icons.list_alt, color: Colors.blue),
                        const SizedBox(width: 8),
                        const Text(
                          'Service Order Bill Details',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Service Items
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _serviceItems.length,
                      itemBuilder: (context, index) {
                        return ServiceItemCard(
                          serviceItem: _serviceItems[index],
                          index: index,
                          dataService: _dataService,
                          selectedPatientType: _selectedPatientType,
                          onUpdate: _updateServiceItem,
                          onRemove: _serviceItems.length > 1 ? _removeServiceItem : null,
                        );
                      },
                    ),
                    const SizedBox(height: 16),

                    // Add Item Button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _addServiceItem,
                        icon: const Icon(Icons.add),
                        label: const Text('Add Service Item'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.green,
                          side: const BorderSide(color: Colors.green),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Generate Receipt Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _generateReceipt,
                        icon: const Icon(Icons.receipt, color: Colors.white),
                        label: const Text(
                          'Generate Collection Receipt',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}