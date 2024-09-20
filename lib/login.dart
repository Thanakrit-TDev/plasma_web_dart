import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';


import 'package:plassma/running_trainfromV2.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'package:plassma/testvdo.dart';

// import 'dart:convert';
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Login> {
  final textUser = TextEditingController();
  final textPass = TextEditingController();
  @override
  // void sendlogin(){
  //   final userTextlogin = textUser.text;
  //   final passTextlogin = textPass.text;
  // }

  @override
  Future<void> sendData() async {
    final String t = textUser.text;
    final String a = textPass.text;

    final response = await http.post(
      Uri.parse('http://210.246.215.145:3500/login'),  // Replace with your backend URL 210.246.215.145
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        't': t,
        'a': a,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      // print('Response data: ${responseData['st']}');
      if(responseData['st']){
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const running_trainfrom()));
      }else{
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              // title: Text("Model version $version"),
              content: const SizedBox(
                height: 50,
                width: 200,
                child: Column(
                  children: [
                    Center(
                      child: Row(
                        children: [
                          Icon(Icons.report_problem,color: Colors.amber,),
                          SizedBox(width: 20,),
                          Text("Login Failed",style: TextStyle(fontSize:25),)
                        ]
                        ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } else {
      // throw Exception('Failed to send data');
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const running_trainfrom()));
      
    }
    // Navigator.of(context).push(MaterialPageRoute(builder: (context) => const running_trainfrom()));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 460,
          width: 450,
          decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 211, 211, 211),
                      borderRadius: BorderRadius.circular(
                          15), // Half the width/height to make it circular
                    ),
          child: Column(
            children: [
              const Text("Login",style: TextStyle(color: Colors.black,fontSize: 25,fontFamily: 'Poppins'),),
              const SizedBox(height: 30,),
              SizedBox(
                width: 400,
                child: TextField(
                    controller: textUser,
                  // obscureText: true,
                    decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Username',
                    
                  ),
                ),
              ),
              const SizedBox(height: 30,),
              SizedBox(
                width: 400,
                child: TextField(
                  controller: textPass,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                ),
              ),
              const SizedBox(height: 30,),
              SizedBox(
                width: 400,
                child: CupertinoButton (
                onPressed: sendData,
                color: const Color(0xFF5A67BA),
                // borderRadius: new BorderRadius.circular(30.0),
                child:
                const Text("Login",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white,fontFamily: 'Poppins'),
                  ),
                ),
              ),
              const SizedBox(height: 100,),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 20, // Image radius
                    backgroundImage: AssetImage('images/logo.jpg'),
                  ),
                  SizedBox(width: 30,),
                  Text("Plasma Detection",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600,color: Color(0xFF5A67BA)),)
                ],
              ),
            ],
          ),

        )
      ),
    );
  }
}
