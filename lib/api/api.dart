import 'dart:async';
import 'dart:convert';
import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:MGMS/main.dart';

final Config config = Config(
    tenant: '9d26c674-3130-4fe6-a83c-be30f76f331f',
    clientId: 'a73d04b9-6a3e-4221-8017-48234748358b',
    webUseRedirect: false,
    isB2C: false,
    scope: "Mail.Send SMTP.Send User.Read offline_access",
    navigatorKey: navigatorKey);

enum Status { DONE, NOT_DONE, NEEDS_REVIEW, IN_REVIEW, BLOCKED, FINISHED }

class User {
  final String email;
  final String type;
  final String first_name;
  final String last_name;

  const User(
      {required this.email,
      required this.type,
      required this.first_name,
      required this.last_name});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        email: json['email'],
        type: json['type'],
        first_name: json['first_name'],
        last_name: json['last_name']);
  }
}

class Comment {
  final String content;
  final String slug;
  final String timestamp;
  final User created_by;

  const Comment(
      {required this.content,
      required this.slug,
      required this.timestamp,
      required this.created_by});

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
        content: json['content'],
        slug: json['content'],
        timestamp: json['timestamp'],
        created_by: resolve_user(json['created_by']));
  }
}

class Task {
  final String name;
  final String description;
  final List<User> assigned_to;
  final User assigned_by;
  final String due_time;
  final String type;
  final bool canEdit;
  final String slug;
  final List<Comment> comments;

  const Task(
      {required this.name,
      required this.description,
      required this.assigned_to,
      required this.assigned_by,
      required this.due_time,
      required this.type,
      required this.canEdit,
      required this.slug,
      required this.comments});

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
        name: json['name'],
        description: json['description'],
        assigned_by: resolve_user(json['assigned_by']),
        assigned_to: resolve_users_from_list(json['assigned_to']),
        due_time: json['due_time'],
        type: json['type'],
        canEdit: json['can_edit'],
        slug: json['slug'],
        comments: resolve_comments_from_list(json['comments']));
  }
}

class Colorette {
  final String date;
  final String time;
  final String colorette;
  final String colorhex;

  const Colorette(
      {required this.date,
      required this.time,
      required this.colorette,
      required this.colorhex});

  factory Colorette.fromJson(Map<String, dynamic> json) {
    return Colorette(
        date: json['date'],
        time: json['time'],
        colorette: json['colorette'].toString(),
        colorhex: json['colorhex']);
  }
}

class Measure {
  final String date;
  final String slug;
  final List<Colorette> measures;

  const Measure(
      {required this.date, required this.slug, required this.measures});

  factory Measure.fromJson(Map<String, dynamic> json) {
    return Measure(
        date: json['date'],
        slug: json['slug'],
        measures: resolve_measures_from_list(json['measures']));
  }
}

class CreateTaskDTO {
  final String name;
  final String description;
  final List<String> assigned_to;
  final String due_time;
  final String type;

  CreateTaskDTO(
      {required this.name,
      required this.description,
      required this.assigned_to,
      required this.due_time,
      required this.type});

  static Map<String, dynamic> toJson(CreateTaskDTO data) => {
        "name": data.name,
        "description": data.description,
        "assignes": data.assigned_to,
        "due_time": data.due_time,
        "type": data.type
      };
}

class StatusDTO {
  final String type;

  const StatusDTO({required this.type});

  static Map<String, dynamic> toJson(StatusDTO type) => {"type": type.type};
}

List<Colorette> resolve_measures_from_list(map) {
  Iterable i = map;
  return List<Colorette>.from(i.map((e) => Colorette.fromJson(e)));
}

List<User> resolve_users_from_list(map) {
  Iterable i = map;
  return List<User>.from(i.map((e) => User.fromJson(e)));
}

List<Comment> resolve_comments_from_list(map) {
  Iterable i = map;
  return List<Comment>.from(i.map((e) => Comment.fromJson(e)));
}

User resolve_user(user) {
  return User.fromJson(user);
}

Future<List<Measure>> fetchMeasures() async {
  final response =
      await http.get(Uri.parse("http://172.16.63.32:80/colorette/list"));

  if (response.statusCode == 200) {
    var decoded = jsonDecode(response.body);
    Iterable i = (decoded);
    return List<Measure>.from(i.map((e) => Measure.fromJson(e)));
  } else {
    throw Exception("Something went wrong");
  }
}

Future<User> fetchMe() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final response = await http.get(Uri.parse("http://172.16.63.32:80/user/me"),
      headers: {
        "Authorization": "Bearer ${prefs.getString("access_token").toString()}"
      });
  if (response.statusCode == 200) {
    var decode = jsonDecode(response.body);
    return User.fromJson(decode);
  } else {
    throw Exception("Something went wrong");
  }
}

