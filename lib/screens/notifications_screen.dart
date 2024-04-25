import 'package:apsflsubscribes/screens/home_screen.dart';
import 'package:apsflsubscribes/utils/pallete.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
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

    const apiUrl =
        'http://bssuat.apsfl.co.in/apiv1/subscriberApp/cstmr_notification_list';

    final Map<String, String> headers = {
      'x-access-token':
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyIwIjp7ImNhZl9pZCI6MjAwMTIzNzE3LCJreWMiOiJObyIsIm1ibF9udSI6Nzk4OTkyNTc2MSwiY3N0bXJfbm0iOiJzaXZlIGt1bWFyIn0sImFwcCI6bnVsbCwiaWF0IjoxNzEyMDU0MDM0fQ.9g3TYEcbZEPlktcOr7VTFj47kNVo5eYOmDD4UgdtBFM',
      'Content-Type': 'application/json'
    };

    final Map<String, dynamic> requestBody = {
      "app_type": "Customer",
      "caf_id": "200123717",
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
        backgroundColor: Pallete.backgroundColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return HomePage();
            }));
          },
        ),
        title: const Text(
          'Notification',
          style: TextStyle(
            fontFamily: 'Cera-Bold',
            color: Colors.white,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: _dataList.length + (_isLoading ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < _dataList.length) {
            final Map<String, dynamic> item = _dataList[index];
            return ListTile(
              title: Column(
                children: [
                  Card(
                    color: Colors.white,
                    elevation: 6,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '${item['category'] ?? 'Unknown'}',
                              style: const TextStyle(
                                fontFamily: 'Cera-Bold',
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '${item['message'] ?? 'Unknown'}',
                              style: const TextStyle(
                                fontFamily: 'Cera-Medium',
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              '${item['dateCreated'] ?? 'Unknown'}',
                              style: const TextStyle(
                                fontFamily: 'Cera-Medium',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
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
