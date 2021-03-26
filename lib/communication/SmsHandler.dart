import 'package:sms_gateway/communication/sms.dart';
import 'package:sms_gateway/utils/parser.dart';
import 'package:sms_maintained/sms.dart';
class IKonekEventHandler{
  List<Function> listeners = [];
  IKonekEventHandler(){}
  void listen({callback})
  {
    listeners.add(callback);
  }

}
class SmsHandler {
  IKonekEventHandler onRegisterSuccessful = IKonekEventHandler();

  IkonekSmsReceiver receiverComponent;
  IkonekSmsSender senderComponent;
  IkonekSmsParser parserComponent;
  Map<String, String> responses = {
    "invalid": "Sorry, you've entered an invalid keyword. Type HELP for help.",
    "help1": "Welcome to I-konek! We aim to bring the convenience of remote job",
    "help2": " finding to everyone. Regardless of where they are. To Register, type REGISTER |Name|Number|Bio|Address|Skills",
    "help3":"Example: REGISTER John Bartolome|091234567123|I am john bartolome, a construction worker|Brgy. Cannery Site|",
    "help4": "mowing,driving,programming and send it to this number.",
    "reginvalid":
        "There's something wrong with your registration. Are you sure you've correctly followed the format?",
    "regsuccess":
        "Welcome to I-konek! You are now a member of this service. Type EDIT to edit your profile.",
    "regprocessing": "We are now handling your registration. You should receive a message shortly.",
    "hire": "Hi! <Employer Name> wants to hire you. Message <Employer Name> with this number: <Employer CP Number>"
  };

  SmsHandler() {
    receiverComponent = IkonekSmsReceiver(onMessageReceive: handleMessages);
    parserComponent = IkonekSmsParser();
    senderComponent = IkonekSmsSender();
    print("SMS Handler Initialized.");
  }
  Future onHireReceived(body) async{
    var splitString = body['notification']['body'].split("~");
    print("HIRE RECEIVED: " + splitString[0]);
    await senderComponent.sendMessage(buildOnHireMessage(splitString[1]),splitString[0], null);
  }
  String buildOnHireMessage(usernamne)
  {
    String message =  "Hi! $usernamne wants to hire you. Message $usernamne with this number: <12345677>(just a mock up number)";
    return message;
  }
  Future onSuccessRegistration(number) async
  {
    print("Register Success. Sending now: "+ number);
    senderComponent.sendMessage(responses["regsuccess"], number, null);
  }
  void handleMessages(SmsMessage smsMessage) {
    String firstcommand = smsMessage.body.split(" ").length > 1 ? smsMessage.body.split(" ")[0] : smsMessage.body;
    switch (firstcommand) {
      case "REGISTER":

        Map<int, dynamic> data = Map.of(parserComponent.ParseSms(
            smsMessage.body.replaceRange(0, firstcommand.length, "")));
        print(data.length);
        if (data[0] != "" &&
            data[1] != "" &&
            data[2] != "" &&
            data[3] != "" &&
            (data.length == 5) == false) break;
        senderComponent.sendMessage(responses["regprocessing"], smsMessage.address, null);
        print(data);
        data[5] = smsMessage.address.toString();
        onRegisterSuccessful.listeners.forEach((element) {
          print(element);
          element.call(data);
        });
        break;
      case "HELP":
        senderComponent.sendMessage(responses["help1"], smsMessage.address, (){
          senderComponent.sendMessage(responses["help2"], smsMessage.address, (){
            senderComponent.sendMessage(responses["help3"], smsMessage.address, (){
              senderComponent.sendMessage(responses["help4"], smsMessage.address, null);
            });
          });
        });
        break;
      case "EDIT":
        senderComponent.sendMessage("Oops! This feature will be coming soon. :(", smsMessage.address, null);
        break;
      default:
        senderComponent.sendMessage(responses["invalid"], smsMessage.address, null);
        break;
    }
  }
}
