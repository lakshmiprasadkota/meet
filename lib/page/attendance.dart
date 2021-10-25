import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:meet_and_biometric/api/local_auth_api.dart';
import 'package:meet_and_biometric/date_base/attedence_db.dart';
import 'package:meet_and_biometric/model/note.dart';
import 'package:meet_and_biometric/page/verification_page.dart';

import '../botton.dart';


class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({Key? key}) : super(key: key);

  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  List<Note>? note;
  bool isloading = false;

  @override
  void initState() {
    // TODO: implement initState
    refreshNotes();
    super.initState();
  }

  @override
  void dispose() {
    AttendanceDateBase.instance.close();

    super.dispose();
  }

  Future refreshNotes() async {
    setState(() => isloading = true);

    note = await AttendanceDateBase.instance.readAllNotes();

    setState(() => isloading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 70,
          backgroundColor: Color(0xFF232939),
          automaticallyImplyLeading: false,
          title: Text("Daily Attendance", style: GoogleFonts.inter(
              fontWeight: FontWeight.w500,
              color: Color(0xFFe6d888),
              fontSize: 18)),
          centerTitle: true,
        ),
        body: Column(
          children: [

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () async {
                      final isAuthenticated = await LocalAuthApi.authenticate();

                      if (isAuthenticated) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => verificationPage()),
                        );
                      }
                    },
                    child: ButtonWidget(
                      name: 'Log-in',
                      buttonWidth: 100,
                    ),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  ButtonWidget(name: 'Log-Out', buttonWidth: 100),
                ],
              ),
            ),
         Row(
           children: [
           Container(
             width: MediaQuery.of(context).size.width *0.8,
             height: 1,
             color: Colors.grey.withOpacity(0.5),
           ),
            Text("Filter" ,style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                color:  Color(0xFF232939),
                fontSize: 14)),
            FaIcon(FontAwesomeIcons.filter, color: Color(0xFF232939), size: 20,)
           ],
         ),
    const SizedBox(
    height: 15,
    ),
           Expanded(child: SingleChildScrollView(
             physics: BouncingScrollPhysics(),
             child: Column(children: [
               Center(
                   child: isloading
                       ? const CircularProgressIndicator()
                       : note == null || note!.isEmpty
                       ? Text(
                     'No Records',
                     style: TextStyle(color: Colors.black, fontSize: 24),
                   )
                       : ListView.separated(
                       itemCount: note!.length,
                       shrinkWrap: true,
                       physics: NeverScrollableScrollPhysics(),
                       separatorBuilder: (context, index) {
                         return const SizedBox(
                           height: 15,
                         );
                       },
                       itemBuilder: (context, index) {
                         return Container(
                           margin:
                           const EdgeInsets.symmetric(horizontal: 10),
                           padding: const EdgeInsets.symmetric(
                               vertical: 10, horizontal: 8),
                           decoration: BoxDecoration(
                               color: Colors.white,
                               borderRadius: BorderRadius.circular(10),
                               boxShadow: [
                                 BoxShadow(
                                   color: Colors.black.withOpacity(0.1),
                                   offset: Offset(0, 4),
                                 )
                               ]),
                           child: Row(children: [
                             CircleAvatar(
                               maxRadius: 20,
                               backgroundImage:
                               FileImage(File(note![index].image)),
                             ),
                             const SizedBox(
                               width: 10,
                             ),
                             Flexible(
                                 child: Row(
                                   mainAxisAlignment:
                                   MainAxisAlignment.spaceBetween,
                                   children: [
                                     Column(
                                       crossAxisAlignment:
                                       CrossAxisAlignment.start,
                                       children: [
                                         Text(
                                           "${note![index].address}",
                                           style: GoogleFonts.openSans(
                                               fontWeight: FontWeight.w500,
                                               fontSize: 14),
                                         ),
                                         Text(
                                             "${DateFormat().format(note![index].createdTime)}",
                                             style: GoogleFonts.openSans(
                                                 fontWeight: FontWeight.w500,
                                                 color: Colors.grey,
                                                 fontSize: 12))
                                       ],
                                     ),
                                     FaIcon(
                                       FontAwesomeIcons.checkCircle,
                                       color: Colors.green,
                                     ),
                                   ],
                                 )),
                           ]),
                         );
                       })),
               SizedBox(height: 20,)
             ],),
           ))
          ],
        ));
  }
}