import 'package:apsflsubscribes/screens/home_screen.dart';
import 'package:apsflsubscribes/utils/pallete.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PaymentHistory extends StatefulWidget {
  const PaymentHistory({Key? key}) : super(key: key);

  @override
  State<PaymentHistory> createState() => _PaymentHistoryState();
}

class _PaymentHistoryState extends State<PaymentHistory> {
  List<Map<String, dynamic>> _dataList = [];
  bool _isLoading = false;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _fetchData();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    final String apiUrl =
        'http://bss.apsfl.co.in/apiv1/subscriberApp/cstmr_paymnts_dtls';

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
      "device_name": "vivovivo+1811",
      "version_code": 26
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
        _dataList.addAll(data.cast<Map<String, dynamic>>());
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      throw Exception('Failed to fetch data');
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _fetchData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return HomePage();
            }));
          },
          icon: const Icon(
            Icons.arrow_back,
            size: 30,
          ),
          color: Colors.white,
        ),
        backgroundColor: Pallete.backgroundColor,
        title: const Text(
          'Payment History',
          style: TextStyle(color: Colors.white, fontFamily: 'Cera-Bold'),
        ),
      ),
      body: ListView.builder(
        itemCount: _dataList.length + (_isLoading ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < _dataList.length) {
            final Map<String, dynamic> item = _dataList[index];
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Date',
                            style: TextStyle(
                                fontFamily: 'Cera-Bold', fontSize: 12),
                          ),
                          Text(
                            'Amount Paid',
                            style: TextStyle(
                                fontFamily: 'Cera-Bold', fontSize: 12),
                          ),
                          Text(
                            'Payment Mode',
                            style: TextStyle(
                                fontFamily: 'Cera-Bold', fontSize: 12),
                          ),
                          Text(
                            'Status',
                            style: TextStyle(
                                fontFamily: 'Cera-Bold', fontSize: 12),
                          ),
                          Text(
                            'Channel/Package name',
                            style: TextStyle(
                                fontFamily: 'Cera-Bold', fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ': ${item['dateCreated'] ?? 'Unknown'}',
                            style: TextStyle(
                                fontFamily: 'Cera-Bold', fontSize: 12),
                          ),
                          Text(
                            ': ${item['amount'] ?? 'Unknown'}',
                            style: TextStyle(
                                fontFamily: 'Cera-Bold', fontSize: 12),
                          ),
                          Text(
                            ': ${item['type'] ?? 'Unknown'}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            softWrap: true,
                            style: TextStyle(
                                fontFamily: 'Cera-Bold', fontSize: 12),
                          ),
                          Text(
                            ': ${item['remarks'] ?? 'Unknown'}',
                            style: TextStyle(
                                fontFamily: 'Cera-Bold', fontSize: 12),
                          ),
                          Text(
                            ': ${item['packages_names'] ?? 'Unknown'}',
                            style: TextStyle(
                                fontFamily: 'Cera-Bold', fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
        controller: _scrollController,
      ),
    );
  }
}
