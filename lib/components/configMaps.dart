import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:drivers_app/Assistants/allUsers.dart';
import 'package:geolocator/geolocator.dart';

String apiKey = 'AIzaSyCSIsW63yH11zWrNv87xlFxp9F-CAnmnfE';

User firebaseUser;

Users userCurrentInfo;

User currentFirebaseUser;

StreamSubscription<Position> homeTabPageStreamSubscription;
