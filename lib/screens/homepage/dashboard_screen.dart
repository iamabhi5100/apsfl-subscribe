import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DashboardScreen extends StatelessWidget {
  // Define variables to receive data from parent
  final String firstName;
  final int? cafId;
  final int? contactNo;
  final String? sbscrId;
  final String? lmoName;
  final String? lmoCd;
  final int? lmoMobile;
  const DashboardScreen({
    Key? key,
    required this.firstName,
    required this.cafId,
    required this.contactNo,
    required this.sbscrId,
    required this.lmoName,
    required this.lmoCd,
    required this.lmoMobile,
  });

  // Future<void> _fetchData() async {
  @override
  Widget build(BuildContext context) {
    // print('first Name from child component: $firstName');
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Colors.white,
        elevation: 8,
        child: Container(
          height: 100,
          margin: const EdgeInsets.all(10),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 4),
                        child: Text(
                          'Customer Details',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Cera-Medium',
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(
                              left: 4,
                              right: 20,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Name',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Cera-Medium',
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  'CAF ID',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Cera-Medium',
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  'Mobile',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Cera-Medium',
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  'Sbscr ID',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Cera-Medium',
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(
                              left: 4,
                              right: 20,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ':',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Cera-Medium',
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  ':',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Cera-Medium',
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  ':',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Cera-Medium',
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  ':',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Cera-Medium',
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$firstName',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Cera-Medium',
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                '$cafId',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Cera-Medium',
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                '$contactNo',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Cera-Medium',
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                '$sbscrId',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Cera-Medium',
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 60, bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'LMO Details',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Cera-Medium',
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          '$lmoName',
                          style: const TextStyle(
                            fontSize: 12,
                            fontFamily: 'Cera-Medium',
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          '$lmoCd',
                          style: const TextStyle(
                            fontSize: 12,
                            fontFamily: 'Cera-Medium',
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          '$lmoMobile',
                          style: const TextStyle(
                            fontSize: 12,
                            fontFamily: 'Cera-Medium',
                            color: Colors.black,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
