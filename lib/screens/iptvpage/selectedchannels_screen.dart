import 'package:apsflsubscribes/screens/iptvpage/buychannels_screen.dart';
// import 'package:apsflsubscribes/screens/iptvpage/paymentselection_screen.dart';
import 'package:apsflsubscribes/screens/paymentpage/paymentselection_screen.dart';
import 'package:apsflsubscribes/utils/pallete.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const List<String> list = <String>[
  'choose option',
  'Credit Card',
  'Debit Card',
  'Amex Card',
  'NetBanking',
];

class SelectedChannelScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  const SelectedChannelScreen({Key? key, required this.cartItems})
      : super(key: key);

  @override
  State<SelectedChannelScreen> createState() => _SelectedChannelScreenState();
}

class _SelectedChannelScreenState extends State<SelectedChannelScreen> {
  List<Map<String, dynamic>> _dataAlacarte = [];
  bool _isLoading = false;

  Future<void> _fetchData() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    const apiUrl =
        'http://bssuat.apsfl.co.in/apiv1/subscriberApp/cstmr_packages';

    final Map<String, String> headers = {
      'x-access-token':
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyIwIjp7ImNhZl9pZCI6MjAwMTIzNzE3LCJreWMiOiJObyIsIm1ibF9udSI6NzY3NTgzMTAxMSwiY3N0bXJfbm0iOiJzaXZlIGt1bWFyIn0sImFwcCI6bnVsbCwiaWF0IjoxNzEzNjEzMTI1fQ.yZoBPp-SyDVjmQOByN_5L4Zo_7AidiszeJ-Wita9Vgg',
      'Content-Type': 'application/json'
    };

    final Map<String, dynamic> requestBody = {
      "app_type": "Customer",
      "caf_id": "200123717",
      "device_id": "OPM1.171019.026",
      "device_name": "vivovivo+1811",
      "version_code": 26
    };

    final http.Response response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: json.encode(requestBody),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> Alacartedata =
          responseData['data']['ala_carte'] ?? [];
      final List<dynamic> Hsidata =
          responseData['data']['broadcaster_packs'] ?? [];
      final List<dynamic> FirstShowdata =
          responseData['data']['vod_packs'] ?? [];
      final List<dynamic> ExistingPackages =
          responseData['data']['existngpckgsdtls'] ?? [];
      setState(() {
        _dataAlacarte.addAll(Alacartedata.cast<Map<String, dynamic>>());

        print(_dataAlacarte);
        // Initialize the checkbox lists for each tab

        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      throw Exception('Failed to fetch data');
    }
  }

  double _calculateTotalPrice() {
    double totalPrice = 0.0;
    for (var item in widget.cartItems) {
      totalPrice += item['ttl_cst'] ?? 0.0;
    }
    return totalPrice;
  }

  bool isChecked = false; // State variable to track checkbox state

