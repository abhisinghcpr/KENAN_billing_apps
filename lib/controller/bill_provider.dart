
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/bill_model.dart';
import 'dart:async';



class BillProvider with ChangeNotifier {
  List<Bill> _bills = [];
  Database? _database;

  List<Bill> get bills => _bills;

  BillProvider() {
    _initDb();
  }

  Future<void> _initDb() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'bills.db');

    _database = await openDatabase(path, version: 1, onCreate: (db, version) {
      db.execute('''
        CREATE TABLE bills(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          customerName TEXT,
          customerContact TEXT,
          totalAmount REAL,
          isPaid INTEGER,
          date TEXT
        )
      ''');
    });
    await _loadBills();
  }

  Future<void> _loadBills() async {
    if (_database == null) return;
    final List<Map<String, dynamic>> maps = await _database!.query('bills');
    _bills = List.generate(maps.length, (i) {
      return Bill.fromMap(maps[i]);
    });
    notifyListeners();
  }

  Future<void> addBill(Bill bill) async {
    if (_database == null) return;
    final id = await _database!.insert('bills', bill.toMap());
    bill.id = id;
    _bills.add(bill);
    notifyListeners();
  }

  Future<void> updateBill(Bill bill) async {
    if (_database == null) return;
    await _database!.update(
      'bills',
      bill.toMap(),
      where: 'id = ?',
      whereArgs: [bill.id],
    );
    _bills = _bills.map((b) => b.id == bill.id ? bill : b).toList();
    notifyListeners();
  }

  Future<void> deleteBill(int id) async {
    if (_database == null) return;
    await _database!.delete('bills', where: 'id = ?', whereArgs: [id]);
    _bills.removeWhere((bill) => bill.id == id);
    notifyListeners();
  }

  Future<void> togglePaidStatus(int id) async {
    if (_database == null) return;
    final bill = _bills.firstWhere((bill) => bill.id == id);
    bill.isPaid = !bill.isPaid;
    await updateBill(bill);
  }

  // Filtering bills by date range
  Future<void> filterBillsByDate(DateTime startDate, DateTime endDate) async {
    if (_database == null) return;
    final List<Map<String, dynamic>> maps = await _database!.query(
      'bills',
      where: 'date BETWEEN ? AND ?',
      whereArgs: [
        startDate.toIso8601String(),
        endDate.toIso8601String(),
      ],
    );
    _bills = List.generate(maps.length, (i) {
      return Bill.fromMap(maps[i]);
    });
    notifyListeners();
  }

  // Filtering bills by status (Paid/Unpaid)
  Future<void> filterBillsByStatus(bool isPaid) async {
    if (_database == null) return;
    final List<Map<String, dynamic>> maps = await _database!.query(
      'bills',
      where: 'isPaid = ?',
      whereArgs: [isPaid ? 1 : 0],
    );
    _bills = List.generate(maps.length, (i) {
      return Bill.fromMap(maps[i]);
    });
    notifyListeners();
  }

  // Generate statistics
  Map<String, dynamic> getStatistics() {
    double totalSales = _bills.fold(0, (sum, bill) => sum + bill.totalAmount);
    int totalBills = _bills.length;
    int unpaidBills = _bills.where((bill) => !bill.isPaid).length;
    double unpaidPercentage = totalBills > 0
        ? (unpaidBills / totalBills) * 100
        : 0;

    return {
      'totalSales': totalSales,
      'totalBills': totalBills,
      'unpaidPercentage': unpaidPercentage,
    };
  }
  String exportToCSV() {
    List<List<String>> rows = [
      ['ID', 'Customer Name', 'Contact', 'Total Amount', 'Paid', 'Date'],
      ..._bills.map((bill) => [
        bill.id.toString(),
        bill.customerName,
        bill.customerContact,
        bill.totalAmount.toString(),
        bill.isPaid ? 'Paid' : 'Unpaid',
        DateFormat('yyyy-MM-dd').format(bill.date),
      ])
    ];
    return ListToCsvConverter().convert(rows);
  }
}
