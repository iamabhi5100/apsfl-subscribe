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
  // Define selectedDropdownValue variable
  int selectedDropdownValue = 1; // Default value
  bool _isLoading = false;
  dynamic _userData; // Define userData variable
  // Declare a variable to store the calculated total price
  late double totalPrice;
  bool confirmChecked = false;

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

  Widget _buildBottomNavigationBar() {
    bool allItemsCat2 = widget.cartItems.every((item) => item['cat_id'] == 2);
    bool hasItemCat3 = widget.cartItems.any((item) => item['cat_id'] == 3);

    if (allItemsCat2) {
      return Card(
        elevation: 8,
        child: Container(
          padding: const EdgeInsets.all(20),
          height: allItemsCat2 ? MediaQuery.of(context).size.height * 0.124 : 0,
          color: const Color.fromARGB(59, 208, 203, 203),
          child: Column(
            children: [
              Container(
                child: allItemsCat2
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: const Text(
                              'No.of Months',
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Cera-Bold',
                                fontSize: 16,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: DropdownButton<int>(
                              items: [1, 3, 6, 12].map((int value) {
                                return DropdownMenuItem<int>(
                                  value: value,
                                  child: Text(
                                    value.toString(),
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Cera-Bold',
                                      fontSize: 16,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (int? newValue) {
                                setState(() {
                                  // Handle dropdown value change
                                  selectedDropdownValue = newValue!;
                                  // Update state or perform necessary actions
                                });
                              },
                              // Set initial value of dropdown here
                              value: 1,
                            ),
                          ),
                          // Inside the SizedBox where you want to display the calculated total price
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: Center(
                              child: Text(
                                _calculateTotalPrice().toStringAsFixed(2) +
                                    ' X $selectedDropdownValue',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Cera-Bold',
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    : null,
              ),
              Row(
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
                      ' ${(_calculateTotalPrice() * selectedDropdownValue).toStringAsFixed(2)}',
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
                        // Store the total price multiplied by the selected dropdown value
                        String totalPrice =
                            (_calculateTotalPrice() * selectedDropdownValue)
                                .toStringAsFixed(2);
                        await const FlutterSecureStorage()
                            .write(key: 'totalPrice', value: totalPrice);
                        // Store the cartItems
                        String cartItemsJson = jsonEncode(widget.cartItems);
                        await const FlutterSecureStorage()
                            .write(key: 'cartItems', value: cartItemsJson);
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: Pallete.backgroundColor,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 0),
                              title: Container(
                                color: Pallete.backgroundColor,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Confirmation',
                                      style: TextStyle(
                                        fontFamily: 'Cera-Bold',
                                        color: Colors.white,
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
                              content: Container(
                                color: Colors.white,
                                width: MediaQuery.of(context).size.width *
                                    2, // Adjust the width here
                                child: Column(
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // const SizedBox(height: 10),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          const Text(
                                            'Subscription Amount',
                                            style: TextStyle(
                                              fontFamily: 'Cera-Bold',
                                            ),
                                          ),
                                          Text(
                                            totalPrice,
                                            style: const TextStyle(
                                              fontFamily: 'Cera-Bold',
                                            ),
                                          ),
                                        ],
                                      ),
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
                                    Container(
                                      height: 50,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 30),
                                      // padding: const EdgeInsets.symmetric(
                                      //     horizontal: 40, vertical: 10),
                                      decoration: const BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 217, 215, 215),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(40),
                                        ),
                                      ),
                                      child: Center(
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            const Text(
                                              'Grand Total:',
                                              style: TextStyle(
                                                  fontFamily: 'Cera-Bold'),
                                            ),
                                            Text(
                                              totalPrice,
                                              style: const TextStyle(
                                                  fontFamily: 'Cera-Bold'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // make a checkbox here
                                        Checkbox(
                                          value: confirmChecked,
                                          onChanged: (bool? newValue) {
                                            setState(() {
                                              confirmChecked = newValue ??
                                                  false; // Set default value to false if null
                                            });
                                            // Force an immediate rebuild of the UI
                                            (context as Element)
                                                .markNeedsBuild();
                                          },
                                        ),
                                        const Text(
                                          'Are you Sure you want to confirm ?',
                                          style: TextStyle(
                                            fontFamily: 'Cera-Bold',
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10.0),
                                      child: confirmChecked
                                          ? ElevatedButton(
                                              onPressed: () {
                                                // Perform payment action here
                                                // For example, you can navigate to a payment screen
                                                // or trigger a payment API call
                                                // After payment is completed, close the dialog
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                  return const PaymentSelection();
                                                }));
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Pallete.buttonColor,
                                              ),
                                              child: const Text(
                                                'CONFIRM',
                                                style: TextStyle(
                                                  fontFamily: 'Cera-Bold',
                                                  color: Colors.white,
                                                ),
                                              ),
                                            )
                                          : Container(),
                                    ),
                                  ],
                                ),
                              ),
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
            ],
          ),
        ),
      );
    } else if (hasItemCat3) {
      // Implement UI for cat_id 3 scenario
      // You can return a different widget for cat_id 3
      // For example:
      return Container(
        padding: const EdgeInsets.all(20),
        height: MediaQuery.of(context).size.height * 0.1,
        color: const Color.fromARGB(59, 208, 203, 203),
        child: Column(
          children: [
            Row(
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
                    _calculateTotalPrice().toStringAsFixed(2),
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
                      // Store the total price multiplied by the selected dropdown value
                      String totalPrice =
                          (_calculateTotalPrice() * selectedDropdownValue)
                              .toStringAsFixed(2);
                      await const FlutterSecureStorage()
                          .write(key: 'totalPrice', value: totalPrice);
                      // Store the cartItems
                      String cartItemsJson = jsonEncode(widget.cartItems);
                      await const FlutterSecureStorage()
                          .write(key: 'cartItems', value: cartItemsJson);
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Pallete.backgroundColor,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 0, vertical: 0),
                            title: Container(
                              color: Pallete.backgroundColor,
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                              color: Colors.white,
                              width: MediaQuery.of(context).size.width *
                                  2, // Adjust the width here
                              child: Column(
                                // crossAxisAlignment: CrossAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // const SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        const Text(
                                          'Subscription Amount',
                                          style: TextStyle(
                                            fontFamily: 'Cera-Bold',
                                          ),
                                        ),
                                        Text(
                                          totalPrice,
                                          style: const TextStyle(
                                            fontFamily: 'Cera-Bold',
                                          ),
                                        ),
                                      ],
                                    ),
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

                                  Container(
                                    height: 50,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 30),
                                    // padding: const EdgeInsets.symmetric(
                                    //     horizontal: 40, vertical: 10),
                                    decoration: const BoxDecoration(
                                      color: Color.fromARGB(255, 217, 215, 215),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(40),
                                      ),
                                    ),
                                    child: Center(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          const Text(
                                            'Grand Total:',
                                            style: TextStyle(
                                                fontFamily: 'Cera-Bold'),
                                          ),
                                          Text(
                                            totalPrice,
                                            style: const TextStyle(
                                                fontFamily: 'Cera-Bold'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // make a checkbox here
                                      Checkbox(
                                        value: confirmChecked,
                                        onChanged: (bool? newValue) {
                                          setState(() {
                                            confirmChecked = newValue ??
                                                false; // Set default value to false if null
                                          });
                                          // Force an immediate rebuild of the UI
                                          (context as Element).markNeedsBuild();
                                        },
                                      ),
                                      const Text(
                                        'Are you Sure you want to confirm ?',
                                        style: TextStyle(
                                          fontFamily: 'Cera-Bold',
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 10.0),
                                    child: confirmChecked
                                        ? ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                                return const PaymentSelection();
                                              }));
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Pallete.buttonColor,
                                            ),
                                            child: const Text(
                                              'CONFIRM',
                                              style: TextStyle(
                                                fontFamily: 'Cera-Bold',
                                                color: Colors.white,
                                              ),
                                            ),
                                          )
                                        : Container(),
                                  ),
                                ],
                              ),
                            ),
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
          ],
        ),
      );
    } else {
      // Handle other scenarios as needed
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    bool allItemsCat2 = widget.cartItems.every((item) => item['cat_id'] == 2);
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
      bottomNavigationBar: _buildBottomNavigationBar(),
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
