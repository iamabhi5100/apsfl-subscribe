import 'dart:convert';

import 'package:apsflsubscribes/screens/home_screen.dart';
import 'package:apsflsubscribes/utils/pallete.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class DropdownMenuExample extends StatefulWidget {
  const DropdownMenuExample({Key? key}) : super(key: key);

  @override
  State<DropdownMenuExample> createState() => _DropdownMenuExampleState();
}

class _DropdownMenuExampleState extends State<DropdownMenuExample> {
  late bool _isLoading = false;
  String dropdownValue = '';
  List<Map<String, dynamic>> _complaintsCat = [];

  @override
  void initState() {
    super.initState();

    _get_comp_cat();
  }

  Future<void> _get_comp_cat() async {
    const String apiUrl =
        'http://bss.apsfl.co.in/apiv1/subscriberApp/get_comp_cat';

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
      'x-access-token': token,
      'Content-Type': 'application/json'
    };

    final Map<String, dynamic> requestBody = {
      "app_type": "Customer",
      "caf_id": int.parse(cafId), // Parse caf_id to int if needed
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
        _complaintsCat = List<Map<String, dynamic>>.from(data);
        // Add default option at the beginning of the list
        _complaintsCat
            .insert(0, {'category': 'Select Complaint Category', 'id': null});
        dropdownValue =
            _complaintsCat.isNotEmpty ? _complaintsCat.first['category'] : '';
      });
    } else {
      throw Exception('Failed to fetch complaints');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: DropdownMenu<String>(
        width: MediaQuery.of(context).size.width * 0.9,
        initialSelection: dropdownValue,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 4, color: Colors.black),
            borderRadius: BorderRadius.all(
              Radius.circular(40),
            ),
          ),
        ),
        onSelected: (String? value) {
          setState(() {
            dropdownValue = value!;
          });
        },
        dropdownMenuEntries: _complaintsCat
            .map<DropdownMenuEntry<String>>((Map<String, dynamic> category) {
          return DropdownMenuEntry<String>(
              value: category['category'], label: category['category']);
        }).toList(),
      ),
    );
  }
}

class Complaints extends StatefulWidget {
  const Complaints({Key? key}) : super(key: key);

  @override
  _ComplaintsState createState() => _ComplaintsState();
}

class _ComplaintsState extends State<Complaints> {
  List<Map<String, dynamic>> _complaintsList = [];
  late bool _isLoading = false;
  String? lmoName;
  String? cafIds;
  String? contactNo;

  @override
  void initState() {
    super.initState();
    _fetchComplaints();
  }

  // --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

  Future<void> _fetchComplaints() async {
    const String apiUrl =
        'http://bss.apsfl.co.in/apiv1/subscriberApp/cstmr_complaint_info';

    final storage = FlutterSecureStorage();
    final String? token = await storage.read(key: 'token');
    final String? cstmr_nm = await storage.read(key: 'cstmr_nm');
    final String? cafId = await storage.read(key: 'caf_id');
    final String? mbl_nu = await storage.read(key: 'mbl_nu');

    if (token == null || cafId == null) {
      setState(() {
        _isLoading = false;
      });
      // Handle the case where token or caf_id is not available
      return;
    }

    final Map<String, String> headers = {
      'x-access-token': token,
      'Content-Type': 'application/json'
    };

    final Map<String, dynamic> requestBody = {
      "app_type": "Customer",
      "caf_id": int.parse(cafId), // Parse caf_id to int if needed
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
      print('this is complaint screen $data');
      if (data.isEmpty) {
        _showToastNotification();
      }
      setState(() {
        _complaintsList = List<Map<String, dynamic>>.from(data);
        lmoName = cstmr_nm;
        cafIds = cafId;
        contactNo = mbl_nu;
        print('this is lmo name:- $lmoName');
        print('this is cafIds:- $cafIds');
        print('this is contactNo:- $contactNo');
      });
    } else {
      throw Exception('Failed to fetch complaints');
    }
  }
  // --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

