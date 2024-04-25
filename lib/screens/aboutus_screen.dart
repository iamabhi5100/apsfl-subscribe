import 'package:apsflsubscribes/screens/home_screen.dart';
import 'package:apsflsubscribes/utils/pallete.dart';
import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Pallete.backgroundColor,
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
          ),
        ),
        title: const Text(
          'About US',
          style: TextStyle(color: Colors.white, fontFamily: 'Cera-Bold'),
        ),
      ),
      body: Column(
        children: [
          Column(
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                child: Center(
                  child: Card(
                    elevation: 10,
                    child: Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            'assets/images/911.png',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Icon(
                              Icons.info,
                              color: Pallete.buttonColor,
                              size: 40,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 10, right: 10, bottom: 10),
                                  child: Text(
                                    'About US',
                                    style: TextStyle(
                                      fontFamily: 'Cera-Bold',
                                      fontSize: 17,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 10, right: 10, bottom: 10),
                                  child: Text(
                                    'AP State FiberNet Limited (APSFL) has \nbeen incorporated under the companies \nAct, 2013 in the month of October,2015. \nit is a fully owned entity of the Govt of \nthe AP under the control of infrastructure\n and Investment Department. This \nCorporation is responsible undertaking \nthe works of AP Fiber Grid, its Operations\nand Maintenance and business activities \nduly partnering with various stakeholders\nfor the benefit of all',
                                    maxLines: 10,
                                    // overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontFamily: 'Cera-Medium',
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
