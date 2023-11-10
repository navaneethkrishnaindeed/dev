import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:encrypt/encrypt.dart';

import '../core/encryption.dart';
import 'secured_shared_preference.dart';

FlutterLocalSecuredStorage securedStorageinstance =
    FlutterLocalSecuredStorage();
login() async {
  Dio dio = Dio();
  try {
    var resp = await dio.post(
      "http://192.168.1.116:65330/api/Admin/Login",
      data: {
        "Value":
            "3xYVSGyvqflu+Tag15r7e1aPKNMJGoh+nxssazvpInJ992XQ08S2fd7egVWVThz+u0mXHu46WSa1wXhHlu0qG78pRyDi17OTmIpd6pJ4QVGuICDBHMdMYmk9cF9J2OqAmCovOaQWSA3DS4mOXkge5A=="
      },
    );
    var decrypt = EncryptionDecryption.decryptAES(Encrypted.from64(resp.data));

    var json = jsonDecode(decrypt);
    var token = json['Token'].toString();

    await securedStorageinstance.write("AUTH_TOKEN", token.toString());
    String newString = token.substring(token.length - 14);
    String last14 = newString;
    await securedStorageinstance.write("KEY", "$last14" "56");

    var iv = reverseString("$last14" "56");

    await securedStorageinstance.write("IV", "$iv");
    log(token.toString());

    String key = await storage.read("KEY");
    String ivv = await storage.read("IV");

    String authToken = await storage.read("AUTH_TOKEN");

    // log("Login Credential Encrypted: ${g.base64}");

    log("AUTH_TOKEN: $authToken");
    //  var dekey=base64.encode(utf8.encode(key));
    //       var de=base64.encode(utf8.encode(key));
    Globalstates.userKey = key;
    Globalstates.userIV = ivv;
    log("KEY : $key");
    log("IV : $ivv");
  } catch (e) {
    log(e.toString());
  }
}

scheduleTrip() async {
  Dio dio = Dio();
  String key = await storage.read("KEY");
  String ivv = await storage.read("IV");

  String authToken = await storage.read("AUTH_TOKEN");
  log(authToken.toString());
  var body =''' {
    "DriverID": "2",
    "From": "Koratty ",
    "FromLocCoordinates": [
      {"Lat": "10.2649", "Lon": "76.3487"}
    ],
    "To": "Applo Angamaly",
    "ToLocCoordinates": [
      {"Lat": "10.1926", "Lon": "76.3869"}
    ],
    "PatientID": "112122",
    "PatientName": "Ann Mery Cheriyan",
    "Phone": "9876543210",
    "Address": "ABC",
    "TripType": "DeathCare",
    "ScheduledDateTime": "2023-09-25T07:00:00",
    "Notes": "Death Care Immediate",
    "AdvanceAmount": 1000
  }''';
  //  var encryptedBody=await EncryptionDecryption.userEncryptAES(body.toString());
  try {
    var encryptedBody =
        await EncryptionDecryption.userEncryptAES(body.toString());
        log(encryptedBody.base64.toString());
    var resp = await dio.post(
        "http://202.88.246.169:49100/api/Driver/Admin/ScheduleAmbulance",
        data: {'Value': encryptedBody.base64},
        options: Options(headers: {'Authorization': 'Bearer $authToken'}));

    

    log('-------------------------------${resp.data.toString()}-------------------------------------------');
  } catch (e) {
    log(e.toString());
  }
  //   var decrypt = EncryptionDecryption.userDecryptAES(Encrypted.from64(resp.data));

  // var json = jsonDecode(decrypt);
  // log(json.toString());
}

String reverseString(String input) {
  String reversed = '';
  for (int i = input.length - 1; i >= 0; i--) {
    reversed += input[i];
  }
  return reversed;
}



initTrip() async {
  Dio dio = Dio();
  String key = await storage.read("KEY");
  String ivv = await storage.read("IV");

  String authToken = await storage.read("AUTH_TOKEN");
  log(authToken.toString());
  var body =''' {
   "IsInstantTrip" : "True",
   "ScheduleID" : "47",
   "Co_ID" : "49",
   "MRN": "112122",
   "Name": "",
   "Phone": "",
   "Address": "",
   "InstantLocation": "Koratty",
   "InstantLocCoordinates": "40.7129,-74.0060",
   "FromLocation": "Chalakkudy",
   "FromLocCoordinates":"40.7129,-74.0060",
   "ToLocation": "Cochin International Airport",
   "ToLocCoordinates" :"40.7129,-74.0060",
   "TripType": "Emergency",
   "StartKM": "100",
   "EndKM": "500",
   "TotalGPSKms":"1000",
   "NeedOxygen": "false",
   "StartTime": "2023-09-27T12:00:00",
   "AdvanceAmount": "1000",
   "TripLocations":
   [  
     {
       "Latitude": "40.7128",
       "Longitude": "-74.0060",
       "EnteredAt": "2023-09-28T11:30:00Z"
     },
     {
       "Latitude": "40.7129",
       "Longitude": "-74.0061",
       "EnteredAt": "2023-09-28T11:31:00Z"
     },
     {
       "Latitude": "40.7130",
       "Longitude": "-74.0062",
       "EnteredAt": "2023-09-28T11:32:00Z"
     }
   ],
   "MapRoutesUsed":
   [  
     { 
        "SearchID" : "001",
        "PolyPoints" : 
         [
            {
               "Latitude": "40.7128",
               "Longitude": "-74.0060",
               "EnteredAt": "2023-09-28T11:30:00Z"
            },
            {
               "Latitude": "40.7129",
               "Longitude": "-74.0061",
               "EnteredAt": "2023-09-28T11:31:00Z"
            },
            {
               "Latitude": "40.7130",
               "Longitude": "-74.0062",
               "EnteredAt": "2023-09-28T11:32:00Z"
            }
        ]
     },
     { 
        "SearchID" : "002",
        "PolyPoints" : 
         [
            {
               "Latitude": "40.7128",
               "Longitude": "-74.0060",
               "EnteredAt": "2023-09-28T11:30:00Z"
            },
            {
               "Latitude": "40.7129",
               "Longitude": "-74.0061",
               "EnteredAt": "2023-09-28T11:31:00Z"
            },
            {
               "Latitude": "40.7130",
               "Longitude": "-74.0062",
               "EnteredAt": "2023-09-28T11:32:00Z"
            }
        ]
     }
   ]
}''';
  //  var encryptedBody=await EncryptionDecryption.userEncryptAES(body.toString());
  try {
    var encryptedBody =
        await EncryptionDecryption.userEncryptAES(body.toString());
        // log(encryptedBody.base64.toString());
    var resp = await dio.post(
        "http://192.168.1.116:65330/api/Driver/PostTripData",
        data: {'Value': encryptedBody.base64},
        options: Options(headers: {'Authorization': 'Bearer $authToken'}));

    

    log('-------------------------------${resp.data.toString()}-------------------------------------------');
  } catch (e) {
    log(e.toString());
  }
  //   var decrypt = EncryptionDecryption.userDecryptAES(Encrypted.from64(resp.data));

  // var json = jsonDecode(decrypt);
  // log(json.toString());
}
