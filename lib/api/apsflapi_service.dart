import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiRequestWidget extends StatefulWidget {
  @override
  _ApiRequestWidgetState createState() => _ApiRequestWidgetState();
}

class _ApiRequestWidgetState extends State<ApiRequestWidget> {
  List<dynamic> _data = [];

  Future<void> _fetchData() async {
    final String apiUrl =
        'http://bssuat.apsfl.co.in/apiv1/subscriberApp/cstmr_paymnts_dtls';

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
      setState(() {
        _data = responseData['data'];
      });
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
            onPressed: () {
              _fetchData();
            },
            child: const Text('Fetch Data'),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: _data.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_data[index]['amount']),
                  subtitle: Text(_data[index]['packages_names']),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
