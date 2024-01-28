// ignore_for_file: use_build_context_synchronously
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
// ignore: depend_on_referenced_packages
import 'package:latlong2/latlong.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:untitled/user.dart';
import 'problems.dart';
import 'application.dart';
import 'form.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
//import 'package:localization_i18n_arb/l10n/l10n.dart';


main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(apiKey: 'AIzaSyBKzUeHYJoAvJV5Erw4JFIUcM52JaWG-m4', appId: '1:554234008708:android:11d0ac7e6ee4df5c14ded1'
        , messagingSenderId: '554234008708'	, projectId: 'auth-jaljeevan', storageBucket: 'auth-jaljeevan.appspot.com' ,
    )
  );
  await FirebaseAppCheck.instance.activate();
  runApp(
    const MaterialApp(

    locale: Locale('en'),
    supportedLocales: [
      Locale('en'),
      Locale('ta'),
      Locale('te'),
      Locale('hi')
    ],

    localizationsDelegates: [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    home: MyApp()
    ),
  );
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {
  double $lat = 16.48;
  double $long = 80.69;
  FirebaseAppCheck appCheck = FirebaseAppCheck.instance;

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location is disabled');
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permission denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
    setState(() {
      $lat = position.latitude;
      $long = position.longitude;
    });
  }

  @override
  Widget build(BuildContext context) {
    getCurrentLocation();
    return Scaffold(
      appBar: AppBar(
        title: const Text('BusGo'),
      ),
      body:SlidingUpPanel (
          maxHeight: MediaQuery.of(context).size.height*0.65,
        parallaxEnabled: true,
        parallaxOffset: 0.7,
        body: _map($lat,$long),
        panel: _buildPanel(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
      ),
    );
  }
}


Widget _buildPanel(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(10),
    child: SingleChildScrollView( child:
      Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDragHandle(),
        const SizedBox(height: 15),
        Center(child:
          Column(children:[
            ElevatedButton(
              onPressed: () async {
                GoogleAuthService googleAuthService = GoogleAuthService();
                User? user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  Navigator.push(context,MaterialPageRoute(builder: (context)=> const RForm()));
                  // Navigate to the next screen or perform other actions.
                } else {
                  user = await googleAuthService.signInWithGoogle(context);
                }
              },
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(Size(MediaQuery.of(context).size.width*0.9,60)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                ),
              ),
              child: Text(AppLocalizations.of(context)?.findbus ?? 'find a bus'),
            ),
          ]),
        ), //Raise your problem button

        const Divider(
          thickness: 1,  // Adjust thickness as needed
          color: Colors.grey,
        ),

        const Center(child:
          Column(children:[
            Row( children:[
              Icon(
                Icons.directions_bus_rounded,
                color: Colors.green,
                size: 20.0,
              ),
              Text(
                'Bus goo',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ]),
            Divider(
              thickness: 1,  // Adjust thickness as needed
              color: Colors.grey,
            ),
            Bubble(
              message: 'Hello! How can I help you?',
              isUser: false,
            ),
            Bubble(
              message: 'Can you provide information about bus which goes to vijayawada',
              isUser: true,
            ),
            Bubble(
              message: 'Sure! the bus is running 10 min late and having 30% space ',
              isUser: false,
            ),

            TextField(
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  ),
                ),
              SizedBox(width: 8),


            Divider(
              thickness: 1,  // Adjust thickness as needed
              color: Colors.grey,
            ),
          ]),
        ),//About Water

        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [


          ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProblemListScreen()));
            },
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all(Size(MediaQuery.of(context).size.width*0.35,50)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)
                  )
              ),
            ),
            child:  Text(AppLocalizations.of(context)?.buslist ?? 'Bus List'),
          ),

          SizedBox(width: MediaQuery.of(context).size.width*0.02),

          ElevatedButton(
            onPressed: () async {
              GoogleAuthService googleAuthService = GoogleAuthService();
              User? user = FirebaseAuth.instance.currentUser;

              if (user != null) {
                Navigator.push(context,MaterialPageRoute(builder: (context)=>  UserP(context)));
                // Navigate to the next screen or perform other actions.
              } else {
                user = await googleAuthService.signInWithGoogle(context);
              }
            },
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all(Size(MediaQuery.of(context).size.width*0.35,50)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)
                  )
              ),
            ),
            child: Text(AppLocalizations.of(context)?.userinf ?? 'User Info'),
          ),
           ]
        ),
        const Divider(
          thickness: 1,  // Adjust thickness as needed
          color: Colors.grey,
        ),
         Center(
          child: ElevatedButton(
            onPressed: () {            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.redAccent),
              minimumSize: MaterialStateProperty.all(Size(MediaQuery.of(context).size.width*0.8,50)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)
                  )
              ),
            ),
            child:  const Text('EMERGENCY SOS',selectionColor: Colors.yellow,),
          ),
        ),
      ]),
    ),
  );
}


Widget _buildDragHandle() =>GestureDetector(
  child: Center(
    child: Container(
      width: 50,
      height: 5,
      decoration: const BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.all(Radius.circular(12),)
      ),
    ),
  ),
);


Widget _map(double lat,double long){
  double lat0=lat;
  double long0=long;
  return FlutterMap(
    options: const MapOptions(
      initialCenter: LatLng(16.5012 ,80.6342), // Initial map center
      initialZoom: 15.0, // Initial zoom level
    ),
    children: [
      TileLayer(
        urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
      ),
    const MarkerLayer(
      markers: [
      Marker(
        width: 40.0,
        height: 40.0,
        point: LatLng(16.5012 ,80.6342),
        child: Icon(
            Icons.location_history_rounded,
            color: Colors.blue,
            size: 25.0,
          ),
        ),
        Marker(
          width: 40.0,
          height: 40.0,
          point: LatLng(16.4947 ,80.6279),
          child: Icon(
            Icons.directions_bus_sharp,
            color: Colors.green,
            size: 30.0,
          ),
        ),
        Marker(
          width: 40.0,
          height: 40.0,
          point: LatLng(16.4987 ,80.639),
          child: Icon(
            Icons.directions_bus_sharp,
            color: Colors.green,
            size: 30.0,
          ),
        ),
        Marker(
          width: 40.0,
          height: 40.0,
          point: LatLng(16.4997 ,80.6374),
          child: Icon(
            Icons.directions_bus_sharp,
            color: Colors.green,
            size: 30.0,
          ),
        ),
      ],
     ),

  ]);
}


class GoogleAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User?> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn
          .signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential authResult = await _auth.signInWithCredential(
            credential);
        final User? user = authResult.user;

        return user;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error signing in with Google: $e"),
        ),
      );
      return null;
    }
    return null;
  }
}

class Bubble extends StatelessWidget {
  final String message;
  final bool isUser;

  const Bubble({Key? key, required this.message, required this.isUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isUser ? Colors.blue : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        message,
        style: TextStyle(
          color: isUser ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}