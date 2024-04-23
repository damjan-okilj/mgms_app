import 'package:MGMS/components/week_view_widget.dart';
import 'package:MGMS/enumerations.dart';
import 'package:MGMS/views/calendar_views/calendar_views.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';

class MobilePage extends StatelessWidget {
  final EventController controller;
  MobilePage({super.key, required this.controller});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(width: MediaQuery.of(context).size.width,
      child: CalendarViews(controller: controller),
      )
    );
  }
}