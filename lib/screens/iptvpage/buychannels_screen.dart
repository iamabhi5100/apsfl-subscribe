import 'package:apsflsubscribes/screens/home_screen.dart';
import 'package:apsflsubscribes/screens/iptvpage/selectedchannels_screen.dart';
import 'package:apsflsubscribes/utils/pallete.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BuyChannelsScreen extends StatefulWidget {
  const BuyChannelsScreen({Key? key}) : super(key: key);

  @override
  State<BuyChannelsScreen> createState() => _BuyChannelsScreenState();
}

class _BuyChannelsScreenState extends State<BuyChannelsScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  final TextEditingController _searchControllerAlacate =
      TextEditingController();
  final TextEditingController _searchControllerFirstShow =
      TextEditingController();

  List<Map<String, dynamic>> _filteredDataAlacarte = [];
  List<Map<String, dynamic>> _filteredDataFirstShow = [];

  bool _showFab = true; // Track FloatingActionButton visibility

  List<Map<String, dynamic>> _dataAlacarte = [];
  List<Map<String, dynamic>> _dataHsi = [];
  List<Map<String, dynamic>> _dataFirstShow = [];
  List<Map<String, dynamic>> _dataExistingPckge = [];

  List<bool> _isCheckedList3 = [];
  bool _isLoading = false;
  ScrollController _scrollController = ScrollController();

  List<Map<String, dynamic>> _cartItems = [];

  late int currentPlanId; // Declare a variable to store the current plan ID

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _fetchData();
    _tabController = TabController(length: 3, vsync: this);
    // Initialize currentPlanId with a default value
    currentPlanId = -1;

    // Call _fetchCurrentPlanId() to get the current plan ID
    _fetchCurrentPlanId();

    _filteredDataAlacarte = _dataAlacarte; // Initialize with all items
    _searchControllerAlacate.addListener(
        _filterItemsAlacate); // Listen for changes in the search bar
    _searchControllerFirstShow.addListener(
        _filterItemsFirstShow); // Listen for changes in the search bar
    _filteredDataFirstShow = _dataFirstShow;
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _filterItemsAlacate() {
    final searchText = _searchControllerAlacate.text.toLowerCase();
    setState(() {
      _filteredDataAlacarte = _dataAlacarte.where((package) {
        final packageName = package['package_name'].toString().toLowerCase();
        return packageName.contains(searchText);
      }).toList();
    });
  }

  void _filterItemsFirstShow() {
    final searchText = _searchControllerFirstShow.text.toLowerCase();
    setState(() {
      _filteredDataFirstShow = _dataFirstShow.where((package) {
        final packageName = package['package_name'].toString().toLowerCase();
        return packageName.contains(searchText);
      }).toList();
    });
  }

  Future<void> _fetchCurrentPlanId() async {
    final storage = FlutterSecureStorage();
    final storedPlanId = await storage.read(key: 'current_plan_id');
    print('this is currentPlanId before $currentPlanId');
    setState(() {
      currentPlanId = int.tryParse(storedPlanId ?? '') ?? 0;
      print('this is currentPlanId after $currentPlanId');
    });
  }

  Future<void> _fetchData() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    const apiUrl = 'http://bss.apsfl.co.in/apiv1/subscriberApp/cstmr_packages';

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
      final List<dynamic> Alacartedata =
          responseData['data']['ala_carte'] ?? [];
      final List<dynamic> Hsidata =
          responseData['data']['broadcaster_packs'] ?? [];
      final List<dynamic> FirstShowdata =
          responseData['data']['vod_packs'] ?? [];
      final List<dynamic> ExistingPackages =
          responseData['data']['existngpckgsdtls'] ?? [];

      print('this is first showdata $FirstShowdata ');
      setState(() {
        _dataAlacarte.addAll(Alacartedata.cast<Map<String, dynamic>>());
        _dataHsi.addAll(Hsidata.cast<Map<String, dynamic>>());
        _dataFirstShow.addAll(FirstShowdata.cast<Map<String, dynamic>>());
        _dataExistingPckge
            .addAll(ExistingPackages.cast<Map<String, dynamic>>());

        _isCheckedList3 =
            List<bool>.filled(_dataExistingPckge.length, false, growable: true);
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      throw Exception('Failed to fetch data');
    }
  }

  void _onScroll() {
    // if (_scrollController.position.pixels ==
    //     _scrollController.position.maxScrollExtent) {
    //   _fetchData();
    // }
    // Check if the scroll position is changing
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      // User is scrolling down, hide the FloatingActionButton
      setState(() {
        _showFab = false;
      });
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      // User is scrolling up, show the FloatingActionButton
      setState(() {
        _showFab = true;
      });
    }
  }

  void _addToCart(Map<String, dynamic> item) {
    setState(() {
      _cartItems.add(item);
      print('this is add button $_cartItems');
    });
  }

  void _removeFromCart(int packageId) {
    setState(() {
      _cartItems.removeWhere((item) => item['package_id'] == packageId);
      print('this is remove button $_cartItems');
    });
  }

  double _calculateTotalPrice() {
    double totalPrice = 0.0;
    for (var item in _cartItems) {
      totalPrice += item['ttl_cst'] ?? 0.0;
    }
    return totalPrice;
  }

  int selectedPackageId = -1; // Initialize with an invalid package ID

  void _showToastNotification() {
    Fluttertoast.showToast(
      msg: "Please Select At least One Channel",
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Pallete.backgroundColor,
        title: const Text(
          'Buy Channels',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Cera-Bold',
            // fontSize: 14,
          ),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return HomePage();
              }));
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 30,
            )),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Pallete.buttonColor,
          unselectedLabelStyle: const TextStyle(
            color: Colors.white,
            fontFamily: 'Cera-Bold',
            fontSize: 18,
          ),
          labelStyle: const TextStyle(
            color: Colors.white,
            fontFamily: 'Cera-Bold',
            fontSize: 18,
          ),
          tabs: const <Widget>[
            Tab(
              text: 'Alcarte',
            ),
            Tab(
              text: 'HSI',
            ),
            Tab(
              text: 'First Show',
            ),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        width: 220,
        child: AnimatedOpacity(
          opacity: _showFab ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 200),
          child: FloatingActionButton(
            onPressed: () {
              // Show the full-screen modal
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (BuildContext context) {
                  return StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return Center(
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          height: MediaQuery.of(context).size.width * 1.5,
                          // width: MediaQuery.of(context).size.width * 1,

                          margin: const EdgeInsets.all(30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  color: Pallete.backgroundColor,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10)),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 80),
                                      child: Text(
                                        'Subscribed Info',
                                        style: TextStyle(
                                          fontFamily: 'Cera-Bold',
                                          fontSize: 18,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      icon: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: _dataExistingPckge.length,
                                  itemBuilder: (context, index) {
                                    final package = _dataExistingPckge[index];
                                    final bool isChecked =
                                        _isCheckedList3[index];
                                    final int packageId = package['package_id'];

                                    // Check if the package ID is 3000107 or 3000106
                                    final bool showCheckbox =
                                        packageId != 3000107 &&
                                            packageId != 3000106;

                                    return Card(
                                      elevation: 8,
                                      child: ListTile(
                                        title: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Package Name: ${package['package_name']}',
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontFamily: 'Cera-Bold',
                                                fontSize: 13,
                                              ),
                                            ),
                                            Text(
                                              'Price: ${package['ttl_cst9']}', // Display the price
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontFamily: 'Cera-Bold',
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ),
                                        trailing: showCheckbox
                                            ? Checkbox(
                                                value: isChecked,
                                                side: const BorderSide(
                                                    color: Colors.black),
                                                checkColor: Colors.white,
                                                onChanged: (value) {
                                                  setState(() {
                                                    if (value!) {
                                                      final dynamic ttlCst =
                                                          package['ttl_cst9'];
                                                      final double totalPrice = ttlCst
                                                              is num
                                                          ? ttlCst.toDouble()
                                                          : double.tryParse(ttlCst
                                                                  .toString()
                                                                  .replaceAll(
                                                                      ',',
                                                                      '')) ??
                                                              0.0;
                                                      final Map<String, dynamic>
                                                          itemToAdd =
                                                          Map.from(package);
                                                      itemToAdd['ttl_cst'] =
                                                          totalPrice;
                                                      final bool itemExists =
                                                          _cartItems.any((item) =>
                                                              item[
                                                                  'package_id'] ==
                                                              packageId);
                                                      if (!itemExists) {
                                                        _addToCart(itemToAdd);
                                                      }
                                                    } else {
                                                      _removeFromCart(
                                                          packageId);
                                                    }
                                                    _isCheckedList3[index] =
                                                        value;
                                                  });
                                                },
                                              )
                                            : null, // If package ID is 3000107 or 3000106, don't show checkbox
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
            backgroundColor: Pallete.buttonColor,
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.visibility),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'VIEW SUBSCRIBED INFO',
                      style: TextStyle(
                        fontFamily: 'Cera-Bold',
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        height: 80,
        color: const Color.fromARGB(59, 208, 203, 203),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Icon(
              Icons.shopping_cart,
              color: Colors.red,
              size: 40,
            ),
            SizedBox(
              width: 200,
              child: Text(
                '₹ ${_calculateTotalPrice().toStringAsFixed(2)}/-', // Display total price with ₹ symbol
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'Cera-Bold',
                  fontSize: 25,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (_cartItems.isEmpty) {
                  // Show toast message indicating that the user doesn't have any items selected
                  _showToastNotification();
                } else {
                  // Navigate to SelectedChannelScreen only if cart items are not empty
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return SelectedChannelScreen(cartItems: _cartItems);
                  }));
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: const Text(
                'Buy/Renew',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Cera-Bold',
                  fontSize: 14,
                ),
              ),
            )
          ],
        ),
      ),
      body: _isLoading
          ? _buildLoadingIndicator()
          : TabBarView(
              controller: _tabController,
              children: <Widget>[
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 50,
                        child: TextField(
                          controller: _searchControllerAlacate,
                          decoration: InputDecoration(
                            hintText: 'Search Channels',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: // Adjust the logic inside the itemBuilder method of ListView.builder
                          ListView.builder(
                        controller: _scrollController,
                        itemCount: _filteredDataAlacarte.isEmpty
                            ? _dataAlacarte.length +
                                1 // Show default itemCount if search query is empty
                            : _filteredDataAlacarte.length +
                                1, // Show filtered itemCount if search query is not empty
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            // Handle loading indicator or empty search result here
                            return Container();
                          }

                          // Adjust index to access correct package data based on search query
                          final package = _filteredDataAlacarte.isEmpty
                              ? _dataAlacarte[index - 1]
                              : _filteredDataAlacarte[index - 1];

                          // Determine whether to hide checkbox based on current plan ID and package properties
                          bool hideCheckbox = false;
                          if (currentPlanId == 3000106) {
                            // If current plan ID is 3000106, hide checkbox if package has 'home_premium' property set to 1
                            hideCheckbox = package['home_premium'] == 1;
                          } else if (currentPlanId == 3000107) {
                            // If current plan ID is 3000107, hide checkbox if package has 'home_essential' property set to 1
                            hideCheckbox = package['home_essential'] == 1;
                          }

                          // Check if the package is already in _cartItems
                          bool isCheckedInitially = _cartItems.any((item) =>
                              item['package_id'] == package['package_id']);

                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Column(
                              children: [
                                // Only show checkbox if hideCheckbox is false
                                Card(
                                  color:
                                      const Color.fromARGB(255, 251, 242, 245),
                                  child: ListTile(
                                    // Only show checkbox if hideCheckbox is false
                                    leading: !hideCheckbox
                                        ? Checkbox(
                                            value:
                                                isCheckedInitially, // Set initial checkbox value based on whether the package is in _cartItems
                                            onChanged: (value) {
                                              setState(() {
                                                if (value ?? false) {
                                                  _addToCart(package);
                                                } else {
                                                  _removeFromCart(
                                                      package['package_id']);
                                                }
                                              });
                                            },
                                          )
                                        : null,
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Channel / Package Name',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: 'Cera-Bold',
                                                  fontSize: 13,
                                                ),
                                              ),
                                              Text(
                                                package['package_name'] ?? '',
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: 'Cera-Bold',
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Price',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: 'Cera-Bold',
                                                  fontSize: 13,
                                                ),
                                              ),
                                              Text(
                                                ' ${package['ttl_cst']} ',
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: 'Cera-Bold',
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                ListView.builder(
                  controller: _scrollController,
                  itemCount: _dataHsi.length + 1,
                  itemBuilder: (context, index) {
                    if (index == _dataHsi.length) {
                      if (_isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        return Container(); // Placeholder while loading more data
                      }
                    }

                    final package = _dataHsi[index];
                    final bool isSelected =
                        package['package_id'] == selectedPackageId;

                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Card(
                        color: const Color.fromARGB(255, 251, 242, 245),
                        child: ListTile(
                          title: Row(
                            children: [
                              SizedBox(
                                width: 250,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Channel / Package Name',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Cera-Bold',
                                        fontSize: 13,
                                      ),
                                    ),
                                    Text(
                                      package['package_name'] ?? '',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Cera-Bold',
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Price',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Cera-Bold',
                                        fontSize: 13,
                                      ),
                                    ),
                                    Text(
                                      '${package['ttl_cst']}',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Cera-Bold',
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          leading: Checkbox(
                            value: isSelected,
                            onChanged: (value) {
                              setState(() {
                                print('Package ID: ${package['package_id']}');
                                print('Current Checkbox Value: $value');
                                if (value == true) {
                                  selectedPackageId = package['package_id'];
                                  // Add the selected HSI item to _cartItems
                                  _addToCart(package);
                                  print(
                                      'Package added to cart: ${package['package_name']}');
                                } else {
                                  selectedPackageId = -1;
                                  _cartItems.remove(
                                      package); // Remove from cart when unchecked
                                  print(
                                      'Package removed from cart: ${package['package_name']}');
                                }
                                print('Cart Items: $_cartItems');
                              });
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 50,
                        child: TextField(
                          controller: _searchControllerFirstShow,
                          decoration: InputDecoration(
                            hintText: 'Search Movies',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: _dataFirstShow
                          .isNotEmpty, // Show the ListView only if _dataFirstShow is not empty
                      child: Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: _filteredDataFirstShow.isEmpty
                              ? _dataFirstShow.length +
                                  1 // Show default itemCount if search query is empty
                              : _filteredDataFirstShow.length +
                                  1, // Show filtered itemCount if search query is not empty
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              // Handle loading indicator or empty search result here
                              return Container();
                            }

                            // Determine whether to hide checkbox based on current plan ID and package properties
                            bool hideCheckbox = false;

                            // Adjust index to access correct package data based on search query
                            final package = _filteredDataFirstShow.isEmpty
                                ? _dataFirstShow[index - 1]
                                : _filteredDataFirstShow[index - 1];

                            // Check if the package is already in _cartItems
                            bool isCheckedInitially = _cartItems.any((item) =>
                                item['package_id'] == package['package_id']);

                            return Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Column(
                                children: [
                                  Card(
                                    color: const Color.fromARGB(
                                        255, 251, 242, 245),
                                    child: ListTile(
                                      // Only show checkbox if hideCheckbox is false
                                      leading: !hideCheckbox
                                          ? Checkbox(
                                              value:
                                                  isCheckedInitially, // Set initial checkbox value based on whether the package is in _cartItems
                                              onChanged: (value) {
                                                setState(() {
                                                  if (value ?? false) {
                                                    _addToCart(package);
                                                  } else {
                                                    _removeFromCart(
                                                        package['package_id']);
                                                  }
                                                });
                                              },
                                            )
                                          : null,
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Channel / Package Name',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: 'Cera-Bold',
                                                    fontSize: 13,
                                                  ),
                                                ),
                                                Text(
                                                  package['package_name'] ?? '',
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: 'Cera-Bold',
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.2,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Price',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: 'Cera-Bold',
                                                    fontSize: 13,
                                                  ),
                                                ),
                                                Text(
                                                  ' ${package['ttl_cst']} ',
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: 'Cera-Bold',
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Visibility(
                      visible: _dataFirstShow
                          .isEmpty, // Show the "Coming Soon" text only if _dataFirstShow is empty
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.6,
                        width: MediaQuery.of(context).size.width * 1,
                        child: const Center(
                          child: Text(
                            'Coming Soon...',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontFamily: 'Cera-Bold',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  // Function to fetch the current plan ID from secure storage
}

Widget _buildLoadingIndicator() {
  return const Center(
    child: CircularProgressIndicator(),
  );
}



// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ Main Check point ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

// ********************************************************** Alacate and First show ****************************************************************
