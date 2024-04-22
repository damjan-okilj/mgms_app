import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';

class WeekViewWidget extends StatelessWidget {
  final GlobalKey<WeekViewState>? state;
  final double? width;
  final EventController controller;

  const WeekViewWidget({super.key, this.state, this.width, required this.controller});

  @override
  Widget build(BuildContext context) {
    print(controller.allEvents);
    return WeekView(
      controller: controller,
      key: state,
      width: width,
      showLiveTimeLineInAllDays: true,
      timeLineWidth: 65,
      liveTimeIndicatorSettings: LiveTimeIndicatorSettings(
        color: Colors.redAccent,
        showTime: true,
      ),
      eventTileBuilder: (date, events, boundary, startDuration, endDuration) {
        print(events);
        return Container(child: Text("AAAAAA"),);
      },
      onEventTap: (events, date) {
      },
    );
  }
}