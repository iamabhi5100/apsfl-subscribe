import 'package:apsflsubscribes/screens/hsiusage_screen.dart';
import 'package:apsflsubscribes/screens/invoice_screen.dart';
import 'package:apsflsubscribes/screens/iptvpage/buychannels_screen.dart';
import 'package:apsflsubscribes/screens/voipusage_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return BuyChannelsScreen();
              }));
            },
            child: Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: const Color.fromARGB(255, 157, 199, 231),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.tv,
                    color: Colors.black,
                  ),
                  Text(
                    'IPTV',
                    style: TextStyle(
                      fontFamily: 'Cera-Bold',
                    ),
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return const HisUsageScreen();
              }));
            },
            child: Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: const Color.fromARGB(255, 157, 199, 231),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.wifi,
                    color: Colors.black,
                  ),
                  Text(
                    'Internet',
                    style: TextStyle(
                      fontFamily: 'Cera-Bold',
                    ),
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return const VoipUsageScreen();
              }));
            },
            child: Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: const Color.fromARGB(255, 157, 199, 231),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.phone_android,
                    color: Colors.black,
                  ),
                  Text(
                    'Telephone',
                    style: TextStyle(
                      fontFamily: 'Cera-Bold',
                    ),
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return const InvoiceScreen();
              }));
            },
            child: Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: const Color.fromARGB(255, 157, 199, 231),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.newspaper,
                    color: Colors.black,
                  ),
                  Text(
                    'Invoice',
                    style: TextStyle(
                      fontFamily: 'Cera-Bold',
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
