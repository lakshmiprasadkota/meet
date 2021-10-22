import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:jitsi_meet/jitsi_meet.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: Meeting());
  }
}

class Meeting extends StatefulWidget {
  @override
  _MeetingState createState() => _MeetingState();
}

class _MeetingState extends State<Meeting> {
  final serverText = TextEditingController();
  final roomText = TextEditingController(text: "plugintestroom");
  final subjectText = TextEditingController(text: "My Plugin Test Meeting");
  final nameText = TextEditingController(text: "Plugin Test User");
  final emailText = TextEditingController(text: "fake@email.com");
  final iosAppBarRGBAColor =
  TextEditingController(text: "#0080FF80"); //transparent blue
  bool isAudioOnly = true;
  bool isAudioMuted = true;
  bool isVideoMuted = true;

  @override
  void initState() {
    super.initState();
    JitsiMeet.addListener(JitsiMeetingListener(
        onConferenceWillJoin: _onConferenceWillJoin,
        onConferenceJoined: _onConferenceJoined,
        onConferenceTerminated: _onConferenceTerminated,
        onError: _onError));
  }

  @override
  void dispose() {
    super.dispose();
    JitsiMeet.removeAllListeners();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor:Colors.white ,
        appBar: AppBar(elevation: 0,
          centerTitle: true,
          backgroundColor:Colors.orangeAccent,
          title: const Text('SP - ACE' , style: TextStyle(color: Colors.white ,fontWeight: FontWeight.w700),),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 30.0,
          ),
          child: kIsWeb
              ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: width * 0.30,
                child: meetConfig(),
              ),
              Container(
                  width: width * 0.60,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                        color: Colors.white54,
                        child: SizedBox(
                          width: width * 0.60 * 0.70,
                          height: width * 0.60 * 0.70,
                          child: JitsiMeetConferencing(
                            extraJS:  [
                              // extraJs setup example
                              '<script>function echo(){console.log("echo!!!")};</script>',
                              '<script src="https://code.jquery.com/jquery-3.5.1.slim.js" integrity="sha256-DrT5NfxfbHvMHux31Lkhxg42LY6of8TaYyK50jnxRnM=" crossorigin="anonymous"></script>'
                            ],
                          ),
                        )),
                  ))
            ],
          )
              : meetConfig(),
        ),
      ),
    );
  }

  Widget meetConfig() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: 16.0,
        ),
        Container(

          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Colors.blueGrey.withOpacity(0.1),
                  offset: Offset(0, 10),
                  blurRadius: 15,
                  spreadRadius: 1)
            ],
          ),
          child: TextField(
            maxLines: 3,
            controller: roomText,
            decoration: InputDecoration(
                isDense: true,
                fillColor: Colors.white,
                filled: true,
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        bottomRight: Radius.circular(150)),
                    borderSide: BorderSide(color: Colors.transparent)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        bottomRight: Radius.circular(150)),
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    )),
                labelText: "Enter Room Name",
                labelStyle:
                TextStyle(color: Colors.blueGrey, fontSize: 15)),
          ),
        ),
        SizedBox(height: 15,),
Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Container(
    decoration: BoxDecoration(
      color: isAudioMuted? Colors.grey.withOpacity(0.2) :Colors.grey.withOpacity(0.8),
      shape: BoxShape.circle
    ),
    child: IconButton(onPressed: (){

      setState(() {
        isAudioMuted = !isAudioMuted! ;
      });
    }, icon: isAudioMuted?Icon(Icons.mic_external_off): Icon(Icons.mic ) ,),
    ),
    SizedBox(width: 10,),
    // IconButton(onPressed: (){
    //   setState(() {
    //     isAudioOnly = !isAudioOnly! ;
    //   });
    // }, icon: isAudioOnly?Icon(Icons.campaign): Icon(Icons.audiotrack_outlined)),
    Container(
    decoration: BoxDecoration(
        color: isVideoMuted? Colors.grey.withOpacity(0.2) :Colors.grey.withOpacity(0.8),
        shape: BoxShape.circle
    ),
    child: IconButton(onPressed: (){
      setState(() {
        isVideoMuted = !isVideoMuted! ;
      });
    }, icon: isVideoMuted?Icon(Icons.perm_camera_mic): Icon(Icons.camera)),
    ),
  ],
),
        SizedBox(height: 60,),
        // CheckboxListTile(
        //   title: Text("Audio Only"),
        //   value: isAudioOnly,
        //   onChanged: _onAudioOnlyChanged,
        // ),
        // SizedBox(
        //   height: 14.0,
        // ),
        // CheckboxListTile(
        //   title: Text("Audio Muted"),
        //   value: isAudioMuted,
        //   onChanged: _onAudioMutedChanged,
        // ),
        // SizedBox(
        //   height: 14.0,
        // ),
        // CheckboxListTile(
        //   title: Text("Video Muted"),
        //   value: isVideoMuted,
        //   onChanged: _onVideoMutedChanged,
        // ),

        SizedBox(
          height: 64.0,
          width: double.maxFinite,
          child: ElevatedButton(
            onPressed: () {
              _joinMeeting();
            },
            child: Text(
              "Join Meeting",
              style: TextStyle(color: Colors.white),
            ),
            style: ButtonStyle(
                backgroundColor:
                MaterialStateColor.resolveWith((states) => Colors.orangeAccent)),
          ),
        ),
        SizedBox(
          height: 48.0,
        ),
      ],
    );
  }

  // _onAudioOnlyChanged(bool? value) {
  //   setState(() {
  //     isAudioOnly = value;
  //   });
  // }
  //
  // _onAudioMutedChanged(bool? value) {
  //   setState(() {
  //     isAudioMuted = value;
  //   });
  // }
  //
  // _onVideoMutedChanged(bool? value) {
  //   setState(() {
  //     isVideoMuted = value;
  //   });
  // }

  _joinMeeting() async {
    String? serverUrl = serverText.text.trim().isEmpty ? null : serverText.text;

    // Enable or disable any feature flag here
    // If feature flag are not provided, default values will be used
    // Full list of feature flags (and defaults) available in the README
    Map<FeatureFlagEnum, bool> featureFlags = {
      FeatureFlagEnum.WELCOME_PAGE_ENABLED: false,
    };
    if (!kIsWeb) {
      // Here is an example, disabling features for each platform
      if (Platform.isAndroid) {
        // Disable ConnectionService usage on Android to avoid issues (see README)
        featureFlags[FeatureFlagEnum.CALL_INTEGRATION_ENABLED] = false;
      } else if (Platform.isIOS) {
        // Disable PIP on iOS as it looks weird
        featureFlags[FeatureFlagEnum.PIP_ENABLED] = false;
      }
    }
    // Define meetings options here
    var options = JitsiMeetingOptions(room: roomText.text)
      ..serverURL = serverUrl
      ..subject = subjectText.text
      ..userDisplayName = nameText.text
      ..userEmail = emailText.text
      ..iosAppBarRGBAColor = iosAppBarRGBAColor.text
      ..audioOnly = isAudioOnly
      ..audioMuted = isAudioMuted
      ..videoMuted = isVideoMuted
      ..featureFlags.addAll(featureFlags)


      ..webOptions = {
        "roomName": roomText.text,
        "width": "100%",
        "height": "100%",
        "enableWelcomePage": false,
        "chromeExtensionBanner": null,
        "userInfo": {"displayName": nameText.text}
      };

    debugPrint("JitsiMeetingOptions: $options");
    await JitsiMeet.joinMeeting(
      options,
      listener: JitsiMeetingListener(
          onConferenceWillJoin: (message) {
            debugPrint("${options.room} will join with message: $message");
          },
          onConferenceJoined: (message) {
            debugPrint("${options.room} joined with message: $message");
          },
          onConferenceTerminated: (message) {
            debugPrint("${options.room} terminated with message: $message");
          },
          genericListeners: [
            JitsiGenericListener(
                eventName: 'readyToClose',
                callback: (dynamic message) {
                  debugPrint("readyToClose callback");
                }),
          ]),
    );
  }

  void _onConferenceWillJoin(message) {
    debugPrint("_onConferenceWillJoin broadcasted with message: $message");
  }

  void _onConferenceJoined(message) {
    debugPrint("_onConferenceJoined broadcasted with message: $message");
  }

  void _onConferenceTerminated(message) {
    debugPrint("_onConferenceTerminated broadcasted with message: $message");
  }

  _onError(error) {
    debugPrint("_onError broadcasted: $error");
  }
}