import 'dart:async';

import 'package:drivers_app/Notifications/pushNotifications.dart';
import 'package:drivers_app/components/configMaps.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:drivers_app/AllScreens/registrationScreen.dart';

import '../main.dart';

class HomeTabPage extends StatefulWidget {
  const HomeTabPage({Key key}) : super(key: key);

  @override
  _HomeTabPageState createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController newGoogleMapController;

  Position currentPosition;
  var geoLocator = Geolocator();

  String driverStatusText = "Offline now. Go online.";
  Color driverStatusColour = Colors.black;
  bool isDriverAvailable = false;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentDriver();
  }

  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;
    LatLng latLngposition = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition =
        new CameraPosition(target: latLngposition, zoom: 15);
    newGoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    //String address =
    //    await AssistantMethods.searchCoordinateAddress(position, context);
  }

  void getCurrentDriver() async {
    currentFirebaseUser = await FirebaseAuth.instance.currentUser;
    PushNotificationService pushNotificationService = PushNotificationService();

    pushNotificationService.initialize();
    pushNotificationService.getToken();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          myLocationButtonEnabled: true,
          mapType: MapType.normal,
          initialCameraPosition: _kGooglePlex,
          myLocationEnabled: true,
          onMapCreated: (GoogleMapController controller) {
            _controllerGoogleMap.complete(controller);
            newGoogleMapController = controller;

            locatePosition();
          },
        ),

        //online offline driver container

        Container(
          height: 140,
          width: double.infinity,
          color: Colors.black54,
        ),
        Positioned(
          top: 60.0,
          left: 0.0,
          right: 0.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (isDriverAvailable != true) {
                      makeDriverOnline();
                      getLocationLiveUpdates();
                      setState(() {
                        driverStatusColour = Colors.green;
                        driverStatusText = 'Online Now';
                        isDriverAvailable = true;
                      });
                      displayErrorMessage('You are Online now', context);
                    } else {
                      makeDriverOffline();
                      setState(() {
                        driverStatusColour = Colors.black54;
                        driverStatusText = 'Offline Now. Go Online.';
                        isDriverAvailable = false;
                      });
                      displayErrorMessage('You are Offline now', context);
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(driverStatusText,
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      Icon(
                        Icons.phone_android,
                        color: Colors.white,
                        size: 26.0,
                      )
                    ],
                  ),
                  style: ButtonStyle(
                      elevation: MaterialStateProperty.all(10.0),
                      backgroundColor:
                          MaterialStateProperty.all(driverStatusColour)),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  void makeDriverOnline() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;
    Geofire.initialize('availableDrivers');
    Geofire.setLocation(currentFirebaseUser.uid, currentPosition.latitude,
        currentPosition.longitude);
    rideRequestRef.onValue.listen((event) {});
  }

  void makeDriverOffline() {
    Geofire.removeLocation(currentFirebaseUser.uid);
    rideRequestRef.onDisconnect();
    rideRequestRef.remove();
    rideRequestRef = null;
  }

  void getLocationLiveUpdates() {
    homeTabPageStreamSubscription =
        Geolocator.getPositionStream().listen((Position position) {
      currentPosition = position;
      if (isDriverAvailable == true) {
        Geofire.setLocation(
            currentFirebaseUser.uid, position.latitude, position.longitude);
      }
      LatLng latLng = LatLng(position.latitude, position.longitude);
      newGoogleMapController.animateCamera(CameraUpdate.newLatLng(latLng));
    });
  }
}
