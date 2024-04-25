import 'package:apsflsubscribes/screens/hsiusage_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:percent_indicator/percent_indicator.dart';

class MyplanScreen extends StatefulWidget {
  final int totalData;
  final int usedData;
  final String? upNetSpeed;
  final String? downNetSpeed;
  final String? basePackage;

  const MyplanScreen({
    Key? key,
    required this.totalData,
    required this.usedData,
    required this.upNetSpeed,
    required this.downNetSpeed,
    required this.basePackage,
  }) : super(key: key);

  @override
  State<MyplanScreen> createState() => _MyplanScreenState();
}

class _MyplanScreenState extends State<MyplanScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: widget.totalData > 0
          ? (widget.usedData / widget.totalData) * 100
          : 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
  }

  @override
  void didUpdateWidget(MyplanScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: widget.totalData > 0
          ? (widget.usedData / widget.totalData) * 100
          : 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Material(
              elevation: 20,
              borderRadius: BorderRadius.circular(10.0),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: const Color.fromARGB(255, 255, 255, 255),
                ),
                height: 180,
                width: 180,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'My Plan',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Cera-Bold',
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 4, bottom: 4),
                      child: Row(
                        children: [
                          const Text(
                            'Download',
                            style: TextStyle(fontFamily: 'Cera-Bold'),
                          ),
                          const Text(
                            ':',
                            style: TextStyle(fontFamily: 'Cera-Bold'),
                          ),
                          Text(
                            '↓ ${widget.downNetSpeed}',
                            style: const TextStyle(fontFamily: 'Cera-Bold'),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 4, bottom: 4),
                      child: Row(
                        children: [
                          const Text(
                            'Upload',
                            style: TextStyle(fontFamily: 'Cera-Bold'),
                          ),
                          const Text(
                            ':',
                            style: TextStyle(fontFamily: 'Cera-Bold'),
                          ),
                          Text(
                            '↑ ${widget.upNetSpeed}',
                            style: const TextStyle(fontFamily: 'Cera-Bold'),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 6, bottom: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${widget.basePackage}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'Cera-Bold',
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _showToastNotification();
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
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Material(
              elevation: 20,
              borderRadius: BorderRadius.circular(10.0),
              child: GestureDetector(
                onTap: () {
                  // Handle tap
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return const HisUsageScreen();
                  }));
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  height: 180,
                  width: 180,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Data Usage',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Cera-Bold',
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircularPercentIndicator(
                              radius: 60.0,
                              lineWidth: 13.0,
                              animation: true,
                              percent: _progressAnimation.value / 100,
                              center: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${_progressAnimation.value.round()}%',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  Text(
                                    '${widget.usedData}GB\nused of\n${widget.totalData}GB',
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontFamily: 'Cera-Bold',
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                              circularStrokeCap: CircularStrokeCap.round,
                              progressColor:
                                  const Color.fromARGB(255, 204, 85, 45),
                              backgroundColor: Colors.grey[300]!,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void _showToastNotification() {
  Fluttertoast.showToast(
    msg: "You don't have Access",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.red,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}
