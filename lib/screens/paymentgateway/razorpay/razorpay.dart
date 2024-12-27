import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import 'package:apsflsubscribes/screens/paymentgateway/atom/atom_screen.dart';
import 'package:apsflsubscribes/screens/paymentpage/paymentselection_screen.dart';
import 'package:apsflsubscribes/utils/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class RazorPayScreen extends StatefulWidget {
  const RazorPayScreen({super.key});

  @override
  State<RazorPayScreen> createState() => _RazorPayScreenState();
}

class _RazorPayScreenState extends State<RazorPayScreen> {
  late Razorpay _razorpay;
  TextEditingController amtController = TextEditingController();

  void handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
        msg: "Payment Successful" + response.paymentId!,
        toastLength: Toast.LENGTH_SHORT);
  }

  void handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "Payment Fail" + response.message!,
        toastLength: Toast.LENGTH_SHORT);
  }

  void handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "External Wallet" + response.walletName!,
        toastLength: Toast.LENGTH_SHORT);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
  }

  void openCheckout(amount) async {
    final storage = FlutterSecureStorage();
    final String? mbl_nu = await storage.read(key: 'mbl_nu');

    var options = {
      'key': 'rzp_live_AcHzwBBsepkGJN',
      'amount': amount,
      'name': 'ANDHRA PRADESH STATE FIBRE NET',
      'image': 'https://apsfl.in/image/APSFL_logo.png',
      'theme.color': '#2196f3 ',
      'currency': 'INR',
      'prefill': {'contact': mbl_nu ?? '', 'email': 'test@gmail.com'},
      'timeout': 300,
      'order_id': 'order_O7a0IIZlNJ1cb5', // Generate order_id using Orders API
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error : e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Pallete.backgroundColor,
        title: const Text(
          'APSFL',
          style: TextStyle(
            fontFamily: 'Cera-Bold',
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return const PaymentSelection();
            }));
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Center(
            child: Container(
              height: 250,
              width: 350,
              margin: const EdgeInsets.only(top: 200),
              decoration: BoxDecoration(
                color: Pallete.backgroundColor,
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 20, bottom: 20),
                    child: Image.asset('assets/images/navlogo.png'),
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
                              " Rs " + totalPrice + " /- ",
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
                  const Text(
                    'Subscription',
                    style: TextStyle(
                      fontFamily: 'Cera-Bold',
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: SizedBox(
                      width: 180,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            int amount = 10;
                            openCheckout(amount);
                          });
                        },
                        child: const Text(
                          'Confirm',
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
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              border: Border.all(width: 2, color: Pallete.buttonColor),
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: const Text(
              'Secure Payment by APSFL',
              style: TextStyle(
                fontFamily: 'Cera-Medium',
                fontStyle: FontStyle.italic,
              ),
            ),
          )
        ],
      ),
    );
  }
}





// TODO:
// testing ids for upi payments
// FOR SUCCESS:- 
// success@razorpay

// FOR FAILURE
// failure@razorpay