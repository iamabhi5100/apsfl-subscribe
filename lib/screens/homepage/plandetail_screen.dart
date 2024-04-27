import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PlanDetailScreen extends StatefulWidget {
  String? endDate;
  PlanDetailScreen({super.key, required this.endDate});

  @override
  State<PlanDetailScreen> createState() => _PlanDetailScreenState();
}

class _PlanDetailScreenState extends State<PlanDetailScreen> {
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
              'Exp Date: ${widget.endDate}',
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
