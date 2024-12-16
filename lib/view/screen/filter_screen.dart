import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../controller/bill_provider.dart';

class FilterBillsScreen extends StatefulWidget {
  @override
  _FilterBillsScreenState createState() => _FilterBillsScreenState();
}

class _FilterBillsScreenState extends State<FilterBillsScreen> {
  DateTime? _startDate;
  DateTime? _endDate;
  bool? _isPaid;

  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        title: Text('Filter Bills',          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Filter by Date Range
            TextField(
              controller: _startDateController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Start Date',
                hintText: 'Select start date',
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: _pickStartDate,
                ),
              ),
            ),
            TextField(
              controller: _endDateController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'End Date',
                hintText: 'Select end date',
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: _pickEndDate,
                ),
              ),
            ),
            SizedBox(height: 20),
            // Filter by Paid/Unpaid
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Paid/Unpaid:'),
                SizedBox(width: 10),
                FilterChip(
                  label: Text('Paid'),
                  selected: _isPaid == true,
                  onSelected: (selected) {
                    setState(() {
                      _isPaid = true;
                    });
                  },
                ),
                SizedBox(width: 10),
                FilterChip(
                  label: Text('Unpaid'),
                  selected: _isPaid == false,
                  onSelected: (selected) {
                    setState(() {
                      _isPaid = false;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            // Filter Button
            ElevatedButton(
              onPressed: _applyFilters,
              child: Text('Apply Filters'),
            ),
          ],
        ),
      ),
    );
  }

  // Pick start date from date picker
  Future<void> _pickStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
        _startDateController.text = DateFormat('yyyy-MM-dd').format(_startDate!);
      });
    }
  }

  // Pick end date from date picker
  Future<void> _pickEndDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
        _endDateController.text = DateFormat('yyyy-MM-dd').format(_endDate!);
      });
    }
  }

  void _applyFilters() {
    if (_startDate != null && _endDate != null) {
      Provider.of<BillProvider>(context, listen: false)
          .filterBillsByDate(_startDate!, _endDate!);
    } else if (_isPaid != null) {
      Provider.of<BillProvider>(context, listen: false)
          .filterBillsByStatus(_isPaid!);
    }
    Navigator.pop(context);
  }
}
