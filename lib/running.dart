import 'package:flutter/material.dart';
import 'package:flutter_side_menu/flutter_side_menu.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:async';

// void main() => runApp(MyApp());
class running extends StatelessWidget {
  const running({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
  // @override
  // _ImageFetcherState createState() => _ImageFetcherState();
}

enum Options { option1, option2, option3, option4 }

class listModels {
  List<Model> setListmodel() {
    final List<Model> models = List.generate(
      10,
      (index) => Model(
          name: 'Model $index',
          version: '${index + 1.0}.0',
          rate: '${index + 80}%'),
    );
    return models;
  }
}

class _MyHomePageState extends State<MyHomePage> {
  bool _showFirstWidget = true;
  Options _selectedOption = Options.option1;
  void _toggleWidget() {
    setState(() {
      _showFirstWidget = !_showFirstWidget;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          child: Row(
            children: [
              Image.asset("images/logo.jpg",
                  width: 30, height: 30, fit: BoxFit.fill),
              const Text(
                "Plama detection",
                style: TextStyle(
                    color: Color.fromARGB(255, 151, 88, 253),
                    fontFamily: 'Poppins',
                    fontSize: 15),
              ),
            ],
          ),
        ),
        // title: Text('Plama detection'),
      ),
      body: Center(
        child: Row(
          children: <Widget>[
            SideMenu(
              backgroundColor: const Color.fromARGB(255, 231, 231, 231),
              builder: (data) => SideMenuData(
                header: const Column(
                  children: [
                    SizedBox(
                      height: (30),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        // color: Color.fromARGB(255, 255, 37, 37),
                        // width: 100,
                        height: 30,
                        child: Center(
                          child: Text(
                            "  Menu",
                            style:
                                TextStyle(fontSize: 18, fontFamily: 'Poppins'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                items: [
                  SideMenuItemDataTile(
                    highlightSelectedColor: const Color.fromARGB(255, 255, 255, 255),
                    hoverColor: const Color.fromARGB(255, 156, 156, 156),
                    isSelected: false,
                    onTap: () {
                      setState(() {
                        _selectedOption = Options.option1;
                      });
                    },
                    title: '   Running',
                    icon: const Icon(Icons.run_circle),
                    // icon: Image.asset("images/arrows.png")
                  ),
                  SideMenuItemDataTile(
                    highlightSelectedColor: Colors.white,
                    hoverColor: const Color.fromARGB(255, 156, 156, 156),
                    isSelected: false,
                    onTap: () {
                      setState(() {
                        _selectedOption = Options.option2;
                      });
                    },
                    title: '   Dashboard',
                    icon: const Icon(Icons.home),
                  ),
                  SideMenuItemDataTile(
                    highlightSelectedColor: Colors.white,
                    hoverColor: const Color.fromARGB(255, 156, 156, 156),
                    isSelected: false,
                    onTap: () {
                      setState(() {
                        _selectedOption = Options.option3;
                      });
                    },
                    title: '   Train',
                    icon: const Icon(Icons.settings),
                  ),
                  SideMenuItemDataTile(
                    highlightSelectedColor: Colors.white,
                    hoverColor: const Color.fromARGB(255, 156, 156, 156),
                    isSelected: false,
                    onTap: () {
                      setState(() {
                        _selectedOption = Options.option4;
                      });
                    },
                    title: '   Data Center',
                    icon: const Icon(Icons.dataset),
                  ),
                ],
                // footer: const Text('Footer'),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                child: Center(
                  child: Column(
                    children: [
                      if (_selectedOption == Options.option1)
                        const Running_Widget()
                      else if (_selectedOption == Options.option2)
                        Dashboard_Widget()
                      else if (_selectedOption == Options.option3)
                        const Train_Widget()
                      else
                        const DataCenter_Widget(), // Add a default case to handle other options
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Running_Widget extends StatefulWidget {
  const Running_Widget({super.key});


  // bool initialBoolean;
  // Running_Widget({required this.initialBoolean});

  @override
  State<Running_Widget> createState() => _Running_WidgetState();
}

class _Running_WidgetState extends State<Running_Widget> {
  // get image zone ---------------------------------------------------------------------
  String imageUrl = "http://127.0.0.1:5000/image";
  String imageUrl_qr = "http://127.0.0.1:5000/image_qr";
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
    if (!mounted) return;
    setState(() {
      _updating = true;
    });

    String newImageUrl = "http://127.0.0.1:5000/image?t=${DateTime.now().millisecondsSinceEpoch}";
    await precacheImage(NetworkImage(newImageUrl), context);

    String newimageurlQr = "http://127.0.0.1:5000/image_qr?t=${DateTime.now().millisecondsSinceEpoch}";
    await precacheImage(NetworkImage(newimageurlQr), context);
    // String newImageUrl = "http://127.0.0.1:5000/image";
    // await precacheImage(NetworkImage(newImageUrl), context);
    // String newImageUrl_qr = "http://127.0.0.1:5000/image_qr";
    // await precacheImage(NetworkImage(newImageUrl_qr), context);
    // DateTime.now().millisecondsSinceEpoch;

    if (!mounted) return;
    setState(() {
      imageUrl = newImageUrl;
      // print(imageUrl);
      imageUrl_qr = newimageurlQr;
      // print(imageUrl_qr);
      _updating = false;
    });
  }
  // get image zone --------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData = [
      ChartData(
        'David',
        100,
      ),
      ChartData(
        'Steve',
        90,
      ),
    ];

    final List<Model> models = List.generate(
      10,
      (index) => Model(
          name: 'Model $index',
          version: '${index + 1.0}.0',
          rate: '${index + 80}%'),
    );

    final List<Hislist> Historylist = List.generate(
      10,
      (index) => Hislist(
          name: 'name number $index',
          set_hight: '${index + 10}',
          set_Diameter: '${index + 20}',
          set_px_mm: '${index + 30}'),
    );

    void changeStateModelversion(String version) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Model version $version"),
            content: SizedBox(
              height: 300,
              width: 300,
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Model in computer"),
                      Icon(
                        Icons.circle,
                        size: 15,
                        color: Colors.green,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(onPressed: () {}, child: const Text("Download")),
                      ElevatedButton(onPressed: () {}, child: const Text("Use model"))
                    ],
                  )
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

    void changeStateSetting() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Load History"),
            content: SizedBox(
              height: 300,
              width: 800,
              child: Column(
                children: [
                  // Wrapping ListView.builder in an Expanded widget
                  Expanded(
                    child: ListView.builder(
                      itemCount: Historylist.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            ListTile(
                              title: Row(
                                children: [
                                  Text(Historylist[index].name),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                      "Height ${Historylist[index].set_hight}"),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                      "Diameter ${Historylist[index].set_Diameter}"),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text("px/mm ${Historylist[index].set_px_mm}"),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  ElevatedButton(
                                      onPressed: () {}, child: const Text('Use')),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  ElevatedButton(
                                      onPressed: () {}, child: const Text('Delete')),
                                ],
                              ),
                            ),
                            const Divider(color: Colors.black),
                          ],
                        );
                      },
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

    Size windowSize = MediaQuery.of(context).size;
    // int windowWidth = (windowSize.width).toInt();
    int windowHight = (windowSize.height).toInt();

    // int resize

    // print("windows size : $windowSize");
    // print("windowWidth size : $windowWidth");
    // print("windowHight size : $windowHight");
 

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: 400,
              height: 450,
              color: const Color.fromARGB(255, 255, 255, 255),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    "Running",
                    style: TextStyle(fontSize: 20),
                  ),
                  Container(
                    width: 400,
                    height: 400,
                    color: const Color.fromARGB(255, 211, 211, 211),
                    child: Column(
                      children: [
                        Image.network(imageUrl,
                          width: 400, 
                          height: 400,
                          fit: BoxFit.cover,),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              width: 400,
              height: 450,
              color: const Color.fromARGB(255, 255, 255, 255),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    "Running",
                    style: TextStyle(fontSize: 20),
                  ),
                  Container(
                    width: 400,
                    height: 400,
                    color: const Color.fromARGB(255, 211, 211, 211),
                    child: Column(
                      children: [
                        Image.network(imageUrl_qr,
                          width: 400, 
                          height: 400,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              width: 400,
              height: 450,
              color: const Color.fromARGB(255, 255, 255, 255),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    "Command",
                    style: TextStyle(fontSize: 20),
                  ),
                  Container(
                    width: 400,
                    height: 400,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 211, 211, 211),
                      borderRadius: BorderRadius.circular(
                          15), // Half the width/height to make it circular
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("50.rotate +1 | finish"),
                        // TextField(
                        //   keyboardType: TextInputType.multiline,
                        //   maxLines: null,
                        // )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
        const SizedBox(
          height: 50,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: 400,
              height: 450,
              color: const Color.fromARGB(255, 255, 255, 255),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Training Rate",
                        style: TextStyle(fontSize: 20, fontFamily: 'Poppins'),
                      ),
                    ],
                  ),
                  Container(
                    child: Column(
                      children: [
                        Container(
                          width: 350,
                          height: 350,
                          color: const Color.fromARGB(255, 255, 255, 255),
                          child: Stack(
                            children: [
                              Container(
                                width: 350,
                                height: 350,
                                color: const Color.fromARGB(255, 255, 255, 255),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Image.asset("images/canvas.png",
                                        fit: BoxFit.fill),
                                  ],
                                ),
                              ),
                              const Positioned(
                                left: 100, // ระบุค่าพิกัด x
                                top: 100, // ระบุค่าพิกัด y
                                child: Text(
                                  "1.1.0",
                                  style: TextStyle(
                                      fontSize: 25,
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      fontFamily: 'Poppins'),
                                ),
                              ),
                              const Positioned(
                                left: 70, // ระบุค่าพิกัด x
                                top: 140, // ระบุค่าพิกัด y
                                child: Text(
                                  "Model version",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      fontFamily: 'Poppins'),
                                ),
                              ),
                              const Positioned(
                                left: 200, // ระบุค่าพิกัด x
                                top: 150, // ระบุค่าพิกัด y
                                child: Text(
                                  "001%",
                                  style: TextStyle(
                                      fontSize: 40,
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      fontFamily: 'Poppins'),
                                ),
                              ),
                              const Positioned(
                                left: 230, // ระบุค่าพิกัด x
                                top: 200, // ระบุค่าพิกัด y
                                child: Text(
                                  "MSE",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      fontFamily: 'Poppins'),
                                ),
                              ),
                              const Positioned(
                                left: 55, // ระบุค่าพิกัด x
                                top: 240, // ระบุค่าพิกัด y
                                child: Text(
                                  "99%",
                                  style: TextStyle(
                                      fontSize: 25,
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      fontFamily: 'Poppins'),
                                ),
                              ),
                              const Positioned(
                                left: 30, // ระบุค่าพิกัด x
                                top: 280, // ระบุค่าพิกัด y
                                child: Text(
                                  "Performance",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      fontFamily: 'Poppins'),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 400,
              height: 450,
              color: const Color.fromARGB(255, 255, 255, 255),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Model version",
                    style: TextStyle(fontSize: 20, fontFamily: 'Poppins'),
                  ),
                  const Text(
                    "List all model in record",
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Poppins',
                        color: Color.fromARGB(255, 56, 56, 56)),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: 400,
                    height: 350,
                    color: const Color.fromARGB(255, 255, 255, 255),
                    child: ListView.builder(
                      itemCount: models
                          .length, // replace `models` with your data source
                      itemBuilder: (context, index) {
                        return ListTile(
                            title: Row(
                              children: [
                                Container(
                                    width: 40,
                                    height: 40,
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image: AssetImage(
                                                "images/ai.png")))),
                                const SizedBox(
                                  width: 30,
                                ),
                                Text(models[index].version),
                                const SizedBox(
                                  width: 100,
                                ),
                                Text("Rate ${models[index].rate}"),
                                const SizedBox(
                                  width: 30,
                                ),
                                IconButton(
                                    onPressed: () => changeStateModelversion(
                                        models[index].version),
                                    icon: const Icon(Icons.arrow_forward_ios))
                              ],
                            ),
                            subtitle: const Divider(color: Colors.black));
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 400,
              height: 450,
              color: const Color.fromARGB(255, 255, 255, 255),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Setting",
                      style: TextStyle(fontSize: 20, fontFamily: 'Poppins'),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Setting Name : kuytest"),
                          const SizedBox(
                            width: 50,
                          ),
                          ElevatedButton(
                              onPressed: changeStateSetting,
                              child: const Row(
                                children: [Text("Load History")],
                              ))
                        ],
                      ),
                    ),
                    const Divider(color: Colors.black),
                    Container(
                      child: const Row(
                        children: [
                          Text("Tube Hight"),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 300,
                            child: TextField(),
                          ),
                          ElevatedButton(onPressed: () {}, child: const Text("Save"))
                        ],
                      ),
                    ),
                    Container(
                      child: const Row(
                        children: [
                          Text("Tube Diameter"),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 300,
                            child: TextField(),
                          ),
                          ElevatedButton(onPressed: () {}, child: const Text("Save"))
                        ],
                      ),
                    ),
                    Container(
                      child: const Row(
                        children: [
                          Text("px : mm"),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 140,
                            child: TextField(),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          const SizedBox(
                            width: 140,
                            child: TextField(),
                          ),
                          ElevatedButton(onPressed: () {}, child: const Text("Save"))
                        ],
                      ),
                    ),
                  ]),
            )
          ],
        ),
      ],
    );
  }
}

class Dashboard_Widget extends StatelessWidget {
  @override
  final List<Model> modelsV2 = List.generate(
    10,
    (index) => Model(
        name: 'Model $index',
        version: '${index + 1.0}.0',
        rate: '${index + 80}%'),
  );

  Dashboard_Widget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          width: 920,
          height: 900,
          color: const Color.fromARGB(255, 222, 240, 121),
          child: Column(
            children: [
              Container(
                height: 450,
                width: 920,
                color: const Color.fromARGB(255, 255, 255, 255),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Dashboard",
                      style: TextStyle(fontSize: 20, fontFamily: 'Poppins'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Detecttion lost",
                              style: TextStyle(
                                  fontSize: 15, fontFamily: 'Poppins')),
                          ElevatedButton(
                              onPressed: () {},
                              child: const Text(
                                "View report",
                                style: TextStyle(color: Color(0xFF5A6ACF)),
                              )),
                        ],
                      ),
                    ),
                    const Text(
                      "3 / 15",
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600),
                    ),
                    Container(
                      child: const Row(
                        children: [
                          Icon(
                            Icons.arrow_upward,
                            color: Colors.green,
                            size: 15,
                          ),
                          Text(
                            "20 %",
                            style: TextStyle(
                                color: Colors.green,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Poppins'),
                          ),
                          Text(
                            " vs last week",
                            style: TextStyle(fontFamily: 'Poppins'),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 250, // cari++++++++
                      child: SfCartesianChart(
                          primaryXAxis: const CategoryAxis(),
                          primaryYAxis: const NumericAxis(
                              minimum: 0, maximum: 100, interval: 25),
                          series: <CartesianSeries<ChartData, String>>[
                            ColumnSeries<ChartData, String>(
                              dataSource: [
                                // Bind data source
                                ChartData('01', 35),
                                ChartData('02', 28),
                                ChartData('03', 34),
                                ChartData('04', 32),
                                ChartData('05', 40),
                                ChartData('06', 35),
                                ChartData('07', 28),
                                ChartData('08', 34),
                                ChartData('09', 32),
                                ChartData('10', 40),
                                ChartData('11', 32),
                                ChartData('12', 40),
                              ],
                              xValueMapper: (ChartData data, _) => data.x,
                              yValueMapper: (ChartData data, _) => data.y,
                              name: 'Series 1',
                              color: const Color(0xFF5A6ACF),
                            ),
                            ColumnSeries<ChartData, String>(
                              dataSource: [
                                // Bind data source
                                ChartData('01', 35),
                                ChartData('02', 28),
                                ChartData('03', 34),
                                ChartData('04', 32),
                                ChartData('05', 40),
                                ChartData('06', 35),
                                ChartData('07', 28),
                                ChartData('08', 34),
                                ChartData('09', 32),
                                ChartData('10', 40),
                                ChartData('11', 32),
                                ChartData('12', 40),
                              ],
                              xValueMapper: (ChartData data, _) => data.x,
                              yValueMapper: (ChartData data, _) => data.y,
                              name: 'Series 2',
                              color: const Color.fromARGB(0, 22, 243, 29),
                            ),
                            ColumnSeries<ChartData, String>(
                              dataSource: [
                                // Bind data source
                                ChartData('01', 5),
                                ChartData('02', 56),
                                ChartData('03', 70),
                                ChartData('04', 88),
                                ChartData('05', 75),
                                ChartData('06', 5),
                                ChartData('07', 28),
                                ChartData('08', 34),
                                ChartData('09', 8),
                                ChartData('10', 89),
                                ChartData('11', 56),
                                ChartData('12', 69),
                              ],
                              xValueMapper: (ChartData data, _) => data.x,
                              yValueMapper: (ChartData data, _) => data.y,
                              name: 'Series 1',
                              color: const Color(0xFFF2383A),
                            ),
                          ]),
                    ),
                    Container(
                      child: const Row(
                        children: [
                          Icon(
                            Icons.circle,
                            color: Color(0xFF5A6ACF),
                            size: 20,
                          ),
                          Text(" This Week"),
                          SizedBox(
                            width: 50,
                          ),
                          Icon(
                            Icons.circle,
                            color: Color(0xFFF2383A),
                            size: 20,
                          ),
                          Text(" Last Week"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 450,
                width: 920,
                color: const Color.fromARGB(255, 200, 202, 201),
                child: Row(
                  children: [
                    Container(
                      height: 450,
                      width: 460,
                      color: const Color.fromARGB(255, 255, 255, 255),
                      child: Column(
                        children: [
                          Container(
                            width: 400,
                            height: 450,
                            color: const Color.fromARGB(255, 255, 255, 255),
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Training Rate",
                                      style: TextStyle(
                                          fontSize: 20, fontFamily: 'Poppins'),
                                    ),
                                  ],
                                ),
                                Container(
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 350,
                                        height: 350,
                                        color:
                                            const Color.fromARGB(255, 255, 255, 255),
                                        child: Stack(
                                          children: [
                                            Container(
                                              width: 350,
                                              height: 350,
                                              color: const Color.fromARGB(
                                                  255, 255, 255, 255),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Image.asset(
                                                      "images/canvas.png",
                                                      fit: BoxFit.fill),
                                                ],
                                              ),
                                            ),
                                            const Positioned(
                                              left: 100, // ระบุค่าพิกัด x
                                              top: 100, // ระบุค่าพิกัด y
                                              child: Text(
                                                "1.1.0",
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    color: Color.fromARGB(
                                                        255, 255, 255, 255),
                                                    fontFamily: 'Poppins'),
                                              ),
                                            ),
                                            const Positioned(
                                              left: 70, // ระบุค่าพิกัด x
                                              top: 140, // ระบุค่าพิกัด y
                                              child: Text(
                                                "Model version",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Color.fromARGB(
                                                        255, 255, 255, 255),
                                                    fontFamily: 'Poppins'),
                                              ),
                                            ),
                                            const Positioned(
                                              left: 200, // ระบุค่าพิกัด x
                                              top: 150, // ระบุค่าพิกัด y
                                              child: Text(
                                                "001%",
                                                style: TextStyle(
                                                    fontSize: 40,
                                                    color: Color.fromARGB(
                                                        255, 255, 255, 255),
                                                    fontFamily: 'Poppins'),
                                              ),
                                            ),
                                            const Positioned(
                                              left: 230, // ระบุค่าพิกัด x
                                              top: 200, // ระบุค่าพิกัด y
                                              child: Text(
                                                "MSE",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Color.fromARGB(
                                                        255, 255, 255, 255),
                                                    fontFamily: 'Poppins'),
                                              ),
                                            ),
                                            const Positioned(
                                              left: 55, // ระบุค่าพิกัด x
                                              top: 240, // ระบุค่าพิกัด y
                                              child: Text(
                                                "99%",
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    color: Color.fromARGB(
                                                        255, 255, 255, 255),
                                                    fontFamily: 'Poppins'),
                                              ),
                                            ),
                                            const Positioned(
                                              left: 30, // ระบุค่าพิกัด x
                                              top: 280, // ระบุค่าพิกัด y
                                              child: Text(
                                                "Performance",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Color.fromARGB(
                                                        255, 255, 255, 255),
                                                    fontFamily: 'Poppins'),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 450,
                      width: 460,
                      color: const Color.fromARGB(255, 255, 255, 255),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Model version",
                            style:
                                TextStyle(fontSize: 20, fontFamily: 'Poppins'),
                          ),
                          const Text(
                            "List all model in record",
                            style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'Poppins',
                                color: Color.fromARGB(255, 56, 56, 56)),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: 400,
                            height: 350,
                            color: const Color.fromARGB(255, 255, 255, 255),
                            child: ListView.builder(
                              itemCount: modelsV2
                                  .length, // replace `models` with your data source
                              itemBuilder: (context, index) {
                                return ListTile(
                                    title: Row(
                                      children: [
                                        Container(
                                            width: 40,
                                            height: 40,
                                            decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image: AssetImage(
                                                        "images/ai.png")))),
                                        const SizedBox(
                                          width: 30,
                                        ),
                                        Text(modelsV2[index].version),
                                        const SizedBox(
                                          width: 100,
                                        ),
                                        Text("Rate ${modelsV2[index].rate}"),
                                        const SizedBox(
                                          width: 30,
                                        ),
                                        IconButton(
                                            onPressed: () {},
                                            icon: const Icon(Icons.arrow_forward_ios))
                                      ],
                                    ),
                                    subtitle: const Divider(color: Colors.black));
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 400,
          height: 900,
          // color: Color.fromARGB(255, 214, 252, 1),
          child: Column(
            children: [
              Container(
                width: 400,
                height: 450,
                color: const Color.fromARGB(255, 255, 255, 255),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Setting",
                        style: TextStyle(fontSize: 20, fontFamily: 'Poppins'),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Setting Name : kuytest"),
                            const SizedBox(
                              width: 50,
                            ),
                            ElevatedButton(
                                onPressed: () {},
                                child: const Row(
                                  children: [Text("Load History")],
                                ))
                          ],
                        ),
                      ),
                      const Divider(color: Colors.black),
                      Container(
                        child: const Row(
                          children: [
                            Text("Tube Hight"),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 300,
                              child: TextField(),
                            ),
                            ElevatedButton(
                                onPressed: () {}, child: const Text("Save"))
                          ],
                        ),
                      ),
                      Container(
                        child: const Row(
                          children: [
                            Text("Tube Diameter"),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 300,
                              child: TextField(),
                            ),
                            ElevatedButton(
                                onPressed: () {}, child: const Text("Save"))
                          ],
                        ),
                      ),
                      Container(
                        child: const Row(
                          children: [
                            Text("px : mm"),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 140,
                              child: TextField(),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            const SizedBox(
                              width: 140,
                              child: TextField(),
                            ),
                            ElevatedButton(
                                onPressed: () {}, child: const Text("Save"))
                          ],
                        ),
                      ),
                    ]),
              ),
              Container(
                width: 400,
                height: 450,
                color: const Color.fromARGB(255, 255, 255, 255),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Notification",
                      style: TextStyle(fontSize: 20, fontFamily: 'Poppins'),
                    ),
                    const Text(
                      "3",
                      style: TextStyle(fontSize: 15, fontFamily: 'Poppins'),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.arrow_downward,
                                size: 15,
                                color: Colors.red,
                              ),
                              Text(
                                "2.1%",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'Poppins',
                                    color: Colors.red,
                                    fontWeight: FontWeight.w700),
                              ),
                              Text(
                                " vs last week",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'Poppins',
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontWeight: FontWeight.w100),
                              ),
                            ],
                          ),
                          ElevatedButton(
                              onPressed: () {}, child: const Text("View Report")),
                        ],
                      ),
                    ),
                    const Text(
                      "Detect from 1-6 Jan, 2024",
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Poppins',
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontWeight: FontWeight.w100),
                    ),
                    // grap--------------
                    SizedBox(
                      height: 250, // cari++++++++
                      child: SfCartesianChart(
                          primaryXAxis: const CategoryAxis(),
                          primaryYAxis: const NumericAxis(
                              minimum: 0, maximum: 100, interval: 25),
                          series: <CartesianSeries<ChartData, String>>[
                            LineSeries<ChartData, String>(
                              dataSource: [
                                // Bind data source
                                ChartData('01', 35),
                                ChartData('02', 28),
                                ChartData('03', 34),
                                ChartData('04', 32),
                                ChartData('05', 40),
                                ChartData('06', 35),
                                ChartData('07', 28),
                                ChartData('08', 34),
                                ChartData('09', 32),
                                ChartData('10', 40),
                                ChartData('11', 32),
                                ChartData('12', 40),
                              ],
                              xValueMapper: (ChartData data, _) => data.x,
                              yValueMapper: (ChartData data, _) => data.y,
                              name: 'Series 1',
                              color: const Color(0xFF5A6ACF),
                            ),
                            LineSeries<ChartData, String>(
                              dataSource: [
                                // Bind data source
                                ChartData('01', 5),
                                ChartData('02', 56),
                                ChartData('03', 70),
                                ChartData('04', 88),
                                ChartData('05', 75),
                                ChartData('06', 5),
                                ChartData('07', 28),
                                ChartData('08', 34),
                                ChartData('09', 8),
                                ChartData('10', 89),
                                ChartData('11', 56),
                                ChartData('12', 69),
                              ],
                              xValueMapper: (ChartData data, _) => data.x,
                              yValueMapper: (ChartData data, _) => data.y,
                              name: 'Series 1',
                              color: const Color(0xFFF2383A),
                            ),
                          ]),
                    ),
                    Container(
                      child: const Row(
                        children: [
                          Icon(
                            Icons.circle,
                            color: Color(0xFF5A6ACF),
                            size: 20,
                          ),
                          Text(" Today"),
                          SizedBox(
                            width: 50,
                          ),
                          Icon(
                            Icons.circle,
                            color: Color(0xFFF2383A),
                            size: 20,
                          ),
                          Text(" Yesterday"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class Train_Widget extends StatelessWidget {
  const Train_Widget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Icon(Icons.r_mobiledata),
        Text('Second Widget'),
      ],
    );
  }
}

class DataCenter_Widget extends StatelessWidget {
  const DataCenter_Widget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Icon(Icons.r_mobiledata),
        Text('Second Widget'),
      ],
    );
  }
}

_launchURL() async {
  final Uri url = Uri.parse(
      'https://colab.research.google.com/drive/1WFscRj98nQ9Q-QrS4khYpyVtSvutAN27?usp=sharing');
  if (!await launchUrl(url)) {
    throw Exception('Could not launch');
  }
}

// class ChartData {
//         ChartData(this.x, this.y, this.c);
//         final String x;
//         final double y;
//         final Color c;
//     }

// class SalesData {
//         SalesData(this.y, this.sales);
//         final String y;
//         final double sales;
//     }

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double? y;
}

class Model {
  final String name;
  final String version;
  final String rate;

  Model({required this.name, required this.version, required this.rate});
}

class Hislist {
  final String name;
  final String set_hight;
  final String set_Diameter;
  final String set_px_mm;

  Hislist(
      {required this.name,
      required this.set_hight,
      required this.set_Diameter,
      required this.set_px_mm});
}

// class get_realtime_image{

// }

// class _ChartData {
//   _ChartData(this.x, this.y);

//   final String x;
//   final double y;
// }
