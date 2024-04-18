import 'package:MGMS/api/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CommentsList extends StatefulWidget {
  CommentsList({super.key, required this.comments, required this.slug});
  List<Comment> comments;
  String slug;
  
  State<CommentsList> createState() => _CommentListState();
}

class _CommentListState extends State<CommentsList>{
  @override
  Widget build(BuildContext context) {
    TextEditingController comment_controller = TextEditingController();
    List<Widget> widgets = [];
    for(var comment in widget.comments!){
      widgets.add(_getComments(comment));
    }
    print(widgets);
    widgets.add(CupertinoTextFormFieldRow(controller: comment_controller, placeholder: "Write a comment", onFieldSubmitted: (value) async {
      var damn = await createComment(CommentDTO(content: value), widget.slug);
      if (damn['status_code']==200){
        setState(() {
          widget.comments.add(damn['comment']);
        });
      }
    },));


    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: ExpansionTile(
        leading: Icon(Icons.comment),
        trailing: Text(widget.comments!.length.toString()),
        title: Text("Comments"),
        children: widgets
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