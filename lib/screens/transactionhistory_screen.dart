import 'package:apsflsubscribes/screens/home_screen.dart';
import 'package:apsflsubscribes/utils/pallete.dart';
import 'package:flutter/material.dart';

class TransactionHistory extends StatelessWidget {
  const TransactionHistory({super.key});

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
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 30,
            )),
        title: const Text(
          'Tranaction History',
          style: TextStyle(color: Colors.white, fontFamily: 'Cera-Bold'),
        ),
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              Card(
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Customer Name',
                            style: TextStyle(
                                fontFamily: 'Cera-Bold', fontSize: 12),
                          ),
                          Text(
                            'Date',
                            style: TextStyle(
                                fontFamily: 'Cera-Bold', fontSize: 12),
                          ),
                          Text(
                            'Payment Mode',
                            style: TextStyle(
                                fontFamily: 'Cera-Bold', fontSize: 12),
                          ),
                          Text(
                            'Package name',
                            style: TextStyle(
                                fontFamily: 'Cera-Bold', fontSize: 12),
                          ),
                          Text(
                            'LMO',
                            style: TextStyle(
                                fontFamily: 'Cera-Bold', fontSize: 12),
                          ),
                          Text(
                            'Receipt No',
                            style: TextStyle(
                                fontFamily: 'Cera-Bold', fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ':',
                            style: TextStyle(
                                fontFamily: 'Cera-Bold', fontSize: 12),
                          ),
                          Text(
                            ':',
                            style: TextStyle(
                                fontFamily: 'Cera-Bold', fontSize: 12),
                          ),
                          Text(
                            ':',
                            style: TextStyle(
                                fontFamily: 'Cera-Bold', fontSize: 12),
                          ),
                          Text(
                            ':',
                            style: TextStyle(
                                fontFamily: 'Cera-Bold', fontSize: 12),
                          ),
                          Text(
                            ':',
                            style: TextStyle(
                                fontFamily: 'Cera-Bold', fontSize: 12),
                          ),
                          Text(
                            ':',
                            style: TextStyle(
                                fontFamily: 'Cera-Bold', fontSize: 12),
                          ),
                          Text(
                            ':',
                            style: TextStyle(
                                fontFamily: 'Cera-Bold', fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sive Kumar',
                            style: TextStyle(
                                fontFamily: 'Cera-Bold', fontSize: 12),
                          ),
                          Text(
                            '27-03-2024 18:14:49',
                            style: TextStyle(
                                fontFamily: 'Cera-Bold', fontSize: 12),
                          ),
                          Text(
                            'Rs 499/-',
                            overflow: TextOverflow.ellipsis,
                            // overflow: TextOverflow.clip,
                            // maxLines: 2,
                            // softWrap: true,
                            style: TextStyle(
                                fontFamily: 'Cera-Bold', fontSize: 12),
                          ),
                          Text(
                            'Debit',
                            style: TextStyle(
                                fontFamily: 'Cera-Bold', fontSize: 12),
                          ),
                          Text(
                            'Home Essential',
                            style: TextStyle(
                                fontFamily: 'Cera-Bold', fontSize: 12),
                          ),
                          Text(
                            'LMO3659',
                            style: TextStyle(
                                fontFamily: 'Cera-Bold', fontSize: 12),
                          ),
                          Text(
                            'RCPT_ID_1709854393980',
                            style: TextStyle(
                                fontFamily: 'Cera-Bold', fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
