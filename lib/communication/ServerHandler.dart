import 'dart:convert';

import 'package:http/http.dart';
import 'package:sms_gateway/communication/servercommunicator.dart';
import 'package:sms_gateway/communication/sms.dart';
import 'package:sms_gateway/firebase/cloudmessaging.dart';
import 'package:sms_gateway/utils/parser.dart';
import 'package:sms_maintained/sms.dart';

import 'SmsHandler.dart';

class ServerHandler {
  IKonekEventHandler onUserRegisterSuccess = IKonekEventHandler();
  IKonekEventHandler onHireCommandReceived = IKonekEventHandler();
  CloudCommunication _cloudCommunication;
  ServerCommunicator serverCommunicator = ServerCommunicator("https://clean-fishy-honeydew.glitch.me");

  void registerUser(data, {onSuccess}) async {
    print("RegisterUser Called.");
    String name = data[0];
    String bio = data[2];
    String address = data[3];
    String number = data[1];
    String skills = data[4];

    await serverCommunicator.post("/users/add", {
      'name': name,
      'bio': bio,
      'address': address,
      'number': number,
      'skills': skills
    }, (Response e) {
      var json = jsonDecode(e.body);
      print(json);
      if (json['status'] == "Well Done.")
        onUserRegisterSuccess.listeners.forEach((element) {
          print("Reg Success. Calling Every Listeners.");
          element.call(data[5]);
        });
    });
  }

  ServerHandler() {
    _cloudCommunication = CloudCommunication((message) {
      print(message);
      onHireCommandReceived.listeners.forEach((element) {
        print(element);
        element.call(message);
      });
    });

  }
}
