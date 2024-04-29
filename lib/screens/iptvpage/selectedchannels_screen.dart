import 'package:apsflsubscribes/screens/iptvpage/buychannels_screen.dart';
// import 'package:apsflsubscribes/screens/iptvpage/paymentselection_screen.dart';
import 'package:apsflsubscribes/screens/paymentpage/paymentselection_screen.dart';
import 'package:apsflsubscribes/utils/pallete.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
  dynamic _userData; // Define userData variable

  @override
  void initState() {
    super.initState();

    print('MyplanScreen initState');
  }

  Future<void> _fetchData() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    const apiUrl =
        'http://bss.apsfl.co.in/apiv1/subscriberApp/Checksubalacartedata';

    final storage = FlutterSecureStorage();
    final String? token = await storage.read(key: 'token');
    final String? cafId = await storage.read(key: 'caf_id');

    if (token == null || cafId == null) {
      setState(() {
        _isLoading = false;
      });
      // Handle the case where token or caf_id is not available
      return;
    }

    // Logic to generate catIds and packageIds from cartItems
    final catIds = widget.cartItems.map((item) => item['cat_id']).join(',');
    final packageIds =
        widget.cartItems.map((item) => item['package_id']).join(',');

    final Map<String, String> headers = {
      'x-access-token': token,
      'Content-Type': 'application/json'
    };

    final Map<String, dynamic> requestBody = {
      "app_type": "Customer",
      "caf_id": int.parse(cafId), // Parse caf_id to int if needed
      "device_id": "OPM1.171019.026",
      "device_name": "vivovivo+1811",
      "version_code": 26,
      "package_ids": packageIds,
      "cat_ids": catIds,
    };

    final http.Response response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: json.encode(requestBody),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      _userData = responseData['message']; // Update userData
      print('selected channels $_userData');
      setState(() {
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

  void _showToastNotification() {
    Fluttertoast.showToast(
      msg: "Already Package Exists in Plan",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
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
              onPressed: () async {
                // Call _fetchData
                await _fetchData();
                // Check the response data
                if (_isLoading) {
                  // Show loading indicator
                  return;
                }

                final successMessage = 'success';
                final alreadyExistsMessage = 'Already Package Exits';

                // Check the response data
                if (_userData == successMessage) {
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
                        content: SizedBox(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
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
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 40),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 40, vertical: 10),
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 217, 215, 215),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(40),
                                    ),
                                  ),
                                  child: const Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        'Grand Total:',
                                        style:
                                            TextStyle(fontFamily: 'Cera-Bold'),
                                      ),
                                      Text(
                                        '35.40',
                                        style:
                                            TextStyle(fontFamily: 'Cera-Bold'),
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
                } else if (_userData == alreadyExistsMessage) {
                  // Show toast notification
                  _showToastNotification();
                }
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

          String durationText = '';

          // Determine duration text based on the cat_id of the current item
          switch (item['cat_id']) {
            case 2:
              durationText = '(for 30 days)';
              break;
            case 3:
              durationText = '(till your existing pack)';
              break;
            case 4:
              durationText = '(for one day)';
              break;
            // Add more cases as needed
            default:
              break;
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: ListTile(
                title: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.84,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.42,
                                child: const Text(
                                  'Package Name ',
                                  style: TextStyle(
                                    fontFamily: 'Cera-Bold',
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.42,
                                child: Column(
                                  children: [
                                    const Text(
                                      'Price ',
                                      style: TextStyle(
                                        fontFamily: 'Cera-Bold',
                                      ),
                                    ),
                                    Text(
                                      durationText,
                                      style: const TextStyle(
                                        fontFamily: 'Cera-Bold',
                                        color: Colors.black,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.84,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.42,
                                child: Text(
                                  '${item['package_name']}',
                                  style: const TextStyle(
                                    fontFamily: 'Cera-Bold',
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.42,
                                child: Column(
                                  children: [
                                    Text(
                                      '${item['ttl_cst']}',
                                      style: const TextStyle(
                                        fontFamily: 'Cera-Bold',
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
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














// SizedBox(
//                       width: 100,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           Text(
//                             '${item['package_name']}',
//                             style: const TextStyle(
//                               fontFamily: 'Cera-Bold',
//                               fontSize: 14,
//                             ),
//                           ),
//                           Text(
//                             durationText, // Display duration text based on catIds
//                             style: const TextStyle(
//                               fontFamily: 'Cera-Bold',
//                               color: Colors.black,
//                               fontSize: 10,
//                             ),
//                           ),
//                           Text(
//                             '${item['ttl_cst']}',
//                             style: const TextStyle(
//                               fontFamily: 'Cera-Bold',
//                               fontSize: 14,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),