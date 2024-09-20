import 'package:flutter/material.dart';

// void main() {
//   runApp(MyApp());
// }

// class Qrtest extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         home: Scaffold(
//       body: Scrollbar(
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               Container(width: 50, height: 500, color: Colors.amber),
//               SizedBox(height: 50),
//               Container(width: 50, height: 500, color: Colors.amber),
//               SizedBox(height: 50),
//               Container(width: 50, height: 500, color: Colors.amber),
//               SizedBox(height: 50),
//               Container(width: 50, height: 500, color: Colors.amber),
//               SizedBox(height: 50),
//               Container(width: 50, height: 500, color: Colors.amber),
//               SizedBox(height: 50),
//             ],
//           ),
//         ),
//       ),
//     ));
//   }
// }

// class Qrtest extends StatelessWidget {

//   ScrollController _controller = ScrollController();


//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         body: Material( // Wrap with Material widget
//           child: Scrollbar(

//             controller: _controller,
            
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   Container(width: 50, height: 500, color: Colors.amber),
//                   SizedBox(height: 50),
//                   Container(width: 50, height: 500, color: Colors.amber),
//                   SizedBox(height: 50),
//                   Container(width: 50, height: 500, color: Colors.amber),
//                   SizedBox(height: 50),
//                   Container(width: 50, height: 500, color: Colors.amber),
//                   SizedBox(height: 50),
//                   Container(width: 50, height: 500, color: Colors.amber),
//                   SizedBox(height: 50),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

class Qrtest extends StatelessWidget {
  const Qrtest({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Scrollbar Sample')),
        body: const ScrollbarExample(),
      ),
    );
  }
}

class ScrollbarExample extends StatelessWidget {
  const ScrollbarExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      // child: Container(
      //   child: Column(children: [
      //     Container(height: 300,width: 300,color: Colors.amberAccent,),
      //     Container(height: 300,width: 300,color: const Color.fromARGB(255, 255, 64, 64),),
      //     Container(height: 300,width: 300,color: Colors.amberAccent,),
      //     Container(height: 300,width: 300,color: const Color.fromARGB(255, 255, 64, 64),)
      //   ],),
      // ),
      child: GridView.builder(
        primary: true,
        itemCount: 6,
        gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder:(BuildContext context, int index) {
          return Center(
            child: Container(width: 400,height: 450,color: Colors.amber,)
          );
        },
      ),
    );
  }
}
