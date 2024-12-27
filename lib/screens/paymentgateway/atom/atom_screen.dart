import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'web_view_container.dart';
import 'atom_pay_helper.dart';
import 'package:http/http.dart' as http;

import 'package:apsflsubscribes/screens/paymentgateway/atom/atom_screen.dart';
import 'package:apsflsubscribes/screens/paymentpage/paymentselection_screen.dart';
import 'package:apsflsubscribes/utils/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class atom_screen extends StatelessWidget {
  // merchant configuration data
  final String login = "325861"; //mandatory
  final String password = '9c6e112c'; //mandatory
  final String prodid = 'APSFL'; //mandatory
  final String requestHashKey = 'ac95873f4f384000ea'; //mandatory
  final String responseHashKey = '174dea73c95dbdf7d2'; //mandatory
  final String requestEncryptionKey =
      '0CB4CBE5F020E4599384F6A8D17E60A8'; //mandatory
  final String responseDecryptionKey =
      'DD93018F60A201C56ED1F20A31D44BA0'; //mandatory
  final String txnid = DateTime.now()
      .millisecondsSinceEpoch
      .toString(); // unique transaction ID using current timestamp
  final String clientcode = "200123717"; //mandatory
  final String txncurr = "INR"; //mandatory
  final String mccCode = "5499"; //mandatory
  final String merchType = "R"; //mandatory
  final String amount = "1.00"; //mandatory

  final String mode = "live"; // change live for production

  final String custFirstName = 'test'; //optional
  final String custLastName = 'user'; //optional
  final String mobile = '8888888888'; //optional
  final String email = 'test@gmail.com'; //optional
  final String address = 'mumbai'; //optional
  final String custacc = '639827'; //optional
  final String udf1 = "udf1"; //optional
  final String udf2 = "udf2"; //optional
  final String udf3 = "udf3"; //optional
  final String udf4 = "udf4"; //optional
  final String udf5 = "udf5"; //optional

  // final String authApiUrl = "https://caller.atomtech.in/ots/aipay/auth"; // uat

  final String auth_API_url =
      "https://payment1.atomtech.in/ots/aipay/auth"; // prod

  // final String returnUrl =
  //     "https://pgtest.atomtech.in/mobilesdk/param"; //return url uat
  final String returnUrl =
      "https://payment.atomtech.in/mobilesdk/param"; ////return url production

  final String payDetails = '';

  atom_screen({Key? key}) : super(key: key);

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
                          _initNdpsPayment(
                              context, responseHashKey, responseDecryptionKey);
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

  // ElevatedButton(
  //   onPressed: () => _initNdpsPayment(
  //       context, responseHashKey, responseDecryptionKey),
  //   child: const Text('Open'),
  // ),
  void _initNdpsPayment(BuildContext context, String responseHashKey,
      String responseDecryptionKey) {
    _getEncryptedPayUrl(context, responseHashKey, responseDecryptionKey);
  }

  _getEncryptedPayUrl(context, responseHashKey, responseDecryptionKey) async {
    String reqJsonData = _getJsonPayloadData();
    debugPrint(reqJsonData);
    const platform = MethodChannel('flutter.dev/NDPSAESLibrary');
    try {
      final String result = await platform.invokeMethod('NDPSAESInit', {
        'AES_Method': 'encrypt',
        'text': reqJsonData, // plain text for encryption
        'encKey': requestEncryptionKey // encryption key
      });
      String authEncryptedString = result.toString();
      // here is result.toString() parameter you will receive encrypted string
      // debugPrint("generated encrypted string: '$authEncryptedString'");
      _getAtomTokenId(context, authEncryptedString);
    } on PlatformException catch (e) {
      debugPrint("Failed to get encryption string: '${e.message}'.");
    }
  }

  _getAtomTokenId(context, authEncryptedString) async {
    var request = http.Request(
        'POST', Uri.parse("https://payment1.atomtech.in/ots/aipay/auth"));
    request.bodyFields = {'encData': authEncryptedString, 'merchId': login};

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var authApiResponse = await response.stream.bytesToString();
      final split = authApiResponse.trim().split('&');
      final Map<int, String> values = {
        for (int i = 0; i < split.length; i++) i: split[i]
      };
      final splitTwo = values[1]!.split('=');
      if (splitTwo[0] == 'encData') {
        const platform = MethodChannel('flutter.dev/NDPSAESLibrary');
        try {
          final String result = await platform.invokeMethod('NDPSAESInit', {
            'AES_Method': 'decrypt',
            'text': splitTwo[1].toString(),
            'encKey': responseDecryptionKey
          });
          debugPrint(result.toString()); // to read full response
          var respJsonStr = result.toString();
          Map<String, dynamic> jsonInput = jsonDecode(respJsonStr);
          if (jsonInput["responseDetails"]["txnStatusCode"] == 'OTS0000') {
            final atomTokenId = jsonInput["atomTokenId"].toString();
            debugPrint("atomTokenId: $atomTokenId");
            final String payDetails =
                '{"atomTokenId" : "$atomTokenId","merchId": "$login","emailId": "$email","mobileNumber":"$mobile", "returnUrl":"$returnUrl"}';
            _openNdpsPG(
                payDetails, context, responseHashKey, responseDecryptionKey);
          } else {
            debugPrint("Problem in auth API response");
          }
        } on PlatformException catch (e) {
          debugPrint("Failed to decrypt: '${e.message}'.");
        }
      }
    }
  }

  _openNdpsPG(payDetails, context, responseHashKey, responseDecryptionKey) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WebViewContainer(
                mode, payDetails, responseHashKey, responseDecryptionKey)));
  }

  _getJsonPayloadData() {
    var payDetails = {};
    payDetails['login'] = login;
    payDetails['password'] = password;
    payDetails['prodid'] = prodid;
    payDetails['custFirstName'] = custFirstName;
    payDetails['custLastName'] = custLastName;
    payDetails['amount'] = amount;
    payDetails['mobile'] = mobile;
    payDetails['address'] = address;
    payDetails['email'] = email;
    payDetails['txnid'] = txnid;
    payDetails['custacc'] = custacc;
    payDetails['requestHashKey'] = requestHashKey;
    payDetails['responseHashKey'] = responseHashKey;
    payDetails['requestencryptionKey'] = requestEncryptionKey;
    payDetails['responseencypritonKey'] = responseDecryptionKey;
    payDetails['clientcode'] = clientcode;
    payDetails['txncurr'] = txncurr;
    payDetails['mccCode'] = mccCode;
    payDetails['merchType'] = merchType;
    payDetails['returnUrl'] = returnUrl;
    payDetails['mode'] = mode;
    payDetails['udf1'] = udf1;
    payDetails['udf2'] = udf2;
    payDetails['udf3'] = udf3;
    payDetails['udf4'] = udf4;
    payDetails['udf5'] = udf5;
    String jsonPayLoadData = getRequestJsonData(payDetails);
    return jsonPayLoadData;
  }
}
