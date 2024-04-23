import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:web_socket_channel/io.dart';

void connect_to_ws(String email, String access_token) {
  FlutterLocalNotificationsPlugin notifications =
      FlutterLocalNotificationsPlugin();
  var androidInit = AndroidInitializationSettings('ic_launcher');
  var channel = IOWebSocketChannel.connect(
      'ws://172.16.63.32:80/ws/notify/${email}',
      headers: {"Authorization": access_token});
  var _message = TextEditingController();
  var init = InitializationSettings(android: androidInit);
  notifications.initialize(init).then((done) => {
        channel.stream.listen((event) {
          notifications.show(
              1,
              "New task",
              json.decode(event)['message'],
              NotificationDetails(
                  android: AndroidNotificationDetails("mgms_0", "MGMS")));
        })
      });
}

DateTime convert_to_dt(String time){
  DateFormat format = DateFormat("dd/MM/yyyy HH:mm:ss");
  DateTime dateTime = format.parse(time);
  print(dateTime);
  return dateTime;
}