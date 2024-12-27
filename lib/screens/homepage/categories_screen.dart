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
                  SizedBox(
                    height: 35,
                    width: 35,
                    child: Image(
                      image: AssetImage('assets/images/iptv.png'),
                    ),
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
          SizedBox(
            width: 10,
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
                  SizedBox(
                    height: 35,
                    width: 35,
                    child: Image(
                      image: AssetImage('assets/images/internet.png'),
                    ),
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
          SizedBox(
            width: 10,
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
                  SizedBox(
                    height: 35,
                    width: 35,
                    child: Image(
                      image: AssetImage('assets/images/telephone.png'),
                    ),
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
          SizedBox(
            width: 10,
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
                  SizedBox(
                    height: 35,
                    width: 35,
                    child: Image(
                      image: AssetImage('assets/images/invoice.png'),
                    ),
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
