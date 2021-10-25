import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:meet_and_biometric/page/attendance.dart';
import 'package:meet_and_biometric/page/meeting_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: DashBoard());
  }
}

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  String? storedItems;
  List <String> items = ["Dialer" ,"Leads" ,"Clients" ,"Tools" ,"D.P.R" ,"Follow Up" ,"Meeting" ,"Attendance" ,];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFfafafa),
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Color(0xFF232939),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text("Super Pilot Ace",
            style: GoogleFonts.inter(
                fontWeight: FontWeight.w700,
                color: Color(0xFFe6d888),
                fontSize: 20)),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 29),
            margin: const EdgeInsets.symmetric(vertical: 15,horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.white,
             boxShadow: [
               BoxShadow(
                 color: Color(0xFFc4c4c4),
                 blurRadius: 2,
                 offset: Offset(0,1)
               )
             ],
              borderRadius: BorderRadius.circular(5)
            ),
            child: Column(
              children: [
                Text("Points",
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFe4d587),
                        fontSize: 18)),
                const SizedBox(height: 18,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: TextStyle(),
                        children: <TextSpan>[
                          TextSpan(
                              text: "Target  : ",
                              style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black)),
                          TextSpan(
                              text: '  666',
                              style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFFe4d587))),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(),
                        children: <TextSpan>[
                          TextSpan(
                              text: "Earned  : ",
                              style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black)),
                          TextSpan(
                              text: '  0',
                              style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFFe4d587))),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 13,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: TextStyle(),
                        children: <TextSpan>[
                          TextSpan(
                              text: "Canceled :",
                              style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black)),
                          TextSpan(
                              text: '  666',
                              style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFFe4d587))),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(),
                        children: <TextSpan>[
                          TextSpan(
                              text: "Pending :",
                              style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black)),
                          TextSpan(
                              text: '  0',
                              style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFFe4d587))),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 13,),
                Container(
                  alignment: Alignment.topLeft,
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(),
                      children: <TextSpan>[
                        TextSpan(
                            text: "Bucket Points :",
                            style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.black
                            )),
                        TextSpan(
                            text: '  0',
                            style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFe4d587)
                            )),
                      ],
                    ),
                  ),
                ),

              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
            child: GridView.builder(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemCount: items.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    childAspectRatio: 3,
                    mainAxisSpacing: 16),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
setState(() {
  storedItems = items[index];

});
if(storedItems == "Attendance"){
  Navigator.push(context, MaterialPageRoute(builder: (context) =>AttendanceScreen() ));
}if(storedItems == "Meeting"){
  Navigator.push(context, MaterialPageRoute(builder: (context) =>Meeting() ));
}
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF232939),
                        borderRadius: BorderRadius.circular(5)
                      ),
                      child: Center(
                        child: Text(items[index],
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFe6d888),
                                fontSize: 14)),
                      ) ,
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
