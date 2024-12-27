import 'package:flutter/material.dart';
import 'package:apsflsubscribes/screens/complaints_screen.dart';
import 'package:apsflsubscribes/screens/paymenthistory.dart';
import 'package:apsflsubscribes/screens/profile_screen.dart';
import 'package:apsflsubscribes/screens/homepage/categories_screen.dart';
import 'package:apsflsubscribes/screens/homepage/dashboard_screen.dart';
import 'package:apsflsubscribes/screens/homepage/horizontaltextanimation_screen.dart';
import 'package:apsflsubscribes/screens/homepage/myplans_screen.dart';
import 'package:apsflsubscribes/screens/homepage/plandetail_screen.dart';
import 'package:apsflsubscribes/screens/navigationpage/drawernavigation_screen.dart';
import 'package:apsflsubscribes/screens/notifications_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async'; // Import dart:async for Timer

class HomePageController {
  var selectedIndex = 0;

  void selectIndex(int index) {
    selectedIndex = index;
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final HomePageController homePageController = HomePageController();

  late Future<void> _fetchDataFuture;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _fetchData();
    print('MyplanScreen initState');
    _animationController = AnimationController(vsync: this);
    _fetchDataFuture = _cust_info(); // Assign the future to _fetchDataFuture
  }

// *********************************************************************** subscriberApploginDtls ***********************************************************
  // Define variables to store API data
  late bool _isLoading = false;
  String firstName = ''; // Initialize firstName with an empty string
  int? cafId;
  int? contactNo;
  String? sbscrId;
  String? lmoName;
  String? lmoCd;
  int? lmoMobile;
  int? crnt_pln_id;

  int _fetchDataError = 0;
  int _cust_infoError = 0;

  void _storeCurrentPlanId(String crnt_pln_id) async {
    final storage = FlutterSecureStorage();
    await storage.write(key: 'current_plan_id', value: crnt_pln_id);
    // print('this is secure storage outside $crnt_pln_id');
  }

  Future<void> _fetchData() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    const apiUrl = 'http://bss.apsfl.co.in/apiv1/subscriberApploginDtls';

    final storage = FlutterSecureStorage();
    final String? cafId = await storage.read(key: 'caf_id');
    final String? token = await storage.read(key: 'token');

    if (token == null || cafId == null) {
      setState(() {
        _isLoading = false;
      });
      // Handle the case where token or caf_id is not available
      return;
    }

    final Map<String, String> headers = {
      'x-access-token': token,
      'Content-Type': 'application/json'
    };

    final Map<String, dynamic> requestBody = {
      "app_type": "Customer",
      "caf_id": int.parse(cafId), // Parse caf_id to int if needed
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
      final List<dynamic> userData = responseData['data'];

      if (userData.isNotEmpty) {
        final Map<String, dynamic> userInfo = userData[0];

        setState(() {
          _isLoading = false;
          firstName = userInfo['cstmr_nm'].toString();
          this.cafId = userInfo['caf_id'];
          contactNo = userInfo['mbl_nu'];
          sbscrId = userInfo['mdlwe_sbscr_id'].toString();
          lmoName = userInfo['lmo_name'].toString();
          lmoCd = userInfo['lmo_cd'].toString();
          lmoMobile = userInfo['lmo_mobile'];
          crnt_pln_id = userInfo['crnt_pln_id'];

          print('current plan: $crnt_pln_id');
          // Store crnt_pln_id using flutter_secure_storage
          _storeCurrentPlanId(crnt_pln_id.toString());
          print('this is secure storage inside $crnt_pln_id');
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        throw Exception('No data available');
      }
    } else {
      setState(() {
        _isLoading = false;
        _fetchDataError = 1;
      });
      // throw Exception('Failed to fetch data');
    }
  }
// *********************************************************************** subscriberApploginDtls ***********************************************************

// *********************************************************************** cstmr_packages ***********************************************************

  final _storage = const FlutterSecureStorage();

  List<Map<String, dynamic>> custInfoData = [];
  double _progress = 0;
  int totalData = 0;
  int usedData = 0;
  String? upNetSpeed;
  String? downNetSpeed;
  String? basePackage;

  List<dynamic> dataList = [];
  // bool _isLoading = false;
  String? endDate;

  Future<void> _cust_info() async {
    const String apiUrl =
        'http://bss.apsfl.co.in/apiv1/subscriberApp/cust_info';

    final storage = FlutterSecureStorage();
    final String? token = await storage.read(key: 'token');
    final String? cafId = await storage.read(key: 'caf_id');

    if (token == null || cafId == null) {
      setState(() {
        _isLoading = false;
      });
      // Handle the case where token or caf_id is not available
      return;
    }

    final Map<String, String> headers = {
      'x-access-token': token,
      'Content-Type': 'application/json'
    };

    final Map<String, dynamic> requestBody = {
      "app_type": "Customer",
      "caf_id": int.parse(cafId),
      "device_id": "OPM1.171019.026",
      "device_type": "vivovivo+1811"
    };

    final http.Response response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: json.encode(requestBody),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final Map<String, dynamic> data = responseData['data'] ?? {};
      final List<dynamic> userInfo = data['user_info'] ?? [];

      if (userInfo.isNotEmpty) {
        final String cycleEndDt = userInfo[0]['cycle_end_dt'].toString();
        final String netspeed = userInfo[0]['hsi_crnt_prfle_tx'].toString();
        final String package = userInfo[0]['pckge_nm'].toString();
        final List<String> parts = netspeed.split('_UP_');
        final String upload = parts[0];
        final String download = parts[1].replaceAll('_DOWN', '');

        final int totalDatas = (data['limit'] ?? 0).toInt();
        final int usedDatas = (data['total'] ?? 0).toInt();

        final double progress = (usedDatas / totalDatas) * 100;

        setState(() {
          // print('this is total data :- $totalDatas');
          // print('this is usedData data :- $usedDatas');
          // print('this is upNetSpeed  :- $upload');
          // print('this is downNetSpeed  :- $download');

          // Store fetched data
          _progress = progress;
          totalData = totalDatas;
          usedData = usedDatas;
          upNetSpeed = upload;
          downNetSpeed = download;
          basePackage = package;
          endDate = cycleEndDt;
          // print('this is endDate $endDate');
        });
      } else {
        throw Exception('User info not found');
      }
    } else {
      setState(() {
        _isLoading = false;
        _fetchDataError = 1;
      });
      // throw Exception('Failed to fetch data');
    }
  }

// *********************************************************************** cstmr_packages ***********************************************************

