import 'package:MGMS/api/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CommentsList extends StatelessWidget {
  CommentsList({super.key, this.comments});
  List<Comment>? comments;
  
  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: ExpansionTile(
        leading: Icon(Icons.comment),
        trailing: Text(comments!.length.toString()),
        title: Text("Comments"),
        children: comments!.map((e) => _getComments(e)).toList()
      )
    );

  }
  
  Widget _getComments(Comment comment){
      return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: double.infinity,
            child:Text(
            comment.timestamp.toString(),
            textAlign: TextAlign.end,
            style: TextStyle(color: Colors.black),
          )),
          Text(
            comment.created_by.email,
            style: TextStyle(color: Colors.black),
          ),
          Text(
            "Comment Content: ${comment.content}",
            textAlign: TextAlign.left,
            style: TextStyle(color: Colors.black)
          ),
          Divider(
            color: Colors.black45,
          ),
        ],
      ),
    );
  }
}