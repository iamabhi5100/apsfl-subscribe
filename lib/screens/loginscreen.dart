import 'package:apsflsubscribes/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Import flutter_secure_storage
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'forgotpassword.dart'; // Import your ForgotPassword screen here
import 'package:apsflsubscribes/utils/pallete.dart'; // Import your Palette here
import 'package:fluttertoast/fluttertoast.dart'; // Import fluttertoast package

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final String _apiUrl =
      'http://bss.apsfl.co.in/apiv1/subscriberApplogin'; // Your API URL
  final _storage = FlutterSecureStorage(); // Instance of FlutterSecureStorage
  bool _isPasswordVisible = false; // Declare _isPasswordVisible variable

  void _showToastNotification() {
    Fluttertoast.showToast(
      msg: "No matching record Found",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void _showToastNotificationServerDown() {
    Fluttertoast.showToast(
      msg: "No matching record Found",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Future<void> _handleLogin(BuildContext context) async {
    final String username = _usernameController.text.trim();
    final String password = _passwordController.text.trim();
    final Map<String, dynamic> postData = {
      'app_type': '',
      'device_id': '',
      'device_type': '',
      'email': username,
      'fcm_id': '',
      'pwd': password,
      'version_code': '',
    };

    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(postData),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData.containsKey('data') &&
            responseData['data'].containsKey('accessToken')) {
          final token = responseData['data']['accessToken'];
          final cafId = responseData['data']['caf_id']; // Extract caf_id
          final cstmr_nm = responseData['data']['cstmr_nm']; // Extract cstmr_nm
          final mbl_nu = responseData['data']['mbl_nu']; // Extract mbl_nu
          // Store cstmr_nm securely
          await _storage.write(key: 'cstmr_nm', value: cstmr_nm);
          // Store token securely
          await _storage.write(key: 'token', value: token);
          // Store caf_id securely
          await _storage.write(key: 'caf_id', value: cafId.toString());
          // Store mbl_nu securely
          await _storage.write(key: 'mbl_nu', value: mbl_nu.toString());
          // Navigate to home page
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (context) {
            return HomePage();
          }));
        } else {
          // Handle invalid credentials
          _showToastNotification();
        }
      } else {
        // Handle HTTP request error
      }
    } catch (error) {
      // Handle other errors
      // Server Down
      _showToastNotificationServerDown();
      print(' Handle invalid credentials');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/apsfllogoblack.png',
                ),
              ),
            ),
            height: 150,
          ),
          const SizedBox(height: 10), // Adjust spacing as needed
          const Text(
            'MORE THAN 10 LAKHS HAPPY USERS\n SERVED EVERYDAY',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                fontFamily: 'Cera-Bold'),
          ),
          const SizedBox(height: 10), // Adjust spacing as needed
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.smartphone),
                labelText: 'Enter CAF ID/ONU No/Mobile No',
                labelStyle: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cera-Bold',
                ),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(40)),
              ),
            ),
          ),
          const SizedBox(height: 0), // Adjust spacing as needed
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              controller: _passwordController,
              obscureText:
                  !_isPasswordVisible, // Toggle visibility based on state
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                  icon: Icon(_isPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off), // Change icon based on state
                ),
                labelText: 'Password',
                labelStyle: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cera-Bold',
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
            ),
          ),
          const SizedBox(height: 0), // Adjust spacing as needed
          Align(
            alignment: Alignment.center,
            child: TextButton(
              onPressed: () {
                // Add onPressed logic for forgot password link
              },
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return const ForgotPassword();
                  }));
                },
                child: const Text(
                  'Forgot your Password?',
                  style: TextStyle(
                    color: Color.fromARGB(255, 7, 7, 7),
                    decoration: TextDecoration.underline,
                    fontFamily: 'Cera-Medium',
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 0), // Adjust spacing as needed
          SizedBox(
            width: 200,
            child: ElevatedButton(
              onPressed: () => _handleLogin(context),
              child: const Text(
                'SIGN IN',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Pallete.buttonColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
