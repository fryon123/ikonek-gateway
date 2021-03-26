
import 'package:flutter/material.dart';
import 'package:sms_maintained/sms.dart';

class IkonekSmsReceiver{
  Function onMessageReceive;
  SmsReceiver smsReceiver;
  IkonekSmsReceiver({this.onMessageReceive})
  {
    smsReceiver = SmsReceiver();
    smsReceiver.onSmsReceived.listen(onMessageReceive);
  }

  void onTimeOut()
  {
    if(smsReceiver == null) return;
  }

}
class IkonekSmsSender {
  Function onMessageSent;
  SmsSender sender;
  IkonekSmsSender({this.onMessageSent})
  {
    sender = SmsSender();
    print("Sms Sender Created.");
  }
  Future sendMessage(message, number, callback) async
  {
    await sender.sendSms(SmsMessage(number, message));
    if(callback != null) callback.call();
  }
}