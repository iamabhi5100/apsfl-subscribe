import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PlanDetailScreen extends StatefulWidget {
  const PlanDetailScreen({super.key});

  @override
  State<PlanDetailScreen> createState() => _PlanDetailScreenState();
}

class _PlanDetailScreenState extends State<PlanDetailScreen> {
  List<dynamic> dataList = [];
  bool _isLoading = false;
  String? endDate;

  @override
  void initState() {
    super.initState();

    _fetchData();
  }

  Future<void> _fetchData() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    const apiUrl = 'http://bssuat.apsfl.co.in/apiv1/subscriberApp/cust_info';

    final Map<String, String> headers = {
      'x-access-token':
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyIwIjp7ImNhZl9pZCI6MjAwMTIzNzE3LCJreWMiOiJObyIsIm1ibF9udSI6NzY3NTgzMTAxMSwiY3N0bXJfbm0iOiJzaXZlIGt1bWFyIn0sImFwcCI6bnVsbCwiaWF0IjoxNzEyODEzMTIyfQ.QxTL9la6JseySoMwvP00TwHP0573XLzk_Y4qDqQ4KEY',
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
      final List<dynamic> userInfo = responseData['data']['user_info'];

      final String cycleEndDt =
          userInfo.isNotEmpty ? userInfo[0]['cycle_end_dt'].toString() : '';

      setState(() {
        _isLoading = false;
        // datas = data.toString();
        endDate = cycleEndDt;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      throw Exception('Failed to fetch data');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      color: const Color.fromARGB(255, 9, 103, 211),
      height: 60,
      width: screenWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 15),
            child: Text(
              'Plain Detail',
              style: TextStyle(
                fontFamily: 'Cera-Bold',
                color: Colors.white,
                // backgroundColor: Colors.amber,
                fontSize: 15,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Text(
              'Exp Date: $endDate',
              style: const TextStyle(
                fontFamily: 'Cera-Bold',
                color: Colors.white,
                // backgroundColor: Colors.amber,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
