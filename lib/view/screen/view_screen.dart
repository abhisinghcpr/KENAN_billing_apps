import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controller/bill_provider.dart';
import '../../model/bill_model.dart';
import 'dashboard_screen.dart';

class ViewBillScreen extends StatefulWidget {
  final Bill bill;

  ViewBillScreen({required this.bill});

  @override
  _ViewBillScreenState createState() => _ViewBillScreenState();
}

class _ViewBillScreenState extends State<ViewBillScreen> {
  late TextEditingController _customerNameController;
  late TextEditingController _customerContactController;
  late TextEditingController _totalAmountController;
  late List<TextEditingController> _itemControllers;

  @override
  void initState() {
    super.initState();
    _customerNameController =
        TextEditingController(text: widget.bill.customerName);
    _customerContactController =
        TextEditingController(text: widget.bill.customerContact);
    _totalAmountController =
        TextEditingController(text: widget.bill.totalAmount.toString());

    _itemControllers = widget.bill.items.map((item) {
      return TextEditingController(text: item.name);
    }).toList();
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    _customerContactController.dispose();
    _totalAmountController.dispose();

    for (var controller in _itemControllers) {
      controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        title: Text(
          'Invoice Details',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.picture_as_pdf, color: Colors.blue),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DashboardScreen(bill: widget.bill),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.edit, color: Colors.blue),
            onPressed: () {
              _openUpdateBottomSheet();
            },
          ),

          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              _showDeleteConfirmationDialog();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Invoice No.',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('${widget.bill.id ?? ''}'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Invoice Date',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('${widget.bill.date ?? ''}'),
                ],
              ),
              SizedBox(height: 20),
              Text('Customer Name:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(widget.bill.customerName),
              SizedBox(height: 10),
              Text('Customer Contact:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(widget.bill.customerContact),
              SizedBox(height: 10),
              Text('Total Amount:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text('\$${widget.bill.totalAmount}'),
              SizedBox(height: 20),
              Text('Product Details',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Divider(),

              // Product Items
              for (int i = 0; i < widget.bill.items.length; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(widget.bill.items[i].name),
                      ),
                      SizedBox(width: 10),
                      Text('Qty: ${widget.bill.items[i].quantity}'),
                      SizedBox(width: 10),
                      Text(
                          '\$${widget.bill.items[i].unitPrice.toStringAsFixed(2)}'),
                    ],
                  ),
                ),
              Divider(),
              SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Gross Amount:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('\$${widget.bill.totalAmount}'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Discount @ 10.0%:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                      '\$${(widget.bill.totalAmount * 0.10).toStringAsFixed(2)}'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('CGST @ 2.5%:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                      '\$${(widget.bill.totalAmount * 0.025).toStringAsFixed(2)}'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('SGST @ 2.5%:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                      '\$${(widget.bill.totalAmount * 0.025).toStringAsFixed(2)}'),
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Bill Amount:',
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('\$${(widget.bill.totalAmount * 0.95).toStringAsFixed(2)}',
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(height: 20),

              SwitchListTile(
                title: Text('Paid'),
                value: widget.bill.isPaid,
                onChanged: (value) {
                  Provider.of<BillProvider>(context, listen: false)
                      .togglePaidStatus(widget.bill.id!);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openUpdateBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,  // Ensures the bottom sheet height adjusts dynamically
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Text('Edit Bill', style: TextStyle(fontWeight: FontWeight.bold))),
                SizedBox(height: 20),
                Text('Customer Name:', style: TextStyle(fontWeight: FontWeight.bold)),
                TextField(
                  controller: _customerNameController,
                  decoration: InputDecoration(hintText: 'Enter customer name'),
                ),
                SizedBox(height: 10),
                Text('Customer Contact:', style: TextStyle(fontWeight: FontWeight.bold)),
                TextField(
                  controller: _customerContactController,
                  decoration: InputDecoration(hintText: 'Enter customer contact'),
                ),
                SizedBox(height: 20),

                // Wrap the entire content with a Column and then add dynamic fields if necessary
                ...List.generate(widget.bill.items.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: TextField(
                      controller: _itemControllers[index], // Edit each item
                      decoration: InputDecoration(hintText: 'Enter product name'),
                    ),
                  );
                }),

                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () {
                      final updatedItems = widget.bill.items
                          .asMap()
                          .map((index, item) {
                        return MapEntry(
                            index,
                            Item(
                              name: _itemControllers[index].text,
                              quantity: item.quantity,
                              unitPrice: item.unitPrice,
                            ));
                      })
                          .values
                          .toList();

                      final updatedBill = widget.bill.copyWith(
                        customerName: _customerNameController.text,
                        customerContact: _customerContactController.text,
                        items: updatedItems,
                      );

                      Provider.of<BillProvider>(context, listen: false)
                          .updateBill(updatedBill);
                      Navigator.pop(context);
                    },
                    child: Text('Update Bill'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Bill'),
          content: Text('Are you sure you want to delete this bill?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Provider.of<BillProvider>(context, listen: false)
                    .deleteBill(widget.bill.id!);
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
