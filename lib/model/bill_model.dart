// class Bill {
//   int? id;
//   String customerName;
//   String customerContact;
//   List<Item> items;
//   double totalAmount;
//   bool isPaid;
//   DateTime date;
//
//   Bill({
//     this.id,
//     required this.customerName,
//     required this.customerContact,
//     required this.items,
//     required this.totalAmount,
//     this.isPaid = false,
//     required this.date,
//   });
//
//   // Convert Bill to a map for SQLite
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'customerName': customerName,
//       'customerContact': customerContact,
//       'totalAmount': totalAmount,
//       'isPaid': isPaid ? 1 : 0,
//       'date': date.toIso8601String(),
//     };
//   }
//
//   // Convert map to Bill
//   factory Bill.fromMap(Map<String, dynamic> map) {
//     return Bill(
//       id: map['id'],
//       customerName: map['customerName'],
//       customerContact: map['customerContact'],
//       items: [], // Items will be added separately
//       totalAmount: map['totalAmount'],
//       isPaid: map['isPaid'] == 1,
//       date: DateTime.parse(map['date']),
//     );
//   }
// }
//
// class Item {
//   final String name;
//   final int quantity;
//   final double unitPrice;
//
//   Item({
//     required this.name,
//     required this.quantity,
//     required this.unitPrice,
//   });
//
//   double get totalPrice => quantity * unitPrice;
//
//   Map<String, dynamic> toMap() {
//     return {
//       'name': name,
//       'quantity': quantity,
//       'unitPrice': unitPrice,
//     };
//   }
//
//   // Convert a Map into an Item object
//   factory Item.fromMap(Map<String, dynamic> map) {
//     return Item(
//       name: map['name'],
//       quantity: map['quantity'],
//       unitPrice: map['unitPrice'],
//     );
//   }
// }
class Bill {
  int? id;
  String customerName;
  String customerContact;
  List<Item> items;
  double totalAmount;
  bool isPaid;
  DateTime date;

  Bill({
    this.id,
    required this.customerName,
    required this.customerContact,
    required this.items,
    required this.totalAmount,
    required this.isPaid,
    required this.date,
  });

  // To insert into database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerName': customerName,
      'customerContact': customerContact,
      'totalAmount': totalAmount,
      'isPaid': isPaid ? 1 : 0,
      'date': date.toIso8601String(),
    };
  }

  // To create Bill object from map
  factory Bill.fromMap(Map<String, dynamic> map) {
    return Bill(
      id: map['id'],
      customerName: map['customerName'],
      customerContact: map['customerContact'],
      totalAmount: map['totalAmount'],
      isPaid: map['isPaid'] == 1,
      date: DateTime.parse(map['date']),
      items: [], // Items will be handled separately
    );
  }

  // copyWith method to create a new instance with updated values
  Bill copyWith({
    int? id,
    String? customerName,
    String? customerContact,
    List<Item>? items,
    double? totalAmount,
    bool? isPaid,
    DateTime? date,
  }) {
    return Bill(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      customerContact: customerContact ?? this.customerContact,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      isPaid: isPaid ?? this.isPaid,
      date: date ?? this.date,
    );
  }
}

class Item {
  final String name;
  final int quantity;
  final double unitPrice;
  final double total;

  Item({
    required this.name,
    required this.quantity,
    required this.unitPrice,
  }) : total = quantity * unitPrice;

  Map<String, dynamic> toMap() {
    return {
      'itemName': name,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'total': total,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      name: map['itemName'],
      quantity: map['quantity'],
      unitPrice: map['unitPrice'],
    );
  }
}

