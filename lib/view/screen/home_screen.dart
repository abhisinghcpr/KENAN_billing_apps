
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controller/bill_provider.dart';
import 'create_screen.dart';
import 'dashboard_screen.dart';
import 'filter_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        title: Text(
          'Bills Management',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Consumer<BillProvider>(
        builder: (context, billProvider, child) {
          if (billProvider.bills.isEmpty) {
            return Center(
              child: Text(
                'No Bills Available',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }
          return ListView.builder(
            itemCount: billProvider.bills.length,
            itemBuilder: (context, index) {
              final bill = billProvider.bills[index];
              return Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                child: ListTile(
                  leading: Icon(Icons.receipt, color: Colors.blueAccent),
                  title: Text(
                    bill.customerName,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Amount: \$${bill.totalAmount}\nStatus: ${bill.isPaid ? "Paid" : "Unpaid"}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DashboardScreen(bill: bill),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => CreateBillScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
      drawer: Consumer<BillProvider>(
        builder: (context, billProvider, child) {
          return Drawer(
            elevation: 2,
            child: Column(
              children: [
                UserAccountsDrawerHeader(
                  accountName: Text('Admin'),
                  accountEmail: Text('admin@example.com'),
                  currentAccountPicture: CircleAvatar(
                    child: Icon(Icons.person, size: 40, color: Colors.deepPurple),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.dashboard, color: Colors.deepPurple),
                  title: Text('Dashboard'),
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DashboardScreen(
                          bill: billProvider.bills.isNotEmpty ? billProvider.bills[0] : null, // Pass the first bill for now if available
                        ),
                      ),
                    );
                  },
                ),
                Divider(),
             ListTile(
                  leading: Icon(Icons.filter_alt, color: Colors.blue),
                  title: Text('Filter Bills'),
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => FilterBillsScreen()),
                    );
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.close, color: Colors.red),
                  title: Text('Close'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
