import 'package:drivers_app/AllScreens/carInfoScreen.dart';
import 'package:drivers_app/components/configMaps.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:drivers_app/Assistants/appData.dart';
import 'AllScreens/mainscreen.dart';
import 'AllScreens/loginScreen.dart';
import 'AllScreens/registrationScreen.dart';
import 'package:provider/provider.dart';
import 'package:drivers_app/AllScreens/searchScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  currentFirebaseUser = FirebaseAuth.instance.currentUser;

  runApp(MyApp());
}

DatabaseReference usersRef =
    FirebaseDatabase.instance.reference().child('users');
DatabaseReference driversRef =
    FirebaseDatabase.instance.reference().child('drivers');
DatabaseReference rideRequestRef = FirebaseDatabase.instance
    .reference()
    .child('drivers')
    .child(currentFirebaseUser.uid)
    .child('newRide');

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(
        initialRoute: FirebaseAuth.instance.currentUser == null
            ? LoginScreen.id
            : MainScreen.id,
        routes: {
          MainScreen.id: (context) => MainScreen(),
          LoginScreen.id: (context) => LoginScreen(),
          RegistrationScreen.id: (context) => RegistrationScreen(),
          SearchScreen.id: (context) => SearchScreen(),
          CarInfoScreen.id: (context) => CarInfoScreen(),
        },
        title: 'Cab It',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: RegistrationScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
