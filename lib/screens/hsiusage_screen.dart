import 'package:apsflsubscribes/screens/home_screen.dart';
import 'package:apsflsubscribes/utils/pallete.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const List<String> list = <String>['2024', '2023', '2022', '2021'];

class HisUsageScreen extends StatefulWidget {
  const HisUsageScreen({Key? key}) : super(key: key);

  @override
  State<HisUsageScreen> createState() => _HisUsageScreenState();
}

class _HisUsageScreenState extends State<HisUsageScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  bool isLoading = true;
  List<dynamic> userData = [];
  String selectedYear = list.first;

  @override
  void initState() {
    super.initState();
    fetchDataDtls(selectedYear);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300), // Adjust duration as needed
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> fetchDataDtls(String year) async {
    setState(() {
      isLoading = true;
    });

    String apiUrlCust =
        'http://bssuat.apsfl.co.in/apiv1/subscriberApp/hsi/200123717/$year';

    final Map<String, String> headers = {
      'x-access-token':
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyIwIjp7ImNhZl9pZCI6MjAwMTIzNzE3LCJreWMiOiJObyIsIm1ibF9udSI6Nzk4OTkyNTc2MSwiY3N0bXJfbm0iOiJzaXZlIGt1bWFyIn0sImFwcCI6bnVsbCwiaWF0IjoxNzEyMjI2ODAwfQ.1U60JZyvV75MvXvBU92epFptKO9Ehq8EMbmxUV60V80',
      'Content-Type': 'application/json'
    };

    try {
      final http.Response response = await http.get(
        Uri.parse(apiUrlCust),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          userData = data['data'];
          isLoading = false;
        });
      } else {
        print('HTTP request failed with status: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      print('Error fetching user data: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(7, 24, 147, 1),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return HomePage();
            }));
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: const Text(
          'Hsi Usage',
          style: TextStyle(color: Colors.white, fontFamily: "Cera-Bold"),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        DropdownMenuExample(
                          initialValue: selectedYear,
                          onYearSelected: (year) {
                            setState(() {
                              selectedYear = year;
                            });
                          },
                        ),
                        Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width * 0.2,
                          margin: const EdgeInsets.only(left: 10),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 243, 75, 33),
                            ),
                            onPressed: () {
                              fetchDataDtls(selectedYear);
                            },
                            child: const Text(
                              'OK',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Cera-Bold',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    ListView.builder(
                      itemCount: userData.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final Map<String, dynamic> monthData = userData[index];
                        final List<dynamic> eachDayData = monthData['eachday'];
                        return Column(
                          children: [
                            Card(
                              elevation: 4,
                              // Apply animation to Expansion Tile
                              child: ExpansionTile(
                                shape: Border(),
                                title: AnimatedBuilder(
                                  animation: _animationController,
                                  builder: (context, child) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Month: ${monthData['mnt_ct']}',
                                          style: const TextStyle(
                                            fontFamily: 'Cera-Bold',
                                          ),
                                        ),
                                        Text(
                                          'Total Download: ${monthData['TD']}',
                                          style: const TextStyle(
                                            fontFamily: 'Cera-Bold',
                                          ),
                                        ),
                                        Text(
                                          'Total Upload: ${monthData['TU']}',
                                          style: const TextStyle(
                                            fontFamily: 'Cera-Bold',
                                          ),
                                        ),
                                        Text(
                                          'Total Usage: ${monthData['total']}',
                                          style: const TextStyle(
                                            fontFamily: 'Cera-Bold',
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                                children: eachDayData.map<Widget>((dayData) {
                                  return Column(
                                    children: _renderDayDetails(dayData),
                                  );
                                }).toList(),
                                onExpansionChanged: (expanded) {
                                  if (expanded) {
                                    _animationController.forward();
                                  } else {
                                    _animationController.reverse();
                                  }
                                },
                              ),
                            )
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  List<Widget> _renderDayDetails(Map<String, dynamic> dayData) {
    final groupedDetails = _groupDayDetails(dayData);

    return groupedDetails.entries.map((entry) {
      final commonKey = entry.key;
      final details = entry.value;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            SizedBox(
              // color: Colors.amber,
              width: MediaQuery.of(context).size.width * 0.28,
              child: Column(
                children: [
                  Text(
                    'Day - ${commonKey.split('_')[1]}',
                    style: const TextStyle(
                      fontFamily: 'Cera-Bold',
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              // color: Colors.blueGrey,
              width: MediaQuery.of(context).size.width * 0.3,
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.sta,
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          'assets/images/hsi.png',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              // color: Colors.greenAccent,
              width: MediaQuery.of(context).size.width * 0.3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: details.map((detail) {
                  final key = detail['key'];
                  final value = detail['value'];

                  return Text(
                    '$key: $value',
                    style: const TextStyle(
                      fontFamily: 'Cera-Bold',
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  Map<String, List<Map<String, dynamic>>> _groupDayDetails(
      Map<String, dynamic> dayData) {
    final groupedDetails = <String, List<Map<String, dynamic>>>{};

    dayData.forEach((key, value) {
      if (key.startsWith('day_')) {
        final dayNumber = key.split('_')[1];
        final String renamedKey = key.endsWith("_TD") ? 'Download' : 'Upload';

        final commonKey = 'day_$dayNumber';
        final detail = {'key': renamedKey, 'value': value};

        if (groupedDetails.containsKey(commonKey)) {
          groupedDetails[commonKey]!.add(detail);
        } else {
          groupedDetails[commonKey] = [detail];
        }
      }
    });

    return groupedDetails;
  }
}

class DropdownMenuExample extends StatefulWidget {
  final String initialValue;
  final ValueChanged<String> onYearSelected;

  const DropdownMenuExample({
    Key? key,
    required this.initialValue,
    required this.onYearSelected,
  }) : super(key: key);

  @override
  State<DropdownMenuExample> createState() => _DropdownMenuExampleState();
}

class _DropdownMenuExampleState extends State<DropdownMenuExample> {
  late String dropdownValue;

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.68,
      margin: const EdgeInsets.all(6),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        border: Border.all(
          width: 2,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(40),
        ),
      ),
      child: DropdownButton<String>(
        // iconDisabledCoslor: Colors.white,
        iconEnabledColor: Pallete.buttonColor,
        iconDisabledColor: Pallete.buttonColor,
        value: dropdownValue,
        underline: Container(), // Set underline to an empty container
        icon: Container(
          width: MediaQuery.of(context).size.width * 0.55,
          alignment: Alignment.centerRight,
          // color: Colors.amber,
          child: const Icon(
            Icons.arrow_drop_down,
            size: 40,
          ),
        ),
        onChanged: (String? newValue) {
          setState(() {
            dropdownValue = newValue!;
            widget.onYearSelected(newValue);
          });
        },
        items: list.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(value),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
