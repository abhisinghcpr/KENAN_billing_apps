import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../model/bill_model.dart';

class PrintBillScreen extends StatelessWidget {
  final Bill bill;

  PrintBillScreen({required this.bill});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        title: const Text(
          'Preview & Print Bill',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () => _generateBillPreview(context),
          icon: Icon(Icons.print, color: Colors.white),
          label: Text(
            'Generate & Print Bill',
            style: TextStyle(color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          ),
        ),
      ),
    );
  }

  Future<void> _generateBillPreview(BuildContext context) async {
    final pdf = pw.Document();

    // PDF Content
    pdf.addPage(
      pw.Page(
        margin: pw.EdgeInsets.all(24),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Customer Bill',
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Text('Customer Name: ${bill?.customerName ?? "N/A"}',
                  style: pw.TextStyle(fontSize: 18)),
              pw.Text('Contact: ${bill?.customerContact ?? "N/A"}',
                  style: pw.TextStyle(fontSize: 18)),
              pw.SizedBox(height: 10),
              pw.Text('Bill Items:',
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.ListView.builder(
                itemCount: bill?.items.length ?? 0,
                itemBuilder: (context, index) {
                  final item = bill!.items[index];
                  return pw.Padding(
                    padding: const pw.EdgeInsets.only(bottom: 8.0),
                    child: pw.Text(
                      '${item.name} - ${item.quantity} x \$${item.unitPrice}',
                      style: pw.TextStyle(fontSize: 16),
                    ),
                  );
                },
              ),
              pw.SizedBox(height: 20),
              pw.Text('Total Amount: \$${bill?.totalAmount ?? "0.0"}',
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Text(
                  'Payment Status: ${bill?.isPaid == true ? "Paid" : "Unpaid"}',
                  style: pw.TextStyle(
                    fontSize: 18,
                  )),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }
}
