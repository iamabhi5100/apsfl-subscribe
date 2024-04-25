import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HorizontalTextAnimation extends StatefulWidget {
  const HorizontalTextAnimation({Key? key}) : super(key: key);

  @override
  State<HorizontalTextAnimation> createState() =>
      _HorizontalTextAnimationState();
}

class _HorizontalTextAnimationState extends State<HorizontalTextAnimation> {
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

    const apiUrl = 'http://bss.apsfl.co.in/apiv1/subscriberApp/cust_info';

    final Map<String, String> headers = {
      'x-access-token':
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IjEifQ.eyIwIjp7ImNhZl9pZCI6MjAwMTIzNzE3LCJreWMiOiJObyIsIm1ibF9udSI6NzY3NTgzMTAxMSwiY3N0bXJfbm0iOiJzaXZlIGt1bWFyIn0sImFwcCI6IiIsImlhdCI6MTcxMjgzMzIyMywiZXhwIjoxNzEyODQ0MDIzLCJhdWQiOiJodHRwOi8vZHJlYW1zdGVwLmNvbSIsImlzcyI6IkRyZWFtc3RlcCIsInN1YiI6InVuZGVmaW5lZF91c2VyIiwianRpIjoiMSJ9.rfCl6BVRkjg-qLgtGA55lvdCS7tETbQHC3A1fEwnRHo',
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
      final List<dynamic> data = responseData['data'];

      if (data.isNotEmpty) {
        final Map<String, dynamic> userInfo = data[0];
        final String cycleEndDt = userInfo['app_scrolling_text'] ?? '';
        print(cycleEndDt);

        setState(() {
          _isLoading = false;
          endDate = cycleEndDt;
        });
      } else {
        setState(() {
          _isLoading = false;
          endDate = ''; // or any default value you prefer
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      throw Exception('Failed to fetch data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30, // Adjust the height as needed
      child: Marquee(
        text: 'Welcome To AP Fiber Network(APSFL) ...  ',
        style: TextStyle(fontFamily: 'Cera-Bold'),
        scrollAxis: Axis.horizontal,
        crossAxisAlignment: CrossAxisAlignment.center,
        blankSpace: 20.0,
        velocity: 50.0,
        pauseAfterRound: Duration(seconds: 1),
        startPadding: 10.0,
        accelerationDuration: Duration(seconds: 1),
        accelerationCurve: Curves.linear,
        decelerationDuration: Duration(milliseconds: 500),
        decelerationCurve: Curves.easeOut,
      ),
    );
  }
}
