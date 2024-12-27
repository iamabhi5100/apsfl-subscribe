import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

import 'package:apsflsubscribes/screens/profile_screen.dart';
import 'package:apsflsubscribes/utils/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

class KycScreen extends StatefulWidget {
  const KycScreen({super.key});

  @override
  State<KycScreen> createState() => _KycScreenState();
}

class _KycScreenState extends State<KycScreen> {
  bool ischecked = false;

  // For Front Camera
  bool _showImageFront = false;
  File? _selectedImageFront;
  File? _captureImage;
  File? _captureImageFront;

  // For Back Camera
  bool _showImageBack = false;
  File? _selectedImageBack;
  File? _captureBack;
  File? _captureImageBack;

  // For Customer Camera
  bool _showImageCustomer = false;
  File? _selectedImageCustomer;
  File? _captureCustomer;
  File? _captureImageCustomer;

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
                            _showImageFront
                                ? GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text(
                                                'Select Image Source'),
                                            content: SingleChildScrollView(
                                              child: ListBody(
                                                children: <Widget>[
                                                  GestureDetector(
                                                    child: const Text(
                                                        'Select Image from Gallery'),
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                      _pickImageFromGalleryFront()
                                                          .then((_) {
                                                        setState(() {
                                                          _showImageFront =
                                                              true;
                                                          _captureImageFront =
                                                              null; // Reset capture image
                                                        });
                                                      });
                                                    },
                                                  ),
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                  ),
                                                  GestureDetector(
                                                    child: const Text(
                                                        'Capture Image from Camera'),
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                      _pickImageFromCameraFront()
                                                          .then((_) {
                                                        setState(() {
                                                          _showImageFront =
                                                              true;
                                                          _selectedImageFront =
                                                              null; // Reset selected image
                                                        });
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: SizedBox(
                                      height: 180,
                                      width: 200,
                                      child: _selectedImageFront != null
                                          ? Image.file(
                                              _selectedImageFront!,
                                            )
                                          : _captureImageFront != null
                                              ? Image.file(
                                                  _captureImageFront!,
                                                )
                                              : Container(),
                                    ),
                                  )
                                : InkWell(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text(
                                                'Select Image Source'),
                                            content: SingleChildScrollView(
                                              child: ListBody(
                                                children: <Widget>[
                                                  GestureDetector(
                                                    child: const Text(
                                                        'Select Image from Gallery'),
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                      _pickImageFromGalleryFront()
                                                          .then((_) {
                                                        setState(() {
                                                          _showImageFront =
                                                              true;
                                                          _captureImageFront =
                                                              null; // Reset capture image
                                                        });
                                                      });
                                                    },
                                                  ),
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                  ),
                                                  GestureDetector(
                                                    child: const Text(
                                                        'Capture Image from Camera'),
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                      _pickImageFromCameraFront()
                                                          .then((_) {
                                                        setState(() {
                                                          _showImageFront =
                                                              true;
                                                          _selectedImageFront =
                                                              null; // Reset selected image
                                                        });
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    splashColor: Colors.brown.withOpacity(0.5),
                                    child: Ink(
                                      height: 100,
                                      width: 140,
                                      decoration: const BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              'assets/images/kyc3.jpg'),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
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
                            _showImageBack
                                ? GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text(
                                                'Select Image Source'),
                                            content: SingleChildScrollView(
                                              child: ListBody(
                                                children: <Widget>[
                                                  GestureDetector(
                                                    child: const Text(
                                                        'Select Image from Gallery'),
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                      _pickImageFromGalleryBack()
                                                          .then((_) {
                                                        setState(() {
                                                          _showImageBack = true;
                                                          _captureImageBack =
                                                              null; // Reset capture image
                                                        });
                                                      });
                                                    },
                                                  ),
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                  ),
                                                  GestureDetector(
                                                    child: const Text(
                                                        'Capture Image from Camera'),
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                      _pickImageFromCameraBack()
                                                          .then((_) {
                                                        setState(() {
                                                          _showImageBack = true;
                                                          _selectedImageBack =
                                                              null; // Reset selected image
                                                        });
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: SizedBox(
                                      height: 180,
                                      width: 200,
                                      child: _selectedImageBack != null
                                          ? Image.file(
                                              _selectedImageBack!,
                                            )
                                          : _captureImageBack != null
                                              ? Image.file(
                                                  _captureImageBack!,
                                                )
                                              : Container(),
                                    ),
                                  )
                                : InkWell(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text(
                                                'Select Image Source'),
                                            content: SingleChildScrollView(
                                              child: ListBody(
                                                children: <Widget>[
                                                  GestureDetector(
                                                    child: const Text(
                                                        'Select Image from Gallery'),
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                      _pickImageFromGalleryBack()
                                                          .then((_) {
                                                        setState(() {
                                                          _showImageBack = true;
                                                          _captureImageBack =
                                                              null; // Reset capture image
                                                        });
                                                      });
                                                    },
                                                  ),
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                  ),
                                                  GestureDetector(
                                                    child: const Text(
                                                        'Capture Image from Camera'),
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                      _pickImageFromCameraBack()
                                                          .then((_) {
                                                        setState(() {
                                                          _showImageBack = true;
                                                          _selectedImageBack =
                                                              null; // Reset selected image
                                                        });
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    splashColor: Colors.brown.withOpacity(0.5),
                                    child: Ink(
                                      height: 100,
                                      width: 140,
                                      decoration: const BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              'assets/images/kyc3.jpg'),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
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
                      _showImageCustomer
                          ? GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Select Image Source'),
                                      content: SingleChildScrollView(
                                        child: ListBody(
                                          children: <Widget>[
                                            GestureDetector(
                                              child: const Text(
                                                  'Select Image from Gallery'),
                                              onTap: () {
                                                Navigator.pop(context);
                                                _pickImageFromGalleryCustomer()
                                                    .then((_) {
                                                  setState(() {
                                                    _showImageCustomer = true;
                                                    _captureImageCustomer =
                                                        null; // Reset capture image
                                                  });
                                                });
                                              },
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.all(8.0),
                                            ),
                                            GestureDetector(
                                              child: const Text(
                                                  'Capture Image from Camera'),
                                              onTap: () {
                                                Navigator.pop(context);
                                                _pickImageFromCameraCustomer()
                                                    .then((_) {
                                                  setState(() {
                                                    _showImageCustomer = true;
                                                    _selectedImageCustomer =
                                                        null; // Reset selected image
                                                  });
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: SizedBox(
                                height: 180,
                                width: 200,
                                child: _selectedImageCustomer != null
                                    ? Image.file(
                                        _selectedImageCustomer!,
                                      )
                                    : _captureImageCustomer != null
                                        ? Image.file(
                                            _captureImageCustomer!,
                                          )
                                        : Container(),
                              ),
                            )
                          : InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Select Image Source'),
                                      content: SingleChildScrollView(
                                        child: ListBody(
                                          children: <Widget>[
                                            GestureDetector(
                                              child: const Text(
                                                  'Select Image from Gallery'),
                                              onTap: () {
                                                Navigator.pop(context);
                                                _pickImageFromGalleryCustomer()
                                                    .then((_) {
                                                  setState(() {
                                                    _showImageCustomer = true;
                                                    _captureImageCustomer =
                                                        null; // Reset capture image
                                                  });
                                                });
                                              },
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.all(8.0),
                                            ),
                                            GestureDetector(
                                              child: const Text(
                                                  'Capture Image from Camera'),
                                              onTap: () {
                                                Navigator.pop(context);
                                                _pickImageFromCameraCustomer()
                                                    .then((_) {
                                                  setState(() {
                                                    _showImageCustomer = true;
                                                    _selectedImageCustomer =
                                                        null; // Reset selected image
                                                  });
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
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
                            ),
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

  // TODO: Gallery Picker
  Future _pickImageFromGalleryFront() async {
    // For Front View
    final returnedImageFront =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (returnedImageFront == null) return;
    setState(() {
      _selectedImageFront = File(returnedImageFront.path);
    });
  }

  Future _pickImageFromGalleryBack() async {
    // For Back View
    final returnedImageBack =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (returnedImageBack == null) return;
    setState(() {
      _selectedImageBack = File(returnedImageBack.path);
    });
  }

  Future _pickImageFromGalleryCustomer() async {
    // For Back View
    final returnedImageCustomer =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (returnedImageCustomer == null) return;
    setState(() {
      _selectedImageCustomer = File(returnedImageCustomer.path);
    });
  }

  // TODO: For Camera

  // FIXME: For Front Camera
  Future<String?> _pickImageFromCameraFront() async {
    // For Front Camera
    final returnedImageFront =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (returnedImageFront == null) return null;

    setState(() {
      _captureImageFront = File(returnedImageFront.path);
    });

    if (_captureImageFront == null) return null;

    // Convert the image to base64
    String? base64Image = await _convertImageToBase64(
        _captureImageFront!); // Ensure non-null here

    // Print the base64 string
    // print('Base64 Image: $base64Image');

    // Return the base64 string or null if conversion failed
    return base64Image;
  }

  Future<String?> _convertImageToBase64(File imageFile) async {
    // Ensure that imageFile is not null
    if (imageFile == null) return null;

    // Read the file as bytes
    List<int> imageBytes = await imageFile.readAsBytes();

    // Encode the bytes to base64 string
    String base64Image = base64Encode(imageBytes);

    print(base64Image);

    return base64Image;
  }

  // FIXME: For Back Camera
  Future _pickImageFromCameraBack() async {
    final returnedImageBack =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnedImageBack == null) return;
    setState(() {
      _captureImageBack = File(returnedImageBack.path);
    });
  }

  // FIXME: For Back Customer
  Future _pickImageFromCameraCustomer() async {
    final returnedImageCustomer =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnedImageCustomer == null) return;
    setState(() {
      _captureImageCustomer = File(returnedImageCustomer.path);
    });
  }
}
