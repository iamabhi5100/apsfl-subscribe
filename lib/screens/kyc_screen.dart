import 'package:apsflsubscribes/screens/profile_screen.dart';
import 'package:apsflsubscribes/utils/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class KycScreen extends StatefulWidget {
  const KycScreen({super.key});

  @override
  State<KycScreen> createState() => _KycScreenState();
}

class _KycScreenState extends State<KycScreen> {
  bool ischecked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Pallete.backgroundColor,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return const ProfileScreen();
            }));
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 30,
          ),
        ),
        title: const Text(
          'Kyc Document Upload',
          style: TextStyle(
            fontFamily: 'Cera-Bold',
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Aadhar No/Register NO *',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Cera-Bold',
                  ),
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: 40,
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Enter Aadhaar Number',
                        labelStyle: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cera-Bold',
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40)),
                      ),
                    ),
                  ),
                  Container(
                    width: 120,
                    margin: const EdgeInsets.only(left: 10),
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text(
                        'RETRIVE',
                        style: TextStyle(
                            color: Colors.white, fontFamily: 'Cera-Bold'),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Pallete.backgroundColor,
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'First Name *',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Cera-Bold',
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  SizedBox(
                    // width: 260,
                    height: 40,
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Enter First Name',
                        labelStyle: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cera-Bold',
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 4,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Last Name *',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Cera-Bold',
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  SizedBox(
                    // width: 260,
                    height: 40,
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Enter Last Name',
                        labelStyle: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cera-Bold',
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 4,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Guardian Name *',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Cera-Bold',
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  SizedBox(
                    // width: 260,
                    height: 40,
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Enter Guardian Name',
                        labelStyle: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cera-Bold',
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 4,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Email ID *',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Cera-Bold',
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  SizedBox(
                    // width: 260,
                    height: 40,
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Enter Email ID',
                        labelStyle: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cera-Bold',
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 4,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Building/House/Flat **',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Cera-Bold',
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  SizedBox(
                    // width: 260,
                    height: 40,
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Enter house no',
                        labelStyle: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cera-Bold',
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 4,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Street Name *',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Cera-Bold',
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  SizedBox(
                    // width: 260,
                    height: 40,
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Enter Street Name',
                        labelStyle: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cera-Bold',
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 4,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Locality/Area *',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Cera-Bold',
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  SizedBox(
                    // width: 260,
                    height: 40,
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Enter Area ',
                        labelStyle: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cera-Bold',
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 4,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Enter Village *',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Cera-Bold',
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  SizedBox(
                    // width: 260,
                    height: 40,
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Enter Village',
                        labelStyle: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cera-Bold',
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 4,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pin code *',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Cera-Bold',
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  SizedBox(
                    // width: 260,
                    height: 40,
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Enter Enter Pincode',
                        labelStyle: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cera-Bold',
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40)),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            const Text(
                              'Capture Front View **',
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Cera-Bold',
                              ),
                            ),
                            InkWell(
                              onTap: () {}, // Handle your callback.
                              splashColor: Colors.brown.withOpacity(0.5),
                              child: Ink(
                                height: 100,
                                width: 140,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('assets/images/kyc3.jpg'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            const Text(
                              'Capture Back View **',
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Cera-Bold',
                              ),
                            ),
                            InkWell(
                              onTap: () {}, // Handle your callback.
                              splashColor: Colors.brown.withOpacity(0.5),
                              child: Ink(
                                height: 100,
                                width: 140,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('assets/images/kyc2.jpg'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(11.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Customer Photo Upload **',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Cera-Bold',
                        ),
                      ),
                      InkWell(
                        onTap: () {}, // Handle your callback.
                        splashColor: Colors.brown.withOpacity(0.5),
                        child: Ink(
                          height: 100,
                          width: 140,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/kyc2.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(11.0),
                    child: Text(
                      'Confirm KYC Details *',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Cera-Bold',
                      ),
                    ),
                  ),
                  CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      activeColor: Colors.pink,
                      title: const Text(
                        "I have read and accept the terms and conditions of APSFL",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Cera-Bold',
                        ),
                      ),
                      value: ischecked,
                      onChanged: (val) {
                        setState(() {
                          ischecked = val!;
                        });
                      })
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Mobile Number *',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Cera-Bold',
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  SizedBox(
                    // width: 260,
                    height: 40,
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Enter Mobile Number',
                        labelStyle: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cera-Bold',
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40)),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 160,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        'SUBMIT KYC',
                        style: const TextStyle(
                            color: Colors.white, fontFamily: 'Cera-Bold'),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Pallete.backgroundColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