  void handleCheckbox(bool? newValue) {
    setState(() {
      isChecked = !isChecked; // Toggle the value of isChecked
      print(isChecked);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Pallete.backgroundColor,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return const BuyChannelsScreen();
            }));
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 30,
          ),
        ),
        title: const Text(
          'Selected Channels',
          style: TextStyle(
            fontFamily: 'Cera-Bold',
            color: Colors.white,
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        height: 80,
        color: const Color.fromARGB(59, 208, 203, 203),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Icon(
              Icons.shopping_cart,
              color: Colors.red,
              size: 40,
            ),
            SizedBox(
              width: 200,
              child: Text(
                _calculateTotalPrice()
                    .toStringAsFixed(2), // Display total price
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'Cera-Bold',
                  fontSize: 25,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 3, vertical: 10),
                      title: Container(
                        decoration: const BoxDecoration(
                          color: Pallete.backgroundColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 50),
                                child: Text(
                                  'Confirmation',
                                  style: TextStyle(
                                    fontFamily: 'Cera-Bold',
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      content: Container(
                        width: MediaQuery.of(context).size.width *
                            2, // Adjust the width here
                        child: Column(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // const SizedBox(height: 10),
                            const Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  'Subscription Amount',
                                  style: TextStyle(
                                    fontFamily: 'Cera-Bold',
                                  ),
                                ),
                                Text(
                                  '₹ 35.40',
                                  style: TextStyle(
                                    fontFamily: 'Cera-Bold',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: TextField(
                                controller: TextEditingController(
                                    text: 'test@gmail.com'),
                                decoration: const InputDecoration(
                                  labelText: 'Email',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Payment Mode',
                                  style: TextStyle(
                                    fontFamily: 'Cera-Bold',
                                  ),
                                ),
                                SizedBox(width: 20),
                                DropdownMenuExample(),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Center(
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 40),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 10),
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 217, 215, 215),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(40),
                                  ),
                                ),
                                child: const Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      'Grand Total:',
                                      style: TextStyle(fontFamily: 'Cera-Bold'),
                                    ),
                                    Text(
                                      '35.40',
                                      style: TextStyle(fontFamily: 'Cera-Bold'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CheckboxExample(),
                                Text(
                                  'Are you Sure you want to confirm ?',
                                  style: TextStyle(
                                    fontFamily: 'Cera-Bold',
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        ElevatedButton(
                          onPressed: () {
                            // Perform payment action here
                            // For example, you can navigate to a payment screen
                            // or trigger a payment API call
                            // After payment is completed, close the dialog
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return const PaymentSelection();
                            }));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Pallete.buttonColor,
                          ),
                          child: const Text(
                            'Proceed',
                            style: TextStyle(
                              fontFamily: 'Cera-Bold',
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: const Text(
                'PAY NOW',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Cera-Bold',
                  fontSize: 14,
                ),
              ),
            )
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: widget.cartItems.length,
        itemBuilder: (context, index) {
          final item = widget.cartItems[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: ListTile(
                title: Row(
                  children: [
                    SizedBox(
                      width: 220,
                      // color: Colors.blue,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Package Name: ',
                            style: TextStyle(
                              fontFamily: 'Cera-Bold',
                            ),
                          ),
                          Text(
                            '${item['package_name']}',
                            style: const TextStyle(
                              fontFamily: 'Cera-Bold',
                              fontSize: 14,
                            ),
                          ),
                          // const Text(
                          //   'No of Months',
                          //   style: TextStyle(
                          //     fontFamily: 'Cera-Bold',
                          //     fontSize: 14,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    SizedBox(
                      width: 80,
                      // color: Colors.amberAccent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            'Price: ',
                            style: TextStyle(
                              fontFamily: 'Cera-Bold',
                            ),
                          ),
                          Text(
                            '${item['ttl_cst']}',
                            style: const TextStyle(
                              fontFamily: 'Cera-Bold',
                              fontSize: 14,
                            ),
                          ),
                          // Row(
                          //   crossAxisAlignment: CrossAxisAlignment.start,
                          //   mainAxisAlignment: MainAxisAlignment.start,
                          //   children: [
                          //     IconButton(
                          //       color: Colors.blue,
                          //       onPressed: () {},
                          //       icon: const Icon(Icons.add),
                          //     ),
                          //     IconButton(
                          //       onPressed: () {},
                          //       icon: const Icon(Icons.remove),
                          //     ),
                          //   ],
                          // )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class DropdownMenuExample extends StatefulWidget {
  const DropdownMenuExample({super.key});

  @override
  State<DropdownMenuExample> createState() => _DropdownMenuExampleState();
}

class _DropdownMenuExampleState extends State<DropdownMenuExample> {
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      initialSelection: list.first,
      onSelected: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
        });
      },
      dropdownMenuEntries: list.map<DropdownMenuEntry<String>>((String value) {
        return DropdownMenuEntry<String>(value: value, label: value);
      }).toList(),
    );
  }
}

class CheckboxExample extends StatefulWidget {
  const CheckboxExample({super.key});

  @override
  State<CheckboxExample> createState() => _CheckboxExampleState();
}

class _CheckboxExampleState extends State<CheckboxExample> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.blue;
    }

    return Checkbox(
      checkColor: Colors.white,
      fillColor: MaterialStateProperty.resolveWith(getColor),
      value: isChecked,
      onChanged: (bool? value) {
        setState(() {
          isChecked = value!;
        });
      },
    );
  }
}
