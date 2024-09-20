import 'package:flutter/material.dart';

class Dashboard_Widget extends StatefulWidget {
  const Dashboard_Widget({super.key});
  @override
  State<Dashboard_Widget> createState() => _Dashboard_Widget();
}

class _Dashboard_Widget extends State<Dashboard_Widget> {
  Widget test() {
    return const Text("kuy");
  }

  String i = "6677";

  @override
  Widget build(BuildContext context) {
    return render_model_new(i);
  }

  Widget render_model_new(String i) {
    return SizedBox(
      child: Row(children: [
          test()
      ],),
    );
  }
}
