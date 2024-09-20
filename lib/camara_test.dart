import 'package:flutter/material.dart';
import 'dart:async';

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Live Image Update'),
//         ),
//         body: LiveImageWidget(),
//       ),
//     );
//   }
// }

class LiveImageWidget extends StatefulWidget {
  const LiveImageWidget({super.key});

  @override
  _LiveImageWidgetState createState() => _LiveImageWidgetState();
}

class _LiveImageWidgetState extends State<LiveImageWidget> {
  String imageUrl = "http://127.0.0.1:5000/image";
  bool _updating = false;

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(milliseconds: 50), (Timer timer) {
      if (!_updating) {
        _updateImage();
      }
    });
  }

  Future<void> _updateImage() async {
    setState(() {
      _updating = true;
    });
    String newImageUrl = "http://127.0.0.1:5000/image?t=${DateTime.now().millisecondsSinceEpoch}";
    // Preload the next image
    await precacheImage(NetworkImage(newImageUrl), context);
    setState(() {
      imageUrl = newImageUrl;
      _updating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.network(imageUrl),
    );
  }
}
