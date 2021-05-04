import 'dart:convert';
import 'dart:io';
import 'package:easy_software_test_4/users/userdetail.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sweetalert/sweetalert.dart';

class UserList extends StatefulWidget {
  UserList({Key key}) : super(key: key);

  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  int id;

  @override
  void initState() {
    super.initState();
    getUsers();
  }

  Future getUsers() async {
    http.Response response = await http.get(
      'https://607e868602a23c0017e8b79e.mockapi.io/api/v1/users',
    );
    var list = json.decode(response.body);
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'User List',
        ),
      ),
      body: FutureBuilder(
          future: getUsers(),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.blue,
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
                ),
              );
            }
            if (snapshot.data.length == 0) {
              return Center(
                child: Text(
                  'No Users',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              );
            } else {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10),
                      child: Card(
                        elevation: 0.7,
                        child: Container(
                          padding: EdgeInsets.all(5),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 16.0,
                              child: ClipRRect(
                                child:
                                    Image.asset(snapshot.data[index]['avatar']),
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                            ),
                            title: Text(snapshot.data[index]['name']),
                            subtitle: Text(snapshot.data[index]['email']),
                            trailing: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => UserDetail(
                                              snapshot.data[index]['id'],
                                              snapshot.data[index]['name'],
                                              snapshot.data[index]['email'],
                                              snapshot.data[index]
                                                  ['phoneNumber'],
                                            )));
                              },
                              child: Icon(
                                Icons.edit,
                                color: Colors.grey,
                                size: 20.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  });
            }
          }),
    );
  }
}