  // Add this method to handle showing toast notification if server is down
  void _checkServerStatus() {
    if (_fetchDataError == 1) {
      // Start a timer to show toast notification after 1 minute
      Timer(Duration(minutes: 1), () {
        if (_isLoading) {
          // Show toast notification if still loading after 1 minute
          _showToastNotification();
          // Close the app
          Future.delayed(Duration(seconds: 2), () {
            // Give some time to display the toast notification
            Navigator.of(context).pop(); // Close the app
          });
        }
      });
    }
  }

  void _showToastNotification() {
    Fluttertoast.showToast(
      msg: "Server Down",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    // print('Building HomePage...');
    // Call _checkServerStatus method to show toast notification if server is down
    _checkServerStatus();
    // Use FutureBuilder to build the widget tree based on the result of _fetchDataFuture
    // print('this is end date data $endDate');
    return FutureBuilder(
      future: _fetchDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Display a loading indicator while waiting for the future to complete
          return Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 1,
              height: MediaQuery.of(context).size.height * 1,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                // borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Material(
                    elevation: 8,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.08,
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                        // border: Border.all(width: 1),
                        borderRadius: BorderRadius.all(
                          Radius.circular(30),
                        ),
                      ),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color.fromARGB(255, 204, 85, 45)),
                          ),
                          SizedBox(width: 10),
                          DefaultTextStyle(
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            child: Text(
                              'Loading',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (snapshot.hasError) {
          // Handle errors if the future fails
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          // Once the future completes successfully, build the main UI
          return Scaffold(
            appBar: AppBar(
              actions: [
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Image.asset(
                      'assets/images/apsfllogoblack.png',
                      height: 180,
                      width: 180,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Notifications()),
                    );
                  },
                  icon: const Icon(
                    Icons.notifications,
                    size: 30,
                  ),
                ),
              ],
              iconTheme: const IconThemeData(
                size: 30,
                color: Color.fromARGB(255, 204, 85, 45),
              ),
            ),
            drawer: const DrawerNavigationScreen(),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              selectedLabelStyle: const TextStyle(
                fontFamily: 'Cera-Bold',
              ),
              unselectedLabelStyle:
                  const TextStyle(fontFamily: 'Cera-Bold', fontSize: 13),
              backgroundColor: Colors.white,
              selectedItemColor: const Color.fromARGB(255, 204, 85, 45),
              unselectedItemColor: Colors.black,
              currentIndex: homePageController.selectedIndex,
              onTap: (index) {
                homePageController.selectIndex(index);
                switch (index) {
                  case 1:
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Complaints()),
                    );
                    break;
                  case 2:
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PaymentHistory()),
                    );
                    break;
                  case 3:
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProfileScreen()),
                    );
                    break;
                }
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                    color: Color.fromARGB(255, 93, 91, 91),
                    size: 30,
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.support_agent,
                    color: Color.fromARGB(255, 93, 91, 91),
                    size: 30,
                  ),
                  label: 'Support',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.description,
                    color: Color.fromARGB(255, 93, 91, 91),
                    size: 30,
                  ),
                  label: 'Bill Details',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.person,
                    color: Color.fromARGB(255, 93, 91, 91),
                    size: 30,
                  ),
                  label: 'Profile',
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const HorizontalTextAnimation(),
                  DashboardScreen(
                    firstName: firstName,
                    cafId: cafId,
                    contactNo: contactNo,
                    sbscrId: sbscrId,
                    lmoName: lmoName,
                    lmoCd: lmoCd,
                    lmoMobile: lmoMobile,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  PlanDetailScreen(
                    endDate: endDate,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  MyplanScreen(
                    totalData: totalData,
                    usedData: usedData,
                    upNetSpeed: upNetSpeed,
                    downNetSpeed: downNetSpeed,
                    basePackage: basePackage,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Material(
                    elevation: 20,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      color: Colors.white70,
                      child: const CategoriesScreen(),
                    ),
                  ),
                  // SliderCard(), // Uncomment this if needed
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
