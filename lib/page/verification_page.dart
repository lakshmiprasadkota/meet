
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:meet_and_biometric/date_base/attedence_db.dart';
import 'package:meet_and_biometric/model/note.dart';
import 'dart:io';

import 'attendance.dart';

class verificationPage extends StatefulWidget {
  @override
  State<verificationPage> createState() => _verificationPageState();
}

class _verificationPageState extends State<verificationPage> {
  File? profile;
  Position? position;
  String location = 'Null, Press Button';
  String Address = 'Address';

  void getingPosition() async {
    position = await _determinePosition();
    location = 'Lat: ${position!.latitude} , Long:${position!.longitude}';
    GetAdreessFromLatLong(position!);

    print(position!.latitude);
  }

  Future<void> GetAdreessFromLatLong(Position postion) async {
    List<Placemark> placemark =
        await placemarkFromCoordinates(postion.latitude, postion.longitude);
    print(placemark);
    Placemark place = placemark[0];
    setState(() {
      Address = '${place.locality} , ${place.postalCode} ,${place.country}';
    });
  }

  final picker = ImagePicker();

  @override
  void initState() {
    // TODO: implement initState

    pickProfile(ImageSource.camera);
    getingPosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar:AppBar(
          toolbarHeight: 70,
          backgroundColor: Color(0xFF232939),
          automaticallyImplyLeading: false,
          title: Text("Conform Details", style: GoogleFonts.inter(
              fontWeight: FontWeight.w500,
              color: Color(0xFFe6d888),
              fontSize: 20)),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(32),
          child: Center(
            child: Column(

              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                InkWell(
                  onTap: (){
                    pickProfile(ImageSource.camera);
                  },
                  child: ClipRRect(

                     borderRadius: BorderRadius.circular(10),

                    child: profile != null
                        ? Image.file(profile! , fit: BoxFit.cover,)
                        : Icon(Icons.camera),
                  ),
                ),

                SizedBox(
                  height: 10,
                ),
                if (Address != null)
                  Row(
                    children: [
                      Text(
                        'Address :',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w700),
                      ),
                      Flexible(
                        child: Text("    ${Address}" ,style: GoogleFonts.openSans(
                            fontWeight: FontWeight.w500,
                            fontSize: 14),),
                      )
                    ],
                  ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Text(
                      'Login Time :',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w700),
                    ),
                    Flexible(
                      child: Text("  ${DateFormat.jms().format(DateTime.now())} " , style: GoogleFonts.openSans(
                          fontWeight: FontWeight.w500,
                          fontSize: 14), ),
                    ),

                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Flexible(
                  child: Row(
                    children: [
                      Text(
                        'Date :',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w700),
                      ),
                      Text("  ${DateFormat.yMMMMd().format(DateTime.now())}" , style: GoogleFonts.openSans(
                          fontWeight: FontWeight.w500,
                          fontSize: 14), ),

                    ],
                  ),
                ),
                SizedBox(height: 48),
                buildLogoutButton(context)
              ],
            ),
          ),
        ),
      );

  Widget buildLogoutButton(BuildContext context) => ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Color(0xFF232939),
        minimumSize: Size.fromHeight(50),
      ),
      child: Text(
        'Conform Details',
        style: TextStyle(fontSize: 18 ,color: Color(0xFFe6d888)),
      ),
      onPressed: () async {
        final note = Note(
          image: profile!.path,
          address: Address,
          createdTime: DateTime.now(),
        );

        await AttendanceDateBase.instance.create(note);
        Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => AttendanceScreen()),
            );

      });

  void pickProfile(ImageSource source) async {
    final XFile? pickerFile = await ImagePicker().pickImage(source: source);
    setState(() {
      profile = File(pickerFile!.path);
    });
  }

  Widget profileBottomSheet() {
    return Container(
      padding: const EdgeInsets.only(
        top: 30,
      ),
      height: 150,
      width: double.infinity,
      //color: Colors.grey,
      child: Column(
        children: [
          Text(
            "Upload Selfie",
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton.icon(
                onPressed: () {
                  pickProfile(ImageSource.camera);
                },
                icon: Icon(
                  Icons.camera,
                ),
                label: Text(
                  "Camera",
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}
