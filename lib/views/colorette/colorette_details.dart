import 'package:MGMS/api/api.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ColoretteDetails extends StatefulWidget {
  final List<Colorette> measures;

  ColoretteDetails({super.key, required this.measures});

  @override
  _ColoretteState createState() => _ColoretteState();
}

class _ColoretteState extends State<ColoretteDetails> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
      child: ListView.builder(
      padding: EdgeInsets.zero,
      primary: false,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: widget.measures.length,
      itemBuilder: (context, index) {
        final measure = widget.measures[index];
        return Padding(
          padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 12),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                blurRadius: 4,
                color: Color(0x32000000),
                offset: Offset(
                  0.0,
                  2,
                ),
              )
            ], borderRadius: BorderRadius.circular(8)),
            child: InkWell(
              onTap: () {},
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: 'color',
                    transitionOnUserGestures: true,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(0),
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                      child: Container(
                        height: 180,
                        width: double.infinity,
                        child: ColoredBox(color: Color(int.parse(measure.colorhex.substring(1,7), radix: 16) + 0xFF000000)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(16, 8, 0, 0),
                    child: Text("Colorette: ${measure.colorette}"),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(16, 8, 0, 0),
                    child: Text("Colorette: ${measure.user_def}"),
                  ),
                  Padding(padding: EdgeInsetsDirectional.fromSTEB(16, 4, 0, 0),
                    child: Text("CIELAB:  L:${measure.L}, A:${measure.a}, B:${measure.b}"),
                  ),
                  Padding(padding: EdgeInsetsDirectional.fromSTEB(16, 4, 0, 0),
                  child: Text("TIME: ${measure.time}"),)
                ],
              ),
            ),
          ),
        );
      },
    )
    ));
  }
}
