import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final registerFormKey = GlobalKey<FormState>();
  String username, password;
//获取到插件与原生的交互通道
  static const jumpPlugin = const MethodChannel('com.jzhu.jump/plugin');

  Future<Null> _jumpToNative() async {
    String result = await jumpPlugin.invokeMethod('oneAct');

    print(result);
  }


  Future<Null> _jumpToNativeWithValue() async {

    Map<String, String> map = { "flutter": "这是一条来自flutter的参数" };

    String result = await jumpPlugin.invokeMethod('twoAct', map);

    print(result);
  }

  void registerForm() {
    _jumpToNative();//跳转到原生界面
    // _jumpToNativeWithValue();//跳转到原生界面(带参数)
    registerFormKey.currentState.save();
    print('$username  $password');
    fetchPost();
  }

  fetchPost() async {
    final respone = await http.get('http://192.168.0.142');
    print(respone.body);
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Wechat'),
      ),
      body: Form(
        key: registerFormKey,
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              TextFormField(
                autofocus: false,
                decoration: InputDecoration(
                    labelText: "用户名",
                    hintText: "用户名或邮箱",
                    prefixIcon: Icon(
                      Icons.person,
                      color: Colors.yellow,
                    )),
                onSaved: (value) {
                  username = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: "密码",
                    hintText: "您的登录密码",
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Colors.yellow,
                    )),
                obscureText: true,
                onSaved: (value) {
                  password = value;
                },
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                child: RaisedButton(
                    color: Colors.yellow,
                    // highlightColor: Colors.blue[700],
                    child: Text('登录',
                        style: TextStyle(
                            color: Colors.purpleAccent,
                            fontWeight: FontWeight.bold)),
                    onPressed: registerForm),
              )
            ],
          ),
        ),
      ),
    );
  }
}
