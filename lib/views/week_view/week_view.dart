import 'package:MGMS/components/responsive_widget.dart';
import 'package:MGMS/components/week_view_widget.dart';
import 'package:MGMS/enumerations.dart';
import 'package:MGMS/views/home/web_view.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WeekView extends StatefulWidget {
  const WeekView({super.key, required this.controller});
  final EventController controller;

  @override
  _WeekViewDemoState createState() => _WeekViewDemoState();
}

class _WeekViewDemoState extends State<WeekView> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      webWidget: WebHomePage(
        controller: widget.controller,
        selectedView: CalendarView.week,
      ),
      mobileWidget: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          elevation: 8,
          onPressed: () => {}//context.pushRoute(CreateEventPage()),
        ),
        body: WeekViewWidget(controller: widget.controller,),
      ),
    );
  }
}