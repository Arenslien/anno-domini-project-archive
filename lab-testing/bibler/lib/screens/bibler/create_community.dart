import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CreateCommunityScreen extends StatefulWidget {
  @override
  _CreateCommunityScreenState createState() => _CreateCommunityScreenState();
}

class _CreateCommunityScreenState extends State<CreateCommunityScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CreateCommunityForm(),
    );
  }
}

class CreateCommunityForm extends StatefulWidget {
  @override
  _CreateCommunityFormState createState() => _CreateCommunityFormState();
}

class _CreateCommunityFormState extends State<CreateCommunityForm> {
  final _formKey = GlobalKey<FormState>();
  String _name;
  String _affliation;
  String _id = "test";
  _postRequest(Uri url, List<dynamic> items) async {
    final msg = jsonEncode(<String, String> {
            'name': items[0],
            'admin_id': items[1],
            'affiliation': items[2], 
        });
    http.Response response = await http.post(
        url,
        headers: <String, String> {
            'Content-Type': 'application/json',
        },
        body: msg,
    );
}


  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "공동체 이름",
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                )
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: InputDecoration(
                  hintText: '도미니언들',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  setState(() {
                    _name = value;
                  });
                  if (value == null || value.isEmpty) {
                    return '공동체 이름을 정해주세요!';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              Text(
                "소속",
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                )
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: InputDecoration(
                  hintText: '중고등부/청년부/동아리',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  setState(() {
                    _affliation = value;
                  });
                  if (value == null || value.isEmpty) {
                    return '소속을 적어주세요!';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0,),
              // Text(
              //   "뭐가 들어가면 좋을까",
              //   style: TextStyle(
              //     fontSize: 30.0,
              //     fontWeight: FontWeight.bold,
              //   )
              // ),
              // SizedBox(height: 20.0),
              // TextFormField(
              //   decoration: InputDecoration(
              //     hintText: '도미니언들',
              //     border: OutlineInputBorder(),
              //   ),
              //   validator: (value) {
              //     return null;
              //   },
              // ),
              // SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  _postRequest(Uri.parse("http://192.168.1.11:3000/create_community"), [_name, _id, _affliation]);
                  print('hi');
                },
                child: Text('공동체 만들기'),
              ),
            ],
          ),
        ),
      )
    );
  }
}