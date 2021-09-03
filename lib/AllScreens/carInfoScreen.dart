import 'package:drivers_app/AllScreens/mainscreen.dart';
import 'package:drivers_app/components/configMaps.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../main.dart';

class CarInfoScreen extends StatelessWidget {
  static const String id = "carInfo";
  TextEditingController carModelTextEditingController = TextEditingController();
  TextEditingController carNumberTextEditingController =
      TextEditingController();
  TextEditingController carColourTextEditingController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 22.0),
            Image(
              image: AssetImage('images/logo.png'),
              width: 300.0,
              height: 250.0,
              alignment: Alignment.center,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(22.0, 22.0, 22.0, 32.0),
              child: Column(
                children: [
                  SizedBox(height: 12.0),
                  Text(
                    'Enter Car Details',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Brand-Bold',
                        fontSize: 24.0),
                  ),
                  SizedBox(height: 24.0),
                  TextField(
                    controller: carModelTextEditingController,
                    decoration: InputDecoration(
                        labelText: 'Car Model',
                        hintText: 'Enter the model of your car',
                        hintStyle:
                            TextStyle(color: Colors.grey, fontSize: 10.0)),
                    style: TextStyle(fontSize: 15.0),
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: carNumberTextEditingController,
                    decoration: InputDecoration(
                        labelText: 'Car Number',
                        hintText: 'Enter your car\'s license plate number',
                        hintStyle:
                            TextStyle(color: Colors.grey, fontSize: 10.0)),
                    style: TextStyle(fontSize: 15.0),
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: carColourTextEditingController,
                    decoration: InputDecoration(
                        labelText: 'Car Colour',
                        hintText: 'What is the colour if your car?',
                        hintStyle:
                            TextStyle(color: Colors.grey, fontSize: 10.0)),
                    style: TextStyle(fontSize: 15.0),
                  ),
                  SizedBox(height: 10.0),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        if (carModelTextEditingController.text.isEmpty) {
                          displayErrorMessage(
                              "Please input car model", context);
                        } else if (carNumberTextEditingController
                            .text.isEmpty) {
                          displayErrorMessage(
                              "Please input license plate number", context);
                        } else if (carColourTextEditingController
                            .text.isEmpty) {
                          displayErrorMessage(
                              "Please input car colour", context);
                        } else {
                          saveDriverCarInfo(context);
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.all(17.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Next',
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 26.0,
                            )
                          ],
                        ),
                      ),
                      style: ButtonStyle(
                          elevation: MaterialStateProperty.all(10.0),
                          backgroundColor:
                              MaterialStateProperty.all(Color(0xff3f50b5))),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      )),
    );
  }

  void saveDriverCarInfo(context) {
    String userId = currentFirebaseUser.uid;

    Map carInfoMap = {
      "car_colour": carColourTextEditingController.text,
      "car_number": carNumberTextEditingController.text,
      "car_model": carModelTextEditingController.text,
    };
    driversRef.child(userId).child("car_details").set(carInfoMap);

    Navigator.pushNamedAndRemoveUntil(context, MainScreen.id, (route) => false);
  }

  displayErrorMessage(String message, BuildContext context) {
    Fluttertoast.showToast(
      timeInSecForIosWeb: 3,
      msg: message,
      backgroundColor: Color(0xffff9800),
      textColor: Colors.white,
    );
  }
}