  // --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return HomePage();
                }));
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 30,
              ),
            ),
            title: const Text(
              'Complaints',
              style: TextStyle(color: Colors.white, fontFamily: 'Cera-Bold'),
            ),
            backgroundColor: Colors.blue, // Use your preferred color
            bottom: const TabBar(
              indicatorColor: Colors.white,
              tabs: [
                Tab(
                  child: Text(
                    'COMPLAINTS LIST',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Tab(
                  child: Text(
                    'ADD COMPLAINT',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              ListView.builder(
                itemCount: _complaintsList.isEmpty ? 1 : _complaintsList.length,
                itemBuilder: (context, index) {
                  if (_complaintsList.isEmpty) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.9,
                      // color: Colors.amber,
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'No history found',
                            style: TextStyle(
                              fontFamily: 'Cera-Bold',
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  final Map<String, dynamic> complaint = _complaintsList[index];
                  print(
                      'this is inside listview builder of complaintlist $complaint');
                  return ListTile(
                    // title: Text('Complaint ID: ${complaint['complaint_id']}'),
                    subtitle: Card(
                        color: Colors.white,
                        elevation: 10,
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 1,
                              height: 30,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                color: Pallete.buttonColor,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10)),
                              ),
                              child: Text(
                                '${complaint['first_name']} ${complaint['caf_nu']} ',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Cera-Bold',
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 2, left: 10, bottom: 2),
                              child: Text(
                                'Ticket No: ${complaint['comp_ticketno']}',
                                maxLines: 1,
                                style: const TextStyle(fontFamily: 'Cera-Bold'),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 2, left: 10, bottom: 2),
                              child: Text(
                                'Category: ${complaint['comp_cat_name']}',
                                maxLines: 1,
                                style: const TextStyle(fontFamily: 'Cera-Bold'),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 2, left: 10, bottom: 2),
                              child: Text(
                                'Message: ${complaint['complaint']}',
                                maxLines: 2,
                                style: const TextStyle(fontFamily: 'Cera-Bold'),
                              ),
                            ),
                            const Padding(
                              padding:
                                  EdgeInsets.only(top: 2, left: 10, bottom: 2),
                              child: Text(
                                'Status: Completed',
                                maxLines: 1,
                                style: TextStyle(fontFamily: 'Cera-Bold'),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 2, left: 10, bottom: 2),
                              child: Text(
                                'Mobile: ${complaint['cntct_mble1_nu']}',
                                maxLines: 1,
                                style: const TextStyle(fontFamily: 'Cera-Bold'),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.all(4),
                              child: Text(
                                '${complaint['created_date_time']}',
                                maxLines: 1,
                                style: const TextStyle(fontFamily: 'Cera-Bold'),
                              ),
                            )
                          ],
                        )),
                  );
                },
              ),
              // const Icon(Icons.help_center),
              Padding(
                padding: const EdgeInsets.all(4),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: Row(
                          children: [
                            Expanded(
                              flex: 0,
                              child: Container(
                                // color: Colors.amber,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: const Column(
                                  // mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Name',
                                      style: TextStyle(
                                        fontFamily: 'Cera-Bold',
                                      ),
                                    ),
                                    Text(
                                      'Mobile',
                                      style: TextStyle(
                                        fontFamily: 'Cera-Bold',
                                      ),
                                    ),
                                    Text(
                                      'CAF ID',
                                      style: TextStyle(
                                        fontFamily: 'Cera-Bold',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                // color: Colors.blue,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 40,
                                ),
                                child: const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ':',
                                      style: TextStyle(
                                        fontFamily: 'Cera-Bold',
                                      ),
                                    ),
                                    Text(
                                      ':',
                                      style: TextStyle(
                                        fontFamily: 'Cera-Bold',
                                      ),
                                    ),
                                    Text(
                                      ':',
                                      style: TextStyle(
                                        fontFamily: 'Cera-Bold',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                // color: Colors.amber,
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '$lmoName',
                                      style: const TextStyle(
                                        fontFamily: 'Cera-Bold',
                                      ),
                                    ),
                                    Text(
                                      '$cafIds',
                                      style: const TextStyle(
                                        fontFamily: 'Cera-Bold',
                                      ),
                                    ),
                                    Text(
                                      '$contactNo',
                                      style: const TextStyle(
                                        fontFamily: 'Cera-Bold',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const DropdownMenuExample(),
                        const SizedBox(
                          height: 20,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.0,
                          ),
                          child: Text(
                            'Complaint Message',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Cera-Bold',
                              fontSize: 18,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          // height: 60, // Adjust the height as needed
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                          ),
                          child: const TextField(
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.all(8.0),
                              border: OutlineInputBorder(),
                              labelText: 'Enter Message....',
                              labelStyle: TextStyle(
                                fontFamily: 'Cera-Bold',
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: 200,
                            child: ElevatedButton(
                              onPressed: () {},
                              child: Text(
                                'Submit',
                                style: const TextStyle(
                                  fontFamily: 'Cera-Bold',
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Pallete.buttonColor),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Center(
                            child: Text(
                              'For More Info Contact Us ?',
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Cera-Bold',
                                decoration: TextDecoration.underline,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

void _showToastNotification() {
  Fluttertoast.showToast(
    msg: "No History Found",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.red,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}
