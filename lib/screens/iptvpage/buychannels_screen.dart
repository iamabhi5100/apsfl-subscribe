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

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _firstShowSearchController =
      TextEditingController();
  List<Map<String, dynamic>> _filteredDataAlacarte = [];
  List<Map<String, dynamic>> _filteredDataFirstShow = [];

  bool _showFab = true; // Track FloatingActionButton visibility

  List<Map<String, dynamic>> _dataAlacarte = [];
  List<Map<String, dynamic>> _dataHsi = [];
  List<Map<String, dynamic>> _dataFirstShow = [];
  List<Map<String, dynamic>> _dataExistingPckge = [];
  List<bool> _isCheckedList = [];
  List<bool> _isCheckedList1 = [];
  List<bool> _isCheckedList2 = [];
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
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  // Function to handle search text changes
  void _onSearchChanged() {
    setState(() {
      _filteredDataAlacarte = _dataAlacarte
          .where((package) => package['package_name']
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()))
          .toList();
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

    const apiUrl =
        'http://bssuat.apsfl.co.in/apiv1/subscriberApp/cstmr_packages';

    final Map<String, String> headers = {
      'x-access-token':
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyIwIjp7ImNhZl9pZCI6MjAwMjQzMDg1LCJreWMiOiJObyIsIm1ibF9udSI6OTY1MjY2NTQ0OCwiY3N0bXJfbm0iOiJhcHNmbCJ9LCJhcHAiOm51bGwsImlhdCI6MTcxNDA0OTc1MH0.RF5WUC3F5im5_rgoqEZO_StIy92yhMUh-JAgn3kfbOM',
      'Content-Type': 'application/json'
    };

    final Map<String, dynamic> requestBody = {
      "app_type": "Customer",
      "caf_id": "200243085",
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

      print(responseData);
      setState(() {
        _dataAlacarte.addAll(Alacartedata.cast<Map<String, dynamic>>());
        _dataHsi.addAll(Hsidata.cast<Map<String, dynamic>>());
        _dataFirstShow.addAll(FirstShowdata.cast<Map<String, dynamic>>());
        _dataExistingPckge
            .addAll(ExistingPackages.cast<Map<String, dynamic>>());

        // Initialize the checkbox lists for each tab
        _isCheckedList =
            List<bool>.filled(_dataAlacarte.length, false, growable: true);
        _isCheckedList1 =
            List<bool>.filled(_dataHsi.length, false, growable: true);
        _isCheckedList2 =
            List<bool>.filled(_dataFirstShow.length, false, growable: true);
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
                ListView.builder(
                  controller: _scrollController,
                  itemCount: _filteredDataAlacarte.isEmpty
                      ? _dataAlacarte.length +
                          1 // Show default itemCount if search query is empty
                      : _filteredDataAlacarte.length +
                          1, // Show filtered itemCount if search query is not empty
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      // Display SearchBar as the first item
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SearchBar(
                          controller: _searchController,
                          hintText: 'Search packages',
                          leading: const Icon(Icons.search),
                          trailing: [
                            IconButton(
                              icon: const Icon(Icons.brightness_6),
                              onPressed: () {
                                // Add action for toggling brightness
                              },
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              // Filter the list of packages based on the entered text value
                              _filteredDataAlacarte = _dataAlacarte
                                  .where((package) => package['package_name']
                                      .toLowerCase()
                                      .contains(value.toLowerCase()))
                                  .toList();
                            });
                          },
                        ),
                      );
                    } else if (index ==
                        (_filteredDataAlacarte.isEmpty
                            ? _dataAlacarte.length
                            : _filteredDataAlacarte.length)) {
                      // Handle loading indicator
                      if (_isLoading) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        return Container(); // Placeholder while loading more data
                      }
                    }

                    // Build your list items based on search query
                    final package = _filteredDataAlacarte.isEmpty
                        ? _dataAlacarte[index - 1]
                        : _filteredDataAlacarte[index - 1];

                    // Determine whether to hide checkbox based on current plan ID and package properties
                    bool hideCheckbox = false;
                    print(
                        'this is currentplanid before if else $currentPlanId');
                    if (currentPlanId == 3000106) {
                      print('inside premium');
                      // If current plan ID is 3000106, hide checkbox if package has 'home_premium' property set to 1
                      hideCheckbox = package['home_premium'] == 1;
                    } else if (currentPlanId == 3000107) {
                      print('inside essential');
                      // If current plan ID is 3000107, hide checkbox if package has 'home_essential' property set to 1
                      hideCheckbox = package['home_essential'] == 1;
                    }

                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        children: [
                          // Only show checkbox if hideCheckbox is false
                          Card(
                            color: const Color.fromARGB(255, 251, 242, 245),
                            child: ListTile(
                              // Only show checkbox if hideCheckbox is false
                              leading: !hideCheckbox
                                  ? Checkbox(
                                      value: _filteredDataAlacarte.isEmpty
                                          ? _isCheckedList[index - 1] ?? false
                                          : _isCheckedList[index - 1] ?? false,
                                      onChanged: (value) {
                                        setState(() {
                                          _isCheckedList[index - 1] =
                                              value ?? false;
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
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
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
                                  _cartItems
                                      .clear(); // Clear existing cart items
                                  _cartItems.add(
                                      package); // Add only the selected package to the cart
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
                ListView.builder(
                  controller: _scrollController,
                  itemCount: _filteredDataFirstShow.isEmpty
                      ? _dataFirstShow.length +
                          1 // Show default itemCount if search query is empty
                      : _filteredDataFirstShow.length +
                          1, // Show filtered itemCount if search query is not empty
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      // Display SearchBar as the first item
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SearchBar(
                          controller: _firstShowSearchController,
                          hintText: 'Search packages',
                          leading: const Icon(Icons.search),
                          // trailing: [
                          //   IconButton(
                          //     icon: Icon(Icons.search),
                          //     onPressed: () {
                          //       // Add action for toggling brightness
                          //     },
                          //   ),
                          // ],
                          onChanged: (value) {
                            setState(() {
                              // Filter the list of packages based on the entered text value
                              _filteredDataFirstShow = _dataFirstShow
                                  .where((package) => package['package_name']
                                      .toLowerCase()
                                      .contains(value.toLowerCase()))
                                  .toList();
                            });
                          },
                        ),
                      );
                    } else if (index ==
                        (_filteredDataFirstShow.isEmpty
                            ? _dataFirstShow.length
                            : _filteredDataFirstShow.length)) {
                      // Handle loading indicator
                      if (_isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        return Container(); // Placeholder while loading more data
                      }
                    }

                    // Build your list items based on search query
                    final package = _filteredDataFirstShow.isEmpty
                        ? _dataFirstShow[index - 1]
                        : _filteredDataFirstShow[index - 1];
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Card(
                        color: const Color.fromARGB(255, 251, 242, 245),
                        child: CheckboxListTile(
                          title: Row(
                            children: [
                              // Display the image if the URL is not null
                              package['image_url'] != null
                                  ?
                                  // SizedBox(
                                  //     width: 50,
                                  //     height: 50,
                                  //     child:
                                  //         Image.network(package['image_url'] ?? ''),
                                  //   )
                                  Container(
                                      height: 50,
                                      width: 50,
                                      color: Colors.grey, // Placeholder color
                                      child: const Center(
                                        child: Icon(
                                          Icons.image_not_supported,
                                          color: Colors
                                              .white, // Placeholder icon color
                                        ),
                                      ),
                                    )
                                  : Container(
                                      height: 50,
                                      width: 50,
                                      color: Colors.grey, // Placeholder color
                                      child: const Center(
                                        child: Icon(
                                          Icons.image_not_supported,
                                          color: Colors
                                              .white, // Placeholder icon color
                                        ),
                                      ),
                                    ), // Add a condition to check if image URL is available
                              const SizedBox(
                                width: 16,
                              ), // Add some spacing between image and text
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    package['package_name'] ?? '',
                                    style: const TextStyle(
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
                            ],
                          ),
                          value: _filteredDataFirstShow.isEmpty
                              ? _isCheckedList2[index - 1] ?? false
                              : _isCheckedList2[index - 1] ?? false,
                          onChanged: (value) {
                            setState(() {
                              _isCheckedList2[index - 1] = value ?? false;
                              if (value ?? false) {
                                _addToCart(package);
                              } else {
                                _removeFromCart(package['package_id']);
                              }
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      ),
                    );
                  },
                )
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
