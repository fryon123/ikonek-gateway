import 'dart:convert';

class IkonekSmsParser{
  IkonekSmsParser();
  Map<int, String> ParseSms(String message)
  {
    Map newMessage = message.split('|').asMap();
    return newMessage;
  }
}