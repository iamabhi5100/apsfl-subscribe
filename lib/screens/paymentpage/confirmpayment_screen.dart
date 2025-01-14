import 'package:apsflsubscribes/screens/paymentgateway/atom/atom_screen.dart';
// import 'package:apsflsubscribes/screens/paymentgateway/payu/MyAppState.dart';
import 'package:apsflsubscribes/screens/paymentgateway/razorpay/razorpay.dart';
import 'package:apsflsubscribes/screens/paymentpage/paymentselection_screen.dart';
import 'package:apsflsubscribes/utils/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ConfirmPaymentScreen extends StatefulWidget {
  const ConfirmPaymentScreen({super.key});

  @override
  State<ConfirmPaymentScreen> createState() => _ConfirmPaymentScreenState();
}

class _ConfirmPaymentScreenState extends State<ConfirmPaymentScreen> {
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
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return RazorPayScreen();
                            // return MyAppState();
                          }));
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
