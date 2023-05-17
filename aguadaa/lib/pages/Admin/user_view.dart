import 'package:aguadaa/pages/employees/sales_report_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../employees/order_view.dart';
import '../order/database.dart';
import '../order/order_model.dart';
import '../register_page.dart';
import 'add_employee.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  bool isLoading = false;
  List<Order> orders = [];
  final MyDatabase _myDatabase = MyDatabase();
  int count = 0;

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

  @override
  void initState() {
    super.initState();
    getDataFromDb();
  }

  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: () {
      //   dismissKeyboard();
      // },
      child: Scaffold(
        primary: false,
        appBar: AppBar(
          elevation: 0,

          toolbarHeight: 90,
          title: const Text(
            "Users",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,

              // fontWeight: FontWeight.bold,
            ),
          ),
          automaticallyImplyLeading: true,
          //  ckgroundColor: Color.alphaBlend(foreground, background), ba
        ),
        body: _content(),
      ),
    );
  }

  Widget _content() {
    return Material(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius:
                    const BorderRadius.only(bottomRight: Radius.circular(50))),
            child: Column(
              children: [
                const SizedBox(height: 50),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                  title: Text(
                    "Hi",
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(color: Colors.white),
                  ),
                  subtitle: Text(
                    "Admin",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: Colors.white54),
                  ),
                  trailing: const CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('lib/images/user.jpg'),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final myDatabase = MyDatabase();
              await myDatabase.openDb();
              List<Order> orders = await myDatabase.getOrders();

              if (mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const CusOrders()),
                  (route) => false,
                );
              }
            },
            child: const Text('Employee'),
          ),
          ElevatedButton(
            onPressed: () async {
              final myDatabase = MyDatabase();
              await myDatabase.openDb();
              List<Order> orders = await myDatabase.getOrders();

              if (mounted) {
                Navigator.pop(context);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const salesReport()),
                  (route) => false,
                );
              }
            },
            child: const Text('Customers'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => RegisterPageEmployee(
                          onTap: () {},
                        )),
              );
            },
            child: const Text('Add Employee'),
            // child: GestureDetector(
            // onTap: () {
            //   // Add the desired functionality for the onTap callback
            //   print('Register now tapped!');
            // },
            // child: const Text(
            //   'Add Employee',
            //   style: TextStyle(
            //     color: Colors.blue,
            //     fontWeight: FontWeight.bold,
            //   ),
            //   // ),
            // ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: ListView(
  //       padding: EdgeInsets.zero,
  //       children: [
  //         Container(
  //           decoration: BoxDecoration(
  //               color: Theme.of(context).primaryColor,
  //               borderRadius:
  //                   const BorderRadius.only(bottomRight: Radius.circular(50))),
  //           child: Column(
  //             children: [
  //               const SizedBox(height: 50),
  //               ListTile(
  //                 contentPadding: const EdgeInsets.symmetric(horizontal: 30),
  //                 title: Text(
  //                   "Hi",
  //                   style: Theme.of(context)
  //                       .textTheme
  //                       .headlineSmall
  //                       ?.copyWith(color: Colors.white),
  //                 ),
  //                 subtitle: Text(
  //                   "Admin",
  //                   style: Theme.of(context)
  //                       .textTheme
  //                       .titleMedium
  //                       ?.copyWith(color: Colors.white54),
  //                 ),
  //                 trailing: const CircleAvatar(
  //                   radius: 30,
  //                   backgroundImage: AssetImage('lib/images/user.jpg'),
  //                 ),
  //               ),
  //               const SizedBox(height: 30),
  //             ],
  //           ),
  //         ),
  //         ElevatedButton(
  //           onPressed: () async {
  //             final myDatabase = MyDatabase();
  //             await myDatabase.openDb();
  //             List<Order> orders = await myDatabase.getOrders();

  //             if (mounted) {
  //               Navigator.pushAndRemoveUntil(
  //                 context,
  //                 MaterialPageRoute(builder: (context) => const CusOrders()),
  //                 (route) => false,
  //               );
  //             }
  //           },
  //           child: const Text('Employee'),
  //         ),
  //         ElevatedButton(
  //           onPressed: () async {
  //             final myDatabase = MyDatabase();
  //             await myDatabase.openDb();
  //             List<Order> orders = await myDatabase.getOrders();

  //             if (mounted) {
  //               Navigator.pop(context);
  //               Navigator.pushAndRemoveUntil(
  //                 context,
  //                 MaterialPageRoute(builder: (context) => const salesReport()),
  //                 (route) => false,
  //               );
  //             }
  //           },
  //           child: const Text('Customers'),
  //         ),
  //         ElevatedButton(
  //           onPressed: () {
  //             Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                   builder: (context) => RegisterPageEmployee(
  //                         onTap: () {},
  //                       )),
  //             );
  //           },
  //           child: const Text('Add Employee'),
  //           // child: GestureDetector(
  //           // onTap: () {
  //           //   // Add the desired functionality for the onTap callback
  //           //   print('Register now tapped!');
  //           // },
  //           // child: const Text(
  //           //   'Add Employee',
  //           //   style: TextStyle(
  //           //     color: Colors.blue,
  //           //     fontWeight: FontWeight.bold,
  //           //   ),
  //           //   // ),
  //           // ),
  //         ),
  //         SizedBox(height: 10),
  //         ElevatedButton(
  //           onPressed: () {
  //             Navigator.pop(context);
  //           },
  //           child: const Text('Go Back'),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  itemDashboard(String title, IconData iconData, Color background) => Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 5),
                color: Theme.of(context).primaryColor.withOpacity(.2),
                spreadRadius: 2,
                blurRadius: 5,
              )
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration:
                  BoxDecoration(color: background, shape: BoxShape.circle),
              child: Icon(
                iconData,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      );
}
