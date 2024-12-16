import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controller/bill_provider.dart';
import '../../model/bill_model.dart';
import '../../printing/bill_print.dart';

class DashboardScreen extends StatelessWidget {
  final Bill? bill;

  DashboardScreen({required this.bill});

  @override
  Widget build(BuildContext context) {
    final statistics = Provider.of<BillProvider>(context).getStatistics();

    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        title: Text(
          'Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Sales Statistics',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                _buildStatisticCard(
                  title: 'Total Sales',
                  value: '\$${statistics['totalSales']}',
                  icon: Icons.attach_money,
                  color: Colors.green,
                ),
                SizedBox(height: 10),
                _buildStatisticCard(
                  title: 'Total Bills',
                  value: '${statistics['totalBills']}',
                  icon: Icons.receipt,
                  color: Colors.blue,
                ),
                SizedBox(height: 10),
                _buildStatisticCard(
                  title: 'Unpaid Bills',
                  value: '${statistics['unpaidPercentage']}%',
                  icon: Icons.warning,
                  color: Colors.redAccent,
                ),
                SizedBox(height: 30),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PrintBillScreen(bill: bill!), // Ensure bill is passed here
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 20.0),
                    ),
                    icon: Icon(Icons.picture_as_pdf, color: Colors.white),
                    label: Text(
                      'Generate & Print Bill',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatisticCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        trailing: Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }
}
