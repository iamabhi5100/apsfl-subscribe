import 'package:apsflsubscribes/screens/aboutus_screen.dart';
import 'package:apsflsubscribes/screens/complaints_screen.dart';
import 'package:apsflsubscribes/screens/helpandsupport_screen.dart';
import 'package:apsflsubscribes/screens/home_screen.dart';
import 'package:apsflsubscribes/screens/loginscreen.dart';
import 'package:apsflsubscribes/screens/paymenthistory.dart';
import 'package:apsflsubscribes/screens/transactionhistory_screen.dart';
import 'package:apsflsubscribes/utils/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DrawerNavigationScreen extends StatefulWidget {
  const DrawerNavigationScreen({super.key});

  @override
  State<DrawerNavigationScreen> createState() => _DrawerNavigationScreenState();
}

class _DrawerNavigationScreenState extends State<DrawerNavigationScreen> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const UserAccountsDrawerHeader(
            accountName: null,
            accountEmail: null,
            decoration: BoxDecoration(
              color: Pallete.backgroundColor,
              image: DecorationImage(
                image: AssetImage('assets/images/navlogo.png'),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.home,
              size: 30,
              color: Colors.black,
            ),
            title: const Text(
              'Home',
              style: TextStyle(fontFamily: 'Cera-Bold', fontSize: 15),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return HomePage();
              }));
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.support_agent,
              size: 30,
              color: Colors.black,
            ),
            title: const Text(
              'Complaint',
              style: TextStyle(fontFamily: 'Cera-Bold', fontSize: 15),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return const Complaints();
              }));
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.wallet,
              size: 30,
              color: Colors.black,
            ),
            title: const Text(
              'Bill Details',
              style: TextStyle(fontFamily: 'Cera-Bold', fontSize: 15),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return const PaymentHistory();
              }));
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.list,
              size: 30,
              color: Colors.black,
            ),
            title: const Text(
              'Transaction',
              style: TextStyle(fontFamily: 'Cera-Bold', fontSize: 15),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return const TransactionHistory();
              }));
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.help_center,
              size: 30,
              color: Colors.black,
            ),
            title: const Text(
              'Help And Support',
              style: TextStyle(fontFamily: 'Cera-Bold', fontSize: 15),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return const HelpAndSupportScreen();
              }));
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.info,
              size: 30,
              color: Colors.black,
            ),
            title: const Text(
              'About Us',
              style: TextStyle(fontFamily: 'Cera-Bold', fontSize: 15),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return const AboutUsScreen();
              }));
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.logout,
              size: 30,
              color: Colors.black,
            ),
            title: const Text(
              'Logout',
              style: TextStyle(fontFamily: 'Cera-Bold', fontSize: 15),
            ),
            onTap: () async {
              final _storage = FlutterSecureStorage();
              await _storage.delete(key: 'token'); // Remove token from storage
              Navigator.of(context)
                  .pushReplacement(MaterialPageRoute(builder: (context) {
                return LoginScreen();
              }));
            },
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(width: 1),
              ),
            ),
            padding: EdgeInsets.only(top: 10),
            child: Row(
              children: [
                Container(
                  width: 240,
                  // alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(left: 18),
                  child: Text(
                    'Version',
                    style: TextStyle(
                      fontFamily: 'Cera-Bold',
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '3.7',
                    style: TextStyle(
                      fontFamily: 'Cera-Bold',
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
