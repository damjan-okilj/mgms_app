import 'package:MGMS/components/responsive_widget.dart';
import 'package:MGMS/views/home/mobile_view.dart';
import 'package:MGMS/views/home/web_view.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/cupertino.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key, required this.controller});

  final EventController controller;

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      mobileWidget: MobilePage(controller: controller,),
      webWidget: WebHomePage(controller: controller,),
    );
  }
}