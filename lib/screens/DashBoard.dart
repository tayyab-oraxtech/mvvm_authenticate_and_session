import 'dart:convert';

import 'package:flash_chat/UserProvider.dart';
import 'package:flash_chat/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      appBar: AppBar(
        title: Text("View & Edit Post"),
        elevation: 0.1,
      ),
      body: Center(
        child: FutureBuilder<List<Post>>(
          future: fetchPost(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Post> posts = snapshot.data;
              return ListView(
                children: posts
                    .map((post) => Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "userId : ${post.userId}",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            Text("id : ${post.id}",
                                style: TextStyle(
                                    fontSize: 15, fontStyle: FontStyle.italic)),
                            Text("title  : ${post.title}",
                                style: TextStyle(
                                  fontSize: 12,
                                )),
                            Text("body  : ${post.body}",
                                style: TextStyle(
                                  fontSize: 10,
                                )),
                            new Divider()
                          ],
                        ))
                    .toList(),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return new CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}

/*
{
    "userId": 1,
    "id": 1,
    "title": "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
    "body": "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto"
  },
List users = json.decode(response.body);
    return users.map((user) => User.fromJson(user)).toList();
 */
Future<List<Post>> fetchPost() async {
  final responce = await http.get("https://jsonplaceholder.typicode.com/posts");
  if (responce.statusCode == 200) {
    List posts = json.decode(responce.body);
    return posts.map((post) => Post.fromJson(post)).toList();

  } else {
    throw Exception('Failed to load posts');
  }
}

class Post {
  final int userId;
  final int id;
  final String title;
  final String body;

  Post({this.userId, this.id, this.title, this.body});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
        userId: json['userId'],
        id: json['id'],
        title: json['title'],
        body: json['body']);
  }
}
