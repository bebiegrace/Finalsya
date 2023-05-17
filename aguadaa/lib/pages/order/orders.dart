import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'database.dart';
import 'order_model.dart';
import 'order_now.dart';

class myOrders extends StatefulWidget {
  const myOrders({Key? key}) : super(key: key);

  @override
  State<myOrders> createState() => _myOrdersPageState();
}

class _myOrdersPageState extends State<myOrders> {
  bool isLoading = false;
  List<Order> orders = [];
  final MyDatabase _myDatabase = MyDatabase();
  int count = 0;
  DateTime? selectedDate;

  Future<void> getDataFromDb() async {
    setState(() {
      isLoading = true;
    });

    await _myDatabase.openDb();
    final List<Order> result = await _myDatabase.getOrders();
    orders.clear();
    orders.addAll(result);
    count = await _myDatabase.countEmp();
    setState(() {
      isLoading = false;
    });
  }

  // Future<void> filterOrdersByDate(DateTime? date) async {
  //   if (date != null) {
  //     setState(() {
  //       isLoading = true;
  //     });

  //     final List result = await _myDatabase.getOrdersByDate(date);
  //     orders.clear();
  //     orders.addAll(result as Iterable<Order>);
  //     count = orders.length;
  //     setState(() {
  //       isLoading = false;
  //     });
  //   } else {
  //     await getDataFromDb();
  //   }
  // }

  void filterOrdersByDate() {
    if (selectedDate != null) {
      final filteredOrders = orders
          .where((order) =>
              order.orderDate.year == selectedDate!.year &&
              order.orderDate.month == selectedDate!.month &&
              order.orderDate.day == selectedDate!.day)
          .toList();
      setState(() {
        orders = filteredOrders;
      });
    } else {
      getDataFromDb();
    }
  }

  @override
  void initState() {
    super.initState();
    getDataFromDb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders ($count)'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : orders.isEmpty
              ? const Center(
                  child: Text('No Orders yet'),
                )
              : ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) => Card(
                    child: ListTile(
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => EditOrder(
                        //       order: orders[index],
                        //       myDatabase: _myDatabase,
                        //     ),
                        //   ),
                        // );
                      },
                      title: Text(
                        '${orders[index].cusName} (${orders[index].orderId})',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),

                      // subtitle: orders[index].cusAddress != null
                      //     ? Text(orders[index].cusAddress!)
                      //     : null,

                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Details:',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(
                              'Customer Address: ${orders[index].cusAddress ?? 'N/A'}'),
                          Text('Contact: ${orders[index].contact ?? 'N/A'}'),
                          Text('Amount: ${orders[index].amount ?? 'N/A'}'),
                          Text(
                              'Product Type: ${orders[index].producttype ?? 'N/A'}'),
                          Text('Payment: ${orders[index].payment ?? 'N/A'}'),
                          Text('Status: ${orders[index].status}'),
                          Text('Quantity: ${orders[index].quantity ?? 'N/A'}'),
                          const SizedBox(height: 4),
                          Text('Order Date: ${orders[index].orderDate}'),
                        ],
                      ),
                      // trailing: IconButton(
                      //   onPressed: () async {
                      //     final empName = orders[index].cusName;
                      //     await _myDatabase.deleteOrder(orders[index].orderId!);
                      //     if (mounted) {
                      //       ScaffoldMessenger.of(context).showSnackBar(
                      //         SnackBar(
                      //           backgroundColor: Colors.red,
                      //           content: Text('$empName deleted.'),
                      //         ),
                      //       );
                      //       await getDataFromDb();
                      //     }
                      //   },
                      //   icon: const Icon(Icons.delete),
                      // ),
                    ),
                  ),
                ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () async {
              final user = FirebaseAuth.instance.currentUser;
              final userId = user?.uid;
              if (userId != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddOrder(
                        myDatabase: _myDatabase,
                        userId: userId,
                        onOrderAdded: () async {
                          await getDataFromDb();
                        }),
                  ),
                ).then((value) async {
                  if (value != null && value) {
                    await getDataFromDb();
                  }
                });
              } else {}

              // ).then((value) async {
              //   if (value != null && value) {
              //     await getDataFromDb();
              //   }
              // });
            },
          ),
          FloatingActionButton(
            child: const Icon(Icons.calendar_today),
            onPressed: () async {
              final DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2022),
                lastDate: DateTime.now(),
              );
              if (pickedDate != null) {
                setState(() {
                  selectedDate = pickedDate;
                  filterOrdersByDate();
                });
              }
            },
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            child: const Icon(Icons.list),
            onPressed: () {
              setState(() {
                selectedDate = null;
                getDataFromDb();
              });
            },
          ),
        ],
      ),
    );
  }
}
