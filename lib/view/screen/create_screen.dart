import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controller/bill_provider.dart';
import '../../model/bill_model.dart';

class CreateBillScreen extends StatefulWidget {
  @override
  _CreateBillScreenState createState() => _CreateBillScreenState();
}

class _CreateBillScreenState extends State<CreateBillScreen> {
  final _formKey = GlobalKey<FormState>();
  final _customerNameController = TextEditingController();
  final _customerContactController = TextEditingController();
  final _itemNameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _unitPriceController = TextEditingController();
  List<Item> _items = [];

  double get totalAmount {
    return _items.fold(0, (sum, item) => sum + item.total);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        title: const Text(
          'Create Bill',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Customer Name Field
              const Text(
                'Customer Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _customerNameController,
                decoration: const InputDecoration(
                  labelText: 'Customer Name',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                validator: (value) =>
                value!.isEmpty ? 'Please enter customer name' : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _customerContactController,
                decoration: const InputDecoration(
                  labelText: 'Customer Contact',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) =>
                value!.isEmpty ? 'Please enter contact' : null,
              ),

              const SizedBox(height: 20),

              const Text(
                'Item Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _itemNameController,
                decoration: const InputDecoration(
                  labelText: 'Item Name',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _unitPriceController,
                decoration: const InputDecoration(
                  labelText: 'Unit Price',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 20),

              // Add Item Button
              Center(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.blueAccent, padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () {
                    if (_itemNameController.text.isNotEmpty &&
                        _quantityController.text.isNotEmpty &&
                        _unitPriceController.text.isNotEmpty) {
                      final item = Item(
                        name: _itemNameController.text,
                        quantity: int.parse(_quantityController.text),
                        unitPrice: double.parse(_unitPriceController.text),
                      );
                      setState(() {
                        _items.add(item);
                      });
                      _itemNameController.clear();
                      _quantityController.clear();
                      _unitPriceController.clear();
                    }
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Item'),
                ),
              ),

              const SizedBox(height: 20),

              // Item List Display
              _items.isNotEmpty
                  ? Column(
                children: _items
                    .map((item) => ListTile(
                  title: Text(item.name),
                  subtitle: Text(
                      'Quantity: ${item.quantity}, Unit Price: ${item.unitPrice.toStringAsFixed(2)}'),
                  trailing: Text(
                    '₹ ${(item.total).toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold),
                  ),
                ))
                    .toList(),
              )
                  : const Center(child: Text('No items added yet')),

              const SizedBox(height: 20),

              // Show Save Bill Button only after adding items
              _items.isNotEmpty
                  ? Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.green, padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final bill = Bill(
                        customerName: _customerNameController.text,
                        customerContact: _customerContactController.text,
                        items: _items,
                        totalAmount: totalAmount,
                        isPaid: false,
                        date: DateTime.now(),
                      );
                      Provider.of<BillProvider>(context, listen: false)
                          .addBill(bill);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Save Bill'),
                ),
              )
                  : Container(), // Empty container when no items are added
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