Future<List<User>> fetchUsers() async {
  final response =
      await http.get(Uri.parse("http://172.16.63.32:80/user/users"));
  if (response.statusCode == 200) {
    var decoded = jsonDecode(response.body);
    Iterable i = (decoded);
    return List<User>.from(i.map((e) => User.fromJson(e)));
  } else {
    throw Exception("Something went wrong");
  }
}

Future<List<Task>> fetchTasks() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final response = await http
      .get(Uri.parse("http://172.16.63.32:80/task/tasks"), headers: {
    "Authorization": "Bearer ${prefs.getString("access_token").toString()}"
  });
  if (response.statusCode == 200) {
    var decoded = jsonDecode(response.body);
    Iterable i = (decoded);
    return List<Task>.from(i.map((e) => Task.fromJson(e)));
  } else {
    throw Exception("Something went wrong");
  }
}

Future<String> createTask(CreateTaskDTO data) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final response =
      await http.post(Uri.parse("http://172.16.63.32:80/task/create"),
          headers: {
            "Authorization":
                "Bearer ${prefs.getString("access_token").toString()}",
            "Content-Type": "application/json"
          },
          body: jsonEncode(CreateTaskDTO.toJson(data)));

  if (response.statusCode == 200) {
    return "Created Task";
  } else if (response.statusCode == 403) {
    var decode = jsonDecode(response.body);
    return decode['message'];
  } else {
    var decode = jsonDecode(response.body);
    print(decode);
    return "Something went wrong";
  }
}

Future<String> updateTask(CreateTaskDTO data, String slug) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final response =
      await http.post(Uri.parse("http://172.16.63.32:80/task/edit/${slug}"),
          headers: {
            "Authorization":
                "Bearer ${prefs.getString("access_token").toString()}",
            "Content-Type": "application/json"
          },
          body: jsonEncode(CreateTaskDTO.toJson(data)));

  if (response.statusCode == 200) {
    return "Updated Task";
  } else if (response.statusCode == 403) {
    var decode = jsonDecode(response.body);
    return decode['message'];
  } else {
    return "Something went wrong";
  }
}

Future<String> updateTaskStatus(StatusDTO data, String slug) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final response =
      await http.put(Uri.parse("http://172.16.63.32:80/task/status/${slug}"),
          headers: {
            "Authorization":
                "Bearer ${prefs.getString("access_token").toString()}",
            "Content-Type": "application/json"
          },
          body: jsonEncode(StatusDTO.toJson(data)));
  print(jsonEncode(StatusDTO.toJson(data)));
  if (response.statusCode == 200) {
    return "Updated Task Status";
  } else if (response.statusCode == 401) {
    var decode = jsonDecode(response.body);
    return decode['message'];
  } else {
    return "Something went wrong";
  }
}

Future<String> deleteTask(String slug) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final response = await http.delete(
      Uri.parse("http://172.16.63.32:80/task/delete/${slug}"),
      headers: {
        "Authorization": "Bearer ${prefs.getString("access_token").toString()}",
      });
  if (response.statusCode == 200) {
    return "Task Deleted";
  } else if (response.statusCode == 401) {
    var decode = jsonDecode(response.body);
    return decode['message'];
  } else {
    return "Something went wrong";
  }
}

/*Future login() async {
  var issuer = await Issuer.discover(Uri.parse("https://login.microsoftonline.com/${config.tenant}/v2.0"));
  var client = Client(issuer, config.clientId);
  
  var authenticatior = Authenticator(client, scopes: ['Mail.Send', 'SMTP.Send', 'User.Read', 'offline_access']);
  var c = await authenticatior.credential;
  authenticatior.authorize();
}*/

Future<int> login(BuildContext context) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final AadOAuth oAuth = AadOAuth(config);
  final result = await oAuth.login();
  result.fold(
    (l) => print(l.toString()),
    (r) => print('Logged in successfully, your access token: $r'),
  );
  final access_token = await oAuth.getAccessToken();
  print(access_token);
  var login = await auth(access_token, context);
  if (login['status_code'] == 200) {
    prefs.setBool("loggedIn", true);
    prefs.setString("ROLE", login['role']);
    prefs.setString('access_token', login['access_token']);
    prefs.setString('email', login['email']);
    return 200;
    //navigateToHome(context);
  } else {
    return 500;
  }
}

Future<Map> auth(String? token, BuildContext context) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final response =
      await http.get(Uri.parse("http://172.16.63.32:80/user/login/${token}"));
  if (response.statusCode == 200) {
    var decoded = jsonDecode(response.body);
    print(decoded);
    return {
      'status_code': 200,
      'access_token': decoded['access_token'],
      'role': decoded['role'],
      'email': decoded['email']
    };
  } else {
    print(jsonDecode(response.body));
    return {'status_code': 500};
  }
}

void logout() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.clear();
  prefs.setBool('loggedIn', false);
}
