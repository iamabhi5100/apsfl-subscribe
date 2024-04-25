import 'package:apsflsubscribes/screens/changepassword_screen.dart';
import 'package:apsflsubscribes/screens/home_screen.dart';
import 'package:apsflsubscribes/screens/kyc_screen.dart';
import 'package:apsflsubscribes/screens/loginscreen.dart';
import 'package:apsflsubscribes/screens/updatemobilepassword_screen.dart';
import 'package:apsflsubscribes/utils/pallete.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<Map<String, dynamic>> _subscriberApploginDtlsData = [];

  @override
  void initState() {
    super.initState();
    _subscriberApploginDtls();
  }

  Future<void> _subscriberApploginDtls() async {
    const String apiUrl = 'http://bss.apsfl.co.in/apiv1/subscriberApploginDtls';

    final Map<String, String> headers = {
      'x-access-token':
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IjEifQ.eyIwIjp7ImNhZl9pZCI6MjAwMTIzNzE3LCJreWMiOiJObyIsIm1ibF9udSI6Nzk4OTkyNTc2MSwiY3N0bXJfbm0iOiJzaXZlIGt1bWFyIn0sImFwcCI6IiIsImlhdCI6MTcwNjU5OTM3OCwiZXhwIjoxNzA2NjEwMTc4LCJhdWQiOiJodHRwOi8vZHJlYW1zdGVwLmNvbSIsImlzcyI6IkRyZWFtc3RlcCIsInN1YiI6InVuZGVmaW5lZF91c2VyIiwianRpIjoiMSJ9.8O88U3mzwKQvTsVlzC6kYPmy6f6DTgrrIrNi3uO4yLA',
      'Content-Type': 'application/json'
    };

    final Map<String, dynamic> requestBody = {
      "app_type": "Customer",
      "caf_id": 200123717,
      "device_id": "OPM1.171019.026",
      "device_type": "vivovivo+1811"
    };

    final http.Response response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: json.encode(requestBody),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> data = responseData['data'] ?? [];
      setState(() {
        _subscriberApploginDtlsData = List<Map<String, dynamic>>.from(data);
      });
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  @override
  Widget build(BuildContext context) {
    String Caf_Nu = ''; // Change the type to String
    String sts_nm = '';
    String mdlwe_sbscr_id = '';
    String cstmrName = '';
    String cntct_mble1_nu = '';
    String pckge_nm = '';
    if (_subscriberApploginDtlsData.isNotEmpty) {
      cstmrName = _subscriberApploginDtlsData.first['cstmr_nm'] ?? '';
      Caf_Nu = _subscriberApploginDtlsData.first['caf_nu'].toString() ??
          ''; // Convert int to String
      mdlwe_sbscr_id = _subscriberApploginDtlsData.first['mdlwe_sbscr_id'] ??
          ''; // Convert int to String
      sts_nm = _subscriberApploginDtlsData.first['sts_nm'] ??
          ''; // Convert int to String
      cntct_mble1_nu = _subscriberApploginDtlsData.first['cntct_mble1_nu'] ??
          ''; // Convert int to String
      pckge_nm = _subscriberApploginDtlsData.first['pckge_nm'] ??
          ''; // Convert int to String
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return HomePage();
            }));
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 30,
          ),
        ),
        title: const Text(
          'Profile',
          style: TextStyle(fontFamily: 'Cera-Bold', color: Colors.white),
        ),
        backgroundColor: Pallete.backgroundColor,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.only(top: 25),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'CAF ID',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Cera-Medium',
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'CAF Status',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Cera-Medium',
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Subscribe ID',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Cera-Medium',
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Name',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Cera-Medium',
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Mobile',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Cera-Medium',
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Package Details',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Cera-Medium',
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ':',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Cera-Medium',
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        ':',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Cera-Medium',
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        ':',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Cera-Medium',
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        ':',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Cera-Medium',
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        ':',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Cera-Medium',
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        ':',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Cera-Medium',
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Caf_Nu,
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Cera-Medium',
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        sts_nm,
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Cera-Medium',
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        mdlwe_sbscr_id,
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Cera-Medium',
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        cstmrName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Cera-Medium',
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        cntct_mble1_nu,
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Cera-Medium',
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        pckge_nm,
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Cera-Medium',
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            child: Column(
              children: [
                const SizedBox(
                  height: 25,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          color: Colors.grey,
                          width: 2,
                          style: BorderStyle.solid,
                        ),
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return const KycScreen();
                      }));
                    },
                    child: const Text(
                      'SELF KYC DETAILS',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Cera-Bold',
                          fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          color: Colors.grey,
                          width: 2,
                          style: BorderStyle.solid,
                        ),
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return const UpdateMobileNumber();
                      }));
                    },
                    child: const Text(
                      'UPDATE MOBILE NUMBER',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Cera-Bold',
                          fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          color: Colors.grey,
                          width: 2,
                          style: BorderStyle.solid,
                        ),
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return const ChangePassword();
                      }));
                    },
                    child: const Text(
                      'CHANGE PASSWORD',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Cera-Bold',
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Pallete.buttonColor,
                    ),
                    onPressed: () async {
                      final _storage = FlutterSecureStorage();
                      await _storage.delete(
                          key: 'token'); // Remove token from storage
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) {
                        return LoginScreen();
                      }));
                    },
                    child: const Text(
                      'LOGOUT',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Cera-Bold',
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
