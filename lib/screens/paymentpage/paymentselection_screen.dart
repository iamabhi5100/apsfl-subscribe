import 'package:apsflsubscribes/screens/iptvpage/selectedchannels_screen.dart';
import 'package:apsflsubscribes/screens/paymentpage/confirmpayment_screen.dart';
import 'package:flutter/material.dart';
import 'package:apsflsubscribes/utils/pallete.dart';

class PaymentSelection extends StatefulWidget {
  const PaymentSelection({Key? key}) : super(key: key);

  @override
  State<PaymentSelection> createState() => _PaymentSelectionState();
}

class _PaymentSelectionState extends State<PaymentSelection> {
  String? _selectedPaymentGateway;

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
              // Radio buttons for payment gateways
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio<String>(
                        value: 'Atom',
                        groupValue: _selectedPaymentGateway,
                        onChanged: (String? value) {
                          setState(() {
                            _selectedPaymentGateway = value;
                          });
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
                        value: 'PayU',
                        groupValue: _selectedPaymentGateway,
                        onChanged: (String? value) {
                          setState(() {
                            _selectedPaymentGateway = value;
                          });
                        },
                      ),
                      const Text(
                        'PayU',
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
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  '35.40',
                  style: TextStyle(
                    fontFamily: 'Cera-Bold',
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
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
                              Navigator.of(context).pop(); // Close the dialog
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
                              // Put your logic for payment here
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return const ConfirmPaymentScreen();
                              })); // Close the dialog
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
                },
                child: Text(
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
