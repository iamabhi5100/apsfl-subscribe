import 'package:apsflsubscribes/screens/paymentgateway/atom/atom_screen.dart';
// import 'package:apsflsubscribes/screens/paymentgateway/payu/MyAppState.dart';
import 'package:apsflsubscribes/screens/paymentgateway/razorpay/razorpay.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'package:apsflsubscribes/utils/pallete.dart';
import 'dart:convert';

class PaymentSelection extends StatefulWidget {
  const PaymentSelection({Key? key}) : super(key: key);

  @override
  State<PaymentSelection> createState() => _PaymentSelectionState();
}

class _PaymentSelectionState extends State<PaymentSelection> {
  String? _selectedPaymentGateway;
  late String auth;
  String? receipt;

  void _showToastNotification(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  late bool _isLoading = false;
  List<Map<String, dynamic>> _razorpayOrderIdData = [];

  Future<void> _razorpayOrderId() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    String credentials = "rzp_live_AcHzwBBsepkGJN:vBWpH9yFma5m0KmFWXew34PA";
    auth = "Basic " + base64.encode(utf8.encode(credentials));
    print('This is credentials auth , $auth');

    const String apiUrl = 'https://api.razorpay.com/v1/orders';

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

    final Map<String, String> headers = {
      'Authorization': auth,
      'Content-Type': 'application/json'
    };

    final Map<String, dynamic> requestBody = {
      "amount": 5000,
      "currency": "INR",
      "notes": {
        "app_type": "LMO",
        "mrcht_usr_id": "101013979",
        "notes_key_1": "LMOAPSFL",
        "usr_ctgry_ky": "103000730"
      },
      "receipt": "LMO-WT-1715073537220"
    };

    final http.Response response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: json.encode(requestBody),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final Map<String, dynamic>? notes = responseData['notes'];

      if (notes != null) {
        print(notes);
        setState(() {});
      } else {
        throw Exception('Notes data not found');
      }
      setState(() {});
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  // @override
  // void initState() {
  //   super.initState();
  //   _razorpayOrderId();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Pallete.backgroundColor,
        title: const Text(
          'Payment Selection',
          style: TextStyle(
            fontFamily: 'Cera-Bold',
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.28,
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration(
            color: Pallete.backgroundColor,
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.center,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'Choose your payment gateway',
                  style: TextStyle(
                    fontFamily: 'Cera-Bold',
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio<String>(
                        value: 'Atom',
                        activeColor: Pallete.buttonColor,
                        groupValue: _selectedPaymentGateway,
                        onChanged: (String? value) {
                          setState(() {
                            _selectedPaymentGateway = value;
                          });
                          _showToastNotification("Atom");
                        },
                      ),
                      const Text(
                        'Atom',
                        style: TextStyle(
                          fontFamily: 'Cera-Bold',
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      Radio<String>(
                        value: 'Razorpay',
                        activeColor: Pallete.buttonColor,
                        groupValue: _selectedPaymentGateway,
                        onChanged: (String? value) {
                          setState(() {
                            _selectedPaymentGateway = value;
                          });
                          _showToastNotification("Razorpay");
                        },
                      ),
                      const Text(
                        'Razorpay',
                        style: TextStyle(
                          fontFamily: 'Cera-Bold',
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Amount To Pay',
                  style: TextStyle(
                    fontFamily: 'Cera-Bold',
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              FutureBuilder<String>(
                future: Future<String>(() async {
                  final value =
                      await FlutterSecureStorage().read(key: 'totalPrice');
                  return value ?? '';
                }),
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else {
                    if (snapshot.hasError) {
                      return Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(color: Colors.red),
                      );
                    } else {
                      final totalPrice = snapshot.data ?? '0.00';
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          totalPrice,
                          style: const TextStyle(
                            fontFamily: 'Cera-Bold',
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      );
                    }
                  }
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_selectedPaymentGateway == null) {
                    _showToastNotification("Please Choose the Payment Gateway");
                  } else {
                    await FlutterSecureStorage()
                        .write(key: 'totalPrice', value: '35.40');
                    if (_selectedPaymentGateway == 'Atom') {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return atom_screen();
                      }));
                    } else if (_selectedPaymentGateway == 'Razorpay') {
                      await _razorpayOrderId(); // Call function to get RazorPay order ID
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Colors.white,
                            title: const Row(
                              children: [
                                Icon(Icons.warning),
                                SizedBox(width: 5),
                                Text(
                                  'Confirmation',
                                  style: TextStyle(
                                    fontFamily: 'Cera-Bold',
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                            content: const Text(
                              'Are you sure you want to proceed with the payment?',
                              style: TextStyle(
                                fontFamily: 'Cera-Bold',
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                },
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(
                                    fontFamily: 'Cera-Bold',
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
                                    return const RazorPayScreen();
                                  })); // Navigate to RazorPay screen
                                },
                                child: const Text(
                                  'Confirm',
                                  style: TextStyle(
                                    fontFamily: 'Cera-Bold',
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  }
                },
                child: const Text(
                  'Pay Now',
                  style: TextStyle(
                    fontFamily: 'Cera-Bold',
                    color: Colors.white,
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Pallete.buttonColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
