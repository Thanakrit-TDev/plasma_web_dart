import 'package:intl/intl.dart'; // Import the intl package for formatting
import 'package:flutter/material.dart';

import 'package:flutter_side_menu/flutter_side_menu.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:async';

import 'package:plassma/login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:dropdown_button2/dropdown_button2.dart';

class running_trainfrom extends StatelessWidget {
  const running_trainfrom({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key});

  bool st_notification = true;
  ValueNotifier<int> limit_bad_setting = ValueNotifier<int>(100);
  ValueNotifier<int> image_good_now = ValueNotifier<int>(0);
  ValueNotifier<int> image_bad_now = ValueNotifier<int>(0);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

enum Options { option1, option2, option3, option4, option5, option6, option7 }

class _MyHomePageState extends State<MyHomePage> {
  bool _showFirstWidget = true;
  Options _selectedOption = Options.option2;
  void _toggleWidget() {
    setState(() {
      _showFirstWidget = !_showFirstWidget;
    });
  }

  // upload image to pool
  Future<void> upload_dataset_to_pool() async {
    final response = await http.get(
      Uri.parse(
          'http://210.246.215.145:3500/upload_All_to_pool'), // Replace with your backend URL
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      // camera_list_all = responseData['data'];
    }
  }

  void runPopup_upload_image_to_pool() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text('Upload to server'),
              LoadingAnimationWidget.dotsTriangle(
                color: const Color.fromARGB(255, 106, 55, 248),
                size: 150,
              ),
              const SizedBox(height: 20),
              const Text('Please wait...'),
            ],
          ),
        );
      },
    );
    await upload_dataset_to_pool();
    Navigator.of(context, rootNavigator: true).pop();
  }
  //--------------------------

  // get limit image zone
  final textLimit_setting = TextEditingController();
  void save_setting_limit_image() async {
    widget.limit_bad_setting;
    final response = await http.post(
      Uri.parse(
          'http://210.246.215.145:3500/setting_limit_bad_image'), // Replace with your backend URL
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'tube_mm_str': textLimit_setting.text,
      }),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
    }
  }

  void show_image_limit_set() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("setting (${widget.limit_bad_setting.value})"),
          content: SizedBox(
            height: 300,
            width: 300,
            child: Column(
              children: [
                SizedBox(
                  width: 400,
                  child: TextField(
                    controller: textLimit_setting,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Limit image',
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Save"),
              onPressed: () {
                save_setting_limit_image();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void use_now_setting() async {
    final response = await http.get(
      Uri.parse(
          'http://210.246.215.145:3500/get_limit_bad_image'), // Replace with your backend URL
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      widget.st_notification = responseData['limit_bad_image']['st'];
      widget.limit_bad_setting =
          ValueNotifier<int>(responseData['limit_bad_image']['setlimit_image']);
      widget.image_bad_now =
          ValueNotifier<int>(responseData['limit_bad_image']['image_pr_bad']);
      widget.image_good_now =
          ValueNotifier<int>(responseData['limit_bad_image']['image_pr_good']);
    }
  }

  final bool _updating = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List listComport = [];
    Future get_list_comport() async {
      final response = await http.get(
        Uri.parse(
            'http://210.246.215.145:3000/found_comport'), // Replace with your backend URL
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        List buf = responseData['device'];
        if (buf == []) {
          listComport = ["no comport"];
        } else {
          listComport = buf;
        }
      }
      return true;
    }

    Future<void> use_comport_and_connect(String comport) async {
      final response = await http.post(
        Uri.parse(
            'http://210.246.215.145:3000/connect_comport'), // Replace with your backend URL
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'device_name': comport,
        }),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
      }
    }

    void show_list_comport() async {
      get_list_comport();
      await Future.delayed(const Duration(seconds: 1));
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("comport list"),
            content: SizedBox(
              height: 300,
              width: 300,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: listComport.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            ListTile(
                              title: Row(
                                children: [
                                  const Icon(Icons.camera_alt_sharp),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text(listComport[index]),
                                  const SizedBox(
                                    width: 50,
                                  ),
                                  ElevatedButton(
                                      onPressed: () {
                                        use_comport_and_connect(
                                            listComport[index]);
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Use')),
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

    int windowsHight = ((MediaQuery.of(context).size).height).toInt();
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    if (width <= 1460) {
      return Scaffold(
        appBar: AppBar(
          title: Container(
            child: Row(
              children: [
                Image.asset("images/logo.jpg",
                    width: 30, height: 30, fit: BoxFit.fill),
                const Text(
                  "Plasma detection website",
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
                hasResizerToggle: false,
                hasResizer: false,
                backgroundColor: Color(0xFFfef7ff),
                builder: (data) => SideMenuData(
                    header: const Column(), items: [], footer: ai_process()),
              ),
              Expanded(
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.warning_amber_outlined,
                        color: Color.fromARGB(255, 255, 153, 0),
                        size: 300,
                      ),
                      Text("website support only pc (1080 x 1920)")
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
      // return Center(
      //   child: Column(
      //     children: [
      //       Icon(Icons.warning_amber_outlined,color: Color.fromARGB(255, 255, 153, 0),size: 300,),
      //       Text("website support only pc (1080 x 1920)")
      //     ],
      //   ),
      // );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Container(
            child: Row(
              children: [
                Image.asset("images/logo.jpg",
                    width: 30, height: 30, fit: BoxFit.fill),
                const Text(
                  "Plasma detection website",
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
                hasResizerToggle: false,
                hasResizer: false,
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
                                style: TextStyle(
                                    fontSize: 18, fontFamily: 'Poppins'),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    items: [
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
                      SideMenuItemDataTile(
                        highlightSelectedColor: Colors.white,
                        hoverColor: const Color.fromARGB(255, 156, 156, 156),
                        isSelected: false,
                        onTap: () {
                          setState(() {
                            _selectedOption = Options.option5;
                          });
                        },
                        title: '   Data Center for train',
                        icon: const Icon(Icons.dataset),
                      ),
                      SideMenuItemDataTile(
                        highlightSelectedColor: Colors.white,
                        hoverColor: const Color.fromARGB(255, 156, 156, 156),
                        isSelected: false,
                        onTap: () {
                          setState(() {
                            _selectedOption = Options.option6;
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const Login()));
                          });
                        },
                        title: '   Logout',
                        icon: const Icon(Icons.exit_to_app),
                      ),
                    ],
                    footer: ai_process()),
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: Center(
                    child: Column(
                      children: [
                        if (_selectedOption == Options.option1)
                          Running_Widget()
                        else if (_selectedOption == Options.option2)
                          Dashboard_Widget()
                        else if (_selectedOption == Options.option3)
                          const Train_Widget()
                        else if (_selectedOption == Options.option4)
                          DataCenter_Widget()
                        else if (_selectedOption == Options.option5)
                          DataCenter_for_train()
                        // else if (_selectedOption == Options.option7)
                        //   ai_process(),
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
}

class Running_Widget extends StatefulWidget {
  Running_Widget({super.key});
  @override
  String global_version = "1.0.0";
  String global_mse = "0.001";
  String global_performance = "99";
  bool st_swich_graph = false;
  bool st_mask_and_command = true;
  @override
  State<Running_Widget> createState() => _Running_WidgetState();
}

class _Running_WidgetState extends State<Running_Widget> {
  List<dynamic> list_model_in_com = [];
  Map<String, dynamic> list_model_frominternet = {};
  void get_model_from_internet() async {
    final response = await http.get(
      Uri.parse(
          'http://210.246.215.145:5000/get_model_from_internet'), // Replace with your backend URL
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      list_model_frominternet = responseData['model_list_all'];
    }
  }

  // get image zone ---------------------------------------------------------------------
  String imageUrl = "http://210.246.215.145:3501/image_process_detect";
  String imageUrl_mask =
      "http://210.246.215.145:3501/image_process_mask"; //"http://210.246.215.145:2545/mask"

  @override
  void initState() {
    get_model_from_internet();
    // get_list_model_inmycomputer();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // get image zone --------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final List<Model> models =
        list_model_frominternet.keys.toList().asMap().entries.map((entry) {
      int index = entry.key;
      String key = entry.value;
      Map<String, dynamic> item = list_model_frominternet[key]!;
      bool stModelInPc = false;
      for (var model_com in list_model_in_com) {
        if (key == model_com) {
          stModelInPc = true;
          break;
        }
      }
      return Model(
          version: key.toString(),
          rate: item['accuracy'].toString(), //rate -> accuracy
          filename: item['filename'].toString(),
          mse: item['loss'].toString(), //mse -> loss
          performance: item['accuracy'].toString(), // performance -> accuracy
          st_model_incom: stModelInPc);
    }).toList();
    GlobalData_model_for_web().addData(models);
    return const Row();
  }
}

class Dashboard_Widget extends StatefulWidget {
  Dashboard_Widget({super.key});
  bool st_swich_graph = true;
  // graph ---------
  var dataSource_his = [
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
  ];
  var dataSource_his_true = [
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
  ];
  bool st_download_his = true;
  //---------------

  String global_version = "1.0.0";
  String global_mse = "0.001";
  String global_performance = "99";

  List<String> selected_mode_getdata = <String>['Day', 'Week', 'Month', 'Year'];
  String? sec_get_data_mode = "Day";

  double graph_high_golbal = 100;

  var global_model_internet;
  var Historylist_list;

  @override
  State<Dashboard_Widget> createState() => _Dashboard_Widget();
}

class _Dashboard_Widget extends State<Dashboard_Widget> {
  final tube_hight = TextEditingController();
  final tube_diameter = TextEditingController();
  final tube_px = TextEditingController();
  final tube_mm = TextEditingController();
  final tube_name_setting = TextEditingController();
  final name_setting_now = TextEditingController();

  @override
  Future<void> settingapp() async {
    final String tubeHightStr = tube_hight.text;
    final String tubeDiameterStr = tube_diameter.text;
    final String tubePxStr = tube_px.text;
    final String tubeMmStr = tube_mm.text;
    final String tubeNameSettingStr = tube_name_setting.text;

    final response = await http.post(
      Uri.parse(
          'http://210.246.215.145:5000/setting'), // Replace with your backend URL
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'time_save': (DateTime.now().millisecondsSinceEpoch).toString(),
        'tube_name_setting_str': tubeNameSettingStr,
        'tube_hight_str': tubeHightStr,
        'tube_diameter_str': tubeDiameterStr,
        'tube_px_str': tubePxStr,
        'tube_mm_str': tubeMmStr,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (responseData['stsave']) {
        use_now_setting();
      } else {
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
                      child: Row(children: [
                        Icon(
                          Icons.report_problem,
                          color: Colors.amber,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          "save Failed",
                          style: TextStyle(fontSize: 25),
                        )
                      ]),
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
                    child: Row(children: [
                      Icon(
                        Icons.report_problem,
                        color: Colors.amber,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "save Failed",
                        style: TextStyle(fontSize: 25),
                      )
                    ]),
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
    setState(() {});
  }

  var datatemset = {};
  void use_now_setting() async {
    final response = await http.get(
      Uri.parse('http://210.246.215.145:1234/save_setting_from_database'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      datatemset = responseData['data_sync'];
    }

    var kInDatatemset;
    var vInDatatemset;
    datatemset.forEach(
      (key, value) {
        kInDatatemset = key;
        vInDatatemset = value;
      },
    );

    setState(() {
      tube_name_setting.text = datatemset[kInDatatemset]['name'].toString();
      tube_hight.text = datatemset[kInDatatemset]['tube_hight'].toString();
      tube_diameter.text =
          datatemset[kInDatatemset]['tube_diameter'].toString();
      tube_px.text = datatemset[kInDatatemset]['px'].toString();
      tube_mm.text = datatemset[kInDatatemset]['mm'].toString();
    });

    final List<Hislist> Historylist =
        datatemset.keys.toList().asMap().entries.map((entry) {
      int index = entry.key;
      String key = entry.value;
      Map<String, dynamic> item = datatemset[key]!;

      return Hislist(
          name: item['name'],
          tube_hight: item['tube_hight'].toString(),
          tube_diameter: item['tube_diameter'].toString(),
          mm: item['mm'].toString(),
          px: item['px'].toString(),
          id: key.toString());
    }).toList();
    widget.Historylist_list = Historylist;
    GlobalData().addData(widget.Historylist_list);
  }

  void use_setting_this(String idSetting) async {
    // send old time and new time to server
    final response = await http.post(
      Uri.parse(
          'http://210.246.215.145:5000/usesettingthis'), // Replace with your backend URL
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'new_id': (DateTime.now().millisecondsSinceEpoch).toString(),
        'old_id': idSetting,
      }),
    );
    if (response.statusCode == 200) {
      use_now_setting();
    } else {
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
                    child: Row(children: [
                      Icon(
                        Icons.report_problem,
                        color: Colors.amber,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "can't use templat (Server error)!",
                        style: TextStyle(fontSize: 25),
                      )
                    ]),
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
  }

  void delete_setting_this(String idSetting) async {
    final response = await http.post(
      Uri.parse(
          'http://210.246.215.145:5000/deletesettingthis'), // Replace with your backend URL
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'new_id': (DateTime.now().millisecondsSinceEpoch).toString(),
        'old_id': idSetting,
      }),
    );
    if (response.statusCode == 200) {
      use_now_setting();
    } else {
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
                    child: Row(children: [
                      Icon(
                        Icons.report_problem,
                        color: Colors.amber,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "can't delete templat (Server error)!",
                        style: TextStyle(fontSize: 25),
                      )
                    ]),
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
  }

  // send command zone----------------------------
  List<dynamic> data_list_command = [];

  final commandcontrol = TextEditingController();
  void send_command() async {
    final response = await http.post(
      Uri.parse(
          'http://210.246.215.145:5000/command_send'), // Replace with your backend URL
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'command': commandcontrol.text,
      }),
    );
    if (response.statusCode == 200) {
      data_list_command.add(commandcontrol.text);
      commandcontrol.text = '';
      use_now_setting();
    } else {
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
                    child: Row(children: [
                      Icon(
                        Icons.report_problem,
                        color: Colors.amber,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "can't send command (Server error)!",
                        style: TextStyle(fontSize: 25),
                      )
                    ]),
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
  }
  // send command zone----------------------------

  Future<void> run_sync_data_setting() async {
    final response = await http.get(
      Uri.parse(
          'http://210.246.215.145:5000/sync_setting_from_database'), // Replace with your backend URL
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
  }

  void Popup_run_sync_data_setting() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text('Sync setting'),
              LoadingAnimationWidget.dotsTriangle(
                color: const Color.fromARGB(255, 106, 55, 248),
                size: 150,
              ),
              const SizedBox(height: 20),
              const Text('Please wait...'),
            ],
          ),
        );
      },
    );
    await run_sync_data_setting();
    Navigator.of(context, rootNavigator: true).pop();
  }

  Future<void> run_save_data_setting() async {
    final response = await http.get(
      Uri.parse(
          'http://210.246.215.145:5000/save_setting_from_database'), // Replace with your backend URL
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      // body: jsonEncode(<String, String>{'download_model': version_to_download}),
    );
  }

  void Popup_run_save_data_setting() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text('save setting'),
              LoadingAnimationWidget.dotsTriangle(
                color: const Color.fromARGB(255, 106, 55, 248),
                size: 150,
              ),
              const SizedBox(height: 20),
              const Text('Please wait...'),
            ],
          ),
        );
      },
    );
    await run_save_data_setting();
    Navigator.of(context, rootNavigator: true).pop();
  }

  List<Hislist> Historylist = GlobalData().getData();
//end--------------------------------------------------

  void changeStateSetting() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Text("Load History"),
            ],
          ),
          content: SizedBox(
            height: 300,
            width: 800,
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.Historylist_list.length,
                    // itemCount:5,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(widget.Historylist_list[index].name),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                        "Height ${widget.Historylist_list[index].tube_hight}"),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                        "Diameter ${widget.Historylist_list[index].tube_diameter}"),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                        "px ${widget.Historylist_list[index].px}"),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                        "mm ${widget.Historylist_list[index].mm}"),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    ElevatedButton(
                                        onPressed: () {
                                          delete_setting_this(widget
                                              .Historylist_list[index].id);
                                          setState(() {
                                            Navigator.of(context).pop();
                                            // changeStateSetting();
                                            setState(() {});
                                          });
                                        },
                                        child: const Text('Delete')),
                                  ],
                                ),
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

  // schedule-------------------------------------------------
  void schedule_end() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Load History"),
          content: const Text("kuy"),
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

  late DateTime _selectedDate_start = DateTime.now();
  Future<void> _selectDateStart(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate_start ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate_start) {
      setState(() {
        _selectedDate_start = picked;
      });
    }
  }

  late DateTime _selectedDate_end = DateTime.now();
  Future<void> _selectDateEnd(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate_end ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate_end) {
      setState(() {
        _selectedDate_end = picked;
      });
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('d:M:y').format(date);
  }

  void get_history_for_graph() async {
    setState(() {
      widget.st_download_his = false;
    });
    int startDateStamp = _selectedDate_start.millisecondsSinceEpoch ~/ 1000;
    int endDateStamp = _selectedDate_end.millisecondsSinceEpoch ~/ 1000;
    final response = await http.post(
      Uri.parse(
          'http://210.246.215.145:5000/get_history_for_graph'), // Replace with your backend URL
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String?>{
        'start': startDateStamp.toString(),
        'end': endDateStamp.toString(),
        'mode': widget.sec_get_data_mode
      }),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      var bufData = responseData['hisreturn']["false_tube"];
      var bufData2 = responseData['hisreturn']["true_tube"];
      var bufdataSouse = responseData['hisreturn']["souse"];

      double graphHighSub = 100;
      setState(() {
        widget.dataSource_his = [];
        bufData.forEach(
          (key, value) {
            widget.dataSource_his.add(ChartData(key, value.toDouble()));
            if (graphHighSub < value.toDouble()) {
              graphHighSub = value.toDouble();
            }
          },
        );
        widget.dataSource_his_true = [];
        bufData2.forEach(
          (key, value) {
            widget.dataSource_his_true.add(ChartData(key, value.toDouble()));
            if (graphHighSub < value.toDouble()) {
              graphHighSub = value.toDouble();
            }
          },
        );
        widget.graph_high_golbal = graphHighSub;
        widget.st_download_his = true;
      });
    }
  }

  void start_frast_get_graph() async {
    final response = await http.post(
      Uri.parse(
          'http://210.246.215.145:5000/get_history_for_graph'), // Replace with your backend URL
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'start':
            DateTime.now().subtract(const Duration(seconds: 604800)).toString(),
        'end': DateTime.now().toString(),
        'mode': "Day"
      }),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      var bufData = responseData['hisreturn']["false_tube"];
      var bufData2 = responseData['hisreturn']["true_tube"];

      setState(() {
        widget.dataSource_his = [];
        bufData.forEach(
          (key, value) {
            widget.dataSource_his.add(ChartData(key, value.toDouble()));
          },
        );
        widget.dataSource_his_true = [];
        bufData2.forEach(
          (key, value) {
            widget.dataSource_his_true.add(ChartData(key, value.toDouble()));
          },
        );
      });
    }
  }

  // schedule-------------------------------------------------

  void swich_work() {
    widget.st_swich_graph = !widget.st_swich_graph;

    setState(() {});
  }

  Widget swich_graph() {
    if (widget.st_download_his) {
      if (widget.st_swich_graph) {
        return SizedBox(
          height: 250, // cari++++++++
          child: SfCartesianChart(
              primaryXAxis: const CategoryAxis(),
              primaryYAxis: NumericAxis(
                  minimum: 0, maximum: widget.graph_high_golbal, interval: 25),
              series: <CartesianSeries<ChartData, String>>[
                ColumnSeries<ChartData, String>(
                  dataSource: widget.dataSource_his_true,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y,
                  name: 'Series 1',
                  color: const Color(0xFF5A6ACF),
                ),
                ColumnSeries<ChartData, String>(
                  dataSource: widget.dataSource_his,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y,
                  name: 'Series 2',
                  color: const Color.fromARGB(0, 22, 243, 29),
                ),
                ColumnSeries<ChartData, String>(
                  dataSource: widget.dataSource_his,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y,
                  name: 'Series 1',
                  color: const Color(0xFFF2383A),
                ),
              ]),
        );
      } else {
        return SizedBox(
          height: 250,
          child: SfCartesianChart(
              primaryXAxis: const CategoryAxis(),
              primaryYAxis: NumericAxis(
                  minimum: 0, maximum: widget.graph_high_golbal, interval: 25),
              series: <CartesianSeries<ChartData, String>>[
                LineSeries<ChartData, String>(
                  dataSource: widget.dataSource_his_true,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y,
                  name: 'Series 1',
                  color: const Color(0xFF5A6ACF),
                ),
                LineSeries<ChartData, String>(
                  dataSource: widget.dataSource_his,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y,
                  name: 'Series 2',
                  color: const Color.fromARGB(0, 22, 243, 29),
                ),
                LineSeries<ChartData, String>(
                  dataSource: widget.dataSource_his,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y,
                  name: 'Series 1',
                  color: const Color(0xFFF2383A),
                ),
              ]),
        );
      }
    } else {
      return SizedBox(
        height: 250,
        child: Row(
          children: [
            const SizedBox(
              width: 400,
            ),
            LoadingAnimationWidget.dotsTriangle(
              color: const Color.fromARGB(255, 84, 84, 255),
              size: 100,
            ),
          ],
        ),
      );
    }
  }

  final bool _updating = false;
  List<dynamic> data_load_log = [];
  void load_status_get_log() async {
    final response = await http.get(
      Uri.parse(
          'http://210.246.215.145:5000/get_log'), // Replace with your backend URL
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      data_load_log = responseData;

      int count = 0;
      for (var i in data_load_log) {
        if (i[1] == "True") {
          data_load_log[count].add(true);
        } else {
          data_load_log[count].add(false);
        }
        count++;
      }
      if (mounted) {
        setState(() {});
      }
    }
  }

  List<dynamic> list_model_in_com = [];
  Map<String, dynamic> list_model_frominternet = {};
  void get_model_from_internet() async {
    final response = await http.get(
      Uri.parse(
          'http://210.246.215.145:5000/get_model_from_internet'), // Replace with your backend URL
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      list_model_frominternet = responseData['model_list_all'];

      final List<Model> models =
          list_model_frominternet.keys.toList().asMap().entries.map((entry) {
        int index = entry.key;
        String key = entry.value;
        Map<String, dynamic> item = list_model_frominternet[key]!;
        bool stModelInPc = false;
        for (var model_com in list_model_in_com) {
          if (key == model_com) {
            stModelInPc = true;
            break;
          }
        }
        return Model(
            version: key.toString(),
            rate: item['accuracy'].toString(), //rate -> accuracy
            filename: item['filename'].toString(),
            mse: item['loss'].toString(), //mse -> loss
            performance: item['accuracy'].toString(), // performance -> accuracy
            st_model_incom: stModelInPc);
      }).toList();
      GlobalData_model_for_web().addData(models);
      List<Model> modelsFromServer = GlobalData_model_for_web().getData();
      widget.global_model_internet = modelsFromServer;
    }
  }

  List<Model> retrun_list_model() {
    return GlobalData_model_for_web().getData();
  }

  @override
  void apply_show_version_model(String chooseModelVersion) {
    for (var run_version in widget.global_model_internet) {
      if (chooseModelVersion == run_version.version) {
        setState(() {
          widget.global_version = run_version.version;
          widget.global_mse = (run_version.mse);
          widget.global_performance = run_version.performance;
          GUI_version_model_V2(widget.global_version, widget.global_mse,
              widget.global_performance);
        });
        break;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    get_model_from_internet();
    use_now_setting();
    start_frast_get_graph();

    Timer.periodic(const Duration(milliseconds: 5000), (Timer timer) {
      if (!_updating) {
        load_status_get_log();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget render_model_new(List<Model> modelsFromServer) {
    return ListView.builder(
      itemCount:
          modelsFromServer.length, // replace `models` with your data source
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
                            image: AssetImage("images/ai.png")))),
                const SizedBox(
                  width: 30,
                ),
                Text(modelsFromServer[index].version),
                const SizedBox(
                  width: 100,
                ),
                Text("Rate ${modelsFromServer[index].rate}"),
                const SizedBox(
                  width: 30,
                ),
                IconButton(
                    onPressed: () {
                      apply_show_version_model(modelsFromServer[index].version);
                    },
                    icon: const Icon(Icons.arrow_forward_ios))
              ],
            ),
            subtitle: const Divider(color: Colors.black));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    int windowsHight = ((MediaQuery.of(context).size).height).toInt();

    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    if (width <= 1460) {
      return Center(
        child: Column(
          children: [
            Icon(
              Icons.warning_amber_outlined,
              color: Color.fromARGB(255, 255, 153, 0),
              size: 300,
            ),
            Text("website support only pc (1080 x 1920)")
          ],
        ),
      );
    } else {
      return Transform.scale(
        alignment: Alignment.topLeft,
        scale: (windowsHight / 1000),
        child: Column(
          children: [
            Row(
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
                            Text(
                              "Dashboard",
                              style: TextStyle(
                                  fontSize: 20, fontFamily: 'Poppins'),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 920,
                                    // color: Colors.amber,
                                    child: Row(
                                      children: [
                                        ElevatedButton(
                                            onPressed: () {
                                              _selectDateStart(context);
                                            },
                                            child: const Text(
                                              "Date start",
                                              style: TextStyle(
                                                  color: Color(0xFF5A6ACF)),
                                            )),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        ElevatedButton(
                                            onPressed: () {
                                              _selectDateEnd(context);
                                            },
                                            child: const Text(
                                              "Date stop",
                                              style: TextStyle(
                                                  color: Color(0xFF5A6ACF)),
                                            )),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        ElevatedButton(
                                            onPressed: get_history_for_graph,
                                            child: const Text("Get history",
                                                style: TextStyle(
                                                    color: Color(0xFF5A6ACF)))),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        ElevatedButton(
                                            onPressed: swich_work,
                                            child: const Text(
                                              "Switch graph",
                                              style: TextStyle(
                                                  color: Color(0xFF5A6ACF)),
                                            )),
                                        const SizedBox(
                                          width: 180,
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        DropdownButtonHideUnderline(
                                          child: DropdownButton2<String>(
                                            isExpanded: true,
                                            hint: const Row(
                                              children: [
                                                Icon(
                                                  Icons.list,
                                                  size: 16,
                                                  color: Colors.yellow,
                                                ),
                                                SizedBox(
                                                  width: 4,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    'Select Item',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.yellow,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            items: widget.selected_mode_getdata
                                                .map((String item) {
                                              return DropdownMenuItem<String>(
                                                value: item,
                                                child: Text(
                                                  item,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              );
                                            }).toList(),
                                            value: widget.sec_get_data_mode,
                                            onChanged: (String? value) {
                                              setState(() {
                                                widget.sec_get_data_mode =
                                                    value;
                                              });
                                            },
                                            buttonStyleData: ButtonStyleData(
                                              height: 35,
                                              width: 160,
                                              padding: const EdgeInsets.only(
                                                  left: 14, right: 14),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: const Color(0xFF5a67ba),
                                              ),
                                              elevation: 2,
                                            ),
                                            iconStyleData: const IconStyleData(
                                              icon: Icon(
                                                Icons
                                                    .arrow_forward_ios_outlined,
                                              ),
                                              iconSize: 14,
                                              iconEnabledColor: Color.fromARGB(
                                                  255, 255, 255, 255),
                                              iconDisabledColor: Colors.grey,
                                            ),
                                            dropdownStyleData:
                                                DropdownStyleData(
                                              maxHeight: 200,
                                              width: 200,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                                color: const Color(0xFF5a67ba),
                                              ),
                                              offset: const Offset(-20, -10),
                                              scrollbarTheme:
                                                  ScrollbarThemeData(
                                                radius:
                                                    const Radius.circular(40),
                                                thickness: WidgetStateProperty
                                                    .all<double>(6),
                                                thumbVisibility:
                                                    WidgetStateProperty.all<
                                                        bool>(true),
                                              ),
                                            ),
                                            menuItemStyleData:
                                                const MenuItemStyleData(
                                              height: 40,
                                              padding: EdgeInsets.only(
                                                  left: 14, right: 14),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            swich_graph(),
                            Container(
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.circle,
                                    color: Color(0xFF5A6ACF),
                                    size: 20,
                                  ),
                                  const Text(" Detect True"),
                                  const SizedBox(
                                    width: 50,
                                  ),
                                  const Icon(
                                    Icons.circle,
                                    color: Color(0xFFF2383A),
                                    size: 20,
                                  ),
                                  const Text(" Detect False"),
                                  const SizedBox(
                                    width: 50,
                                  ),
                                  Text(
                                      "query : ${_formatDate(_selectedDate_start)} to ${_formatDate(_selectedDate_end)}"),
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
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    child: GUI_version_model_V2(
                                        widget.global_version,
                                        widget.global_mse,
                                        widget.global_performance),
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
                                    style: TextStyle(
                                        fontSize: 20, fontFamily: 'Poppins'),
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
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    child:
                                        render_model_new(retrun_list_model()),
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
                                style: TextStyle(
                                    fontSize: 20, fontFamily: 'Poppins'),
                              ),
                              Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        "Setting Name : ${tube_name_setting.text}"),
                                    const SizedBox(
                                      width: 50,
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title:
                                                    const Text("setting name"),
                                                content: SizedBox(
                                                  width: 400,
                                                  height: 100,
                                                  child: Column(
                                                    children: [
                                                      TextField(
                                                        controller:
                                                            name_setting_now,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          tube_name_setting
                                                                  .text =
                                                              name_setting_now
                                                                  .text;
                                                        });
                                                      },
                                                      child: const Text(
                                                        "save",
                                                        style: TextStyle(
                                                            fontSize: 20),
                                                      )),
                                                  TextButton(
                                                    child: const Text(
                                                      "OK",
                                                      style: TextStyle(
                                                          fontSize: 15),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                ],
                                              );
                                            });
                                      },
                                      child: const Icon(Icons.edit),
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
                                    SizedBox(
                                      width: 400,
                                      child: TextField(
                                        controller: tube_hight,
                                      ),
                                    ),
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
                                    SizedBox(
                                      width: 400,
                                      child: TextField(
                                        controller: tube_diameter,
                                      ),
                                    ),
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
                                    SizedBox(
                                      width: 190,
                                      child: TextField(
                                        controller: tube_px,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    SizedBox(
                                      width: 190,
                                      child: TextField(
                                        controller: tube_mm,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              CupertinoButton(
                                onPressed: settingapp,
                                color: const Color(0xFF5A67BA),
                                child: const SizedBox(
                                  width: 400,
                                  child: Text(
                                    "save",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Poppins'),
                                  ),
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
                                style: TextStyle(
                                    fontSize: 20, fontFamily: 'Poppins'),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                width: 400,
                                height: 400,
                                color: const Color.fromARGB(255, 255, 255, 255),
                                child: render_log_load(data_load_log),
                              )
                            ]),
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      );
    }
  }
}

class Train_Widget extends StatefulWidget {
  const Train_Widget({super.key});

  @override
  State<Train_Widget> createState() => _Train_WidgetState();
}

class _Train_WidgetState extends State<Train_Widget> {
  @override
  void initState() {
    super.initState();
    _launchURL();
  }

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Icon(Icons.r_mobiledata),
        Text('open colab for train model'),
      ],
    );
  }
}

class DataCenter_Widget extends StatefulWidget {
  DataCenter_Widget({super.key});
  bool display_swich = true;

  //good pool
  List<bool> list_bool_del_good = <bool>[];
  List<bool> list_bool_move_to_bad = <bool>[];
  List<bool> list_bool_save_to_good = <bool>[];
  List<String> list_image_good_pool = <String>[];
  late List GoodPool_list;

  //bad pool
  List<bool> list_bool_del_bad = <bool>[];
  List<bool> list_bool_move_to_good = <bool>[];
  List<bool> list_bool_save_to_bad = <bool>[];
  List<String> list_image_bad_pool = <String>[];
  late List badPool_list;

  List<dynamic> list_model_in_com = [];

  @override
  State<DataCenter_Widget> createState() => _DataCenter_WidgetState();
}

class _DataCenter_WidgetState extends State<DataCenter_Widget> {
  //zone of good pool
  void _toggleCheckbox_good(bool? value, int indexList) {
    setState(() {
      widget.list_bool_del_good[indexList] = value ?? false;
      if (widget.list_bool_del_good[indexList] == true) {
        widget.list_bool_move_to_bad[indexList] = false;
        widget.list_bool_save_to_good[indexList] = false;
      }
    });
  }

  void _toggleCheckbox_move_to_bad(bool? value, int indexList) {
    setState(() {
      widget.list_bool_move_to_bad[indexList] = value ?? false;
      if (widget.list_bool_move_to_bad[indexList] == true) {
        widget.list_bool_del_good[indexList] = false;
        widget.list_bool_save_to_good[indexList] = false;
      }
    });
  }

  void _toggleCheckbox_save_good_to_dataset(bool? value, int indexList) {
    setState(() {
      widget.list_bool_save_to_good[indexList] = value ?? false;
      if (widget.list_bool_save_to_good[indexList] == true) {
        widget.list_bool_move_to_bad[indexList] = false;
        widget.list_bool_del_good[indexList] = false;
      }
    });
  }

  //--end---
  //zone of bad pool
  void _toggleCheckbox_bad(bool? value, int indexList) {
    setState(() {
      widget.list_bool_del_bad[indexList] = value ?? false;
      if (widget.list_bool_del_bad[indexList] == true) {
        widget.list_bool_move_to_good[indexList] = false;
        widget.list_bool_save_to_bad[indexList] = false;
      }
    });
  }

  void _toggleCheckbox_move_to_good(bool? value, int indexList) {
    setState(() {
      widget.list_bool_move_to_good[indexList] = value ?? false;
      if (widget.list_bool_move_to_good[indexList] == true) {
        widget.list_bool_del_bad[indexList] = false;
        widget.list_bool_save_to_bad[indexList] = false;
      }
    });
  }

  void _toggleCheckbox_save_bad_to_dataset(bool? value, int indexList) {
    setState(() {
      widget.list_bool_save_to_bad[indexList] = value ?? false;
      if (widget.list_bool_save_to_bad[indexList] == true) {
        widget.list_bool_move_to_good[indexList] = false;
        widget.list_bool_del_bad[indexList] = false;
      }
    });
  }

  Future<void> runGetListFromGoodPool() async {
    final response = await http.get(
      Uri.parse(
          'http://210.246.215.145:1234/get_name_data_set_in_good_pool'), // Replace with your backend URL
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      // if (responseData['files'] != []){
      //   widget.badPool_list = (responseData['files'] as List).sublist(0, 30);
      // }
      // else{
      widget.GoodPool_list = responseData['files'];
      // }

      widget.list_bool_del_good = [];
      widget.list_image_good_pool = [];
      widget.list_bool_move_to_bad = [];

      for (var i in widget.GoodPool_list) {
        widget.list_bool_del_good.add(false);
        widget.list_bool_move_to_bad.add(false);
        widget.list_bool_save_to_good.add(true);
        widget.list_image_good_pool.add(i);
      }
    }
  }

  Future<void> runGetListFromBadPool() async {
    final response = await http.get(
      Uri.parse(
          'http://210.246.215.145:1234/get_name_data_set_in_bad_pool'), // Replace with your backend URL
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      widget.badPool_list = responseData['files'];
      // if (responseData['files'] != [])
      //   widget.badPool_list = (responseData['files'] as List).sublist(0, 30);
      // else
      //   widget.GoodPool_list = responseData['files'];

      widget.list_bool_del_bad = [];
      widget.list_image_bad_pool = [];
      widget.list_bool_move_to_good = [];

      for (var i in widget.badPool_list) {
        widget.list_bool_del_bad.add(false);
        widget.list_bool_move_to_good.add(false);
        widget.list_bool_save_to_bad.add(true);
        widget.list_image_bad_pool.add(i);
      }
    }
  }

  Future<void> processAddCommand() async {
    // await Future.delayed(Duration(seconds: 3)); // Replace with your actual task
    //save to
    List<String> bufListBoolSaveToGoodNameFile = [];
    List<String> bufListBoolMoveToBadNameFile = [];
    List<String> bufListBoolDelGoodNameFile = [];

    for (int i = 0; i < widget.list_image_good_pool.length; i++) {
      if (widget.list_bool_save_to_good[i] == true) {
        bufListBoolSaveToGoodNameFile.add(widget.list_image_good_pool[i]);
      }
      if (widget.list_bool_move_to_bad[i] == true) {
        bufListBoolMoveToBadNameFile.add(widget.list_image_good_pool[i]);
      }
      if (widget.list_bool_del_good[i] == true) {
        bufListBoolDelGoodNameFile.add(widget.list_image_good_pool[i]);
      }
    }

    List<String> bufListBoolSaveToBadNameFile = [];
    List<String> bufListBoolMoveToGoodNameFile = [];
    List<String> bufListBoolDelBadNameFile = [];

    for (int i = 0; i < widget.list_image_bad_pool.length; i++) {
      if (widget.list_bool_save_to_bad[i] == true) {
        bufListBoolSaveToBadNameFile.add(widget.list_image_bad_pool[i]);
      }
      if (widget.list_bool_move_to_good[i] == true) {
        bufListBoolMoveToGoodNameFile.add(widget.list_image_bad_pool[i]);
      }
      if (widget.list_bool_del_bad[i] == true) {
        bufListBoolDelBadNameFile.add(widget.list_image_bad_pool[i]);
      }
    }

    //pool good move to bad
    final response1 = await http.post(
      Uri.parse('http://210.246.215.145:1234/move_or_delete_dataset'),
      headers: {
        'Content-Type': 'application/json', // Set content type to JSON
      },
      body: jsonEncode({
        "mode": "good_to_bad",
        "filename": bufListBoolMoveToBadNameFile,
      }),
    );

    //pool bad move to good
    final response2 = await http.post(
      Uri.parse('http://210.246.215.145:1234/move_or_delete_dataset'),
      headers: {
        'Content-Type': 'application/json', // Set content type to JSON
      },
      body: jsonEncode({
        "mode": "bad_to_good",
        "filename": bufListBoolMoveToGoodNameFile,
      }),
    );

    //pool delets good
    final response3 = await http.post(
      Uri.parse('http://210.246.215.145:1234/move_or_delete_dataset'),
      headers: {
        'Content-Type': 'application/json', // Set content type to JSON
      },
      body: jsonEncode({
        "mode": "delete",
        "filename": bufListBoolDelGoodNameFile,
        "folder_name": "good"
      }),
    );

    //pool delets bad
    final response4 = await http.post(
      Uri.parse('http://210.246.215.145:1234/move_or_delete_dataset'),
      headers: {
        'Content-Type': 'application/json', // Set content type to JSON
      },
      body: jsonEncode({
        "mode": "delete",
        "filename": bufListBoolDelBadNameFile,
        "folder_name": "bad"
      }),
    );
    setState(() {});
  }

  Future<void> move_all_to_train() async {
    final response5 = await http.post(
      Uri.parse(
          'http://210.246.215.145:1234/move_or_delete_dataset_pool_to_train'),
      headers: {
        'Content-Type': 'application/json', // Set content type to JSON
      },
      body: jsonEncode({
        "mode": "pool_to_train",
      }),
    );
  }

  void runPopupLoading() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text('Processing'),
              LoadingAnimationWidget.dotsTriangle(
                color: const Color.fromARGB(255, 106, 55, 248),
                size: 150,
              ),
              const SizedBox(height: 20),
              const Text('Please wait...'),
            ],
          ),
        );
      },
    );
    await processAddCommand();
    Navigator.of(context, rootNavigator: true).pop();
  }

  void runPopupLoading_move_to_train() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text('Processing'),
              LoadingAnimationWidget.dotsTriangle(
                color: const Color.fromARGB(255, 106, 55, 248),
                size: 150,
              ),
              const SizedBox(height: 20),
              const Text('Please wait...'),
            ],
          ),
        );
      },
    );
    await move_all_to_train();
    Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  void initState() {
    super.initState();
    runGetListFromGoodPool();
    runGetListFromBadPool();
    runGetListFromGoodPool();
    runGetListFromBadPool();
  }

  Widget Goodrender_image() {
    return SizedBox(
      height: 800,
      width: 1600,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          crossAxisSpacing: 5.0,
          mainAxisSpacing: 5.0,
        ),
        itemCount: widget.list_bool_del_good.length,
        itemBuilder: (context, index) {
          return Container(
            child: Column(
              children: [
                Row(
                  children: [
                    const SizedBox(
                      width: 25,
                    ),
                    Checkbox(
                      value: widget.list_bool_move_to_bad[index],
                      onChanged: (bool? value) {
                        _toggleCheckbox_move_to_bad(value, index);
                      },
                    ),
                    const Text("move to bad"),
                    Checkbox(
                      value: widget.list_bool_del_good[index],
                      onChanged: (bool? value) {
                        _toggleCheckbox_good(value, index);
                      },
                    ),
                    const Text("delete"),
                    Checkbox(
                      value: widget.list_bool_save_to_good[index],
                      onChanged: (bool? value) {
                        _toggleCheckbox_save_good_to_dataset(value, index);
                      },
                    ),
                    const Text("save"),
                  ],
                ),
                CachedNetworkImage(
                  imageUrl:
                      "http://210.246.215.145:1234/show/good/${widget.list_image_good_pool[index]}",
                  height: 250,
                  // placeholder: (context, url) => const CircularProgressIndicator(),
                  placeholder: (context, url) => const SizedBox(
                    width: 250.0,
                    height: 100.0,
                    child: CircularProgressIndicator(
                      color: Color.fromARGB(255, 136, 32, 255),
                    ),
                  ),
                  errorWidget: (context, url, error) {
                    return Column(
                      children: [
                        const Icon(Icons.error),
                        ElevatedButton(
                          onPressed: () {
                            setState(
                                () {}); // Force rebuild to retry image loading
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    );
                  },
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget badrender_image() {
    return SizedBox(
      height: 800,
      width: 1600,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          crossAxisSpacing: 5.0,
          mainAxisSpacing: 5.0,
        ),
        itemCount: widget.list_image_bad_pool.length,
        itemBuilder: (context, index) {
          return Container(
            child: Column(
              children: [
                Row(
                  children: [
                    const SizedBox(
                      width: 25,
                    ),
                    Checkbox(
                      value: widget.list_bool_move_to_good[index],
                      onChanged: (bool? value) {
                        _toggleCheckbox_move_to_good(value, index);
                      },
                    ),
                    const Text("move to good"),
                    // SizedBox(width: 10,),
                    Checkbox(
                      value: widget.list_bool_del_bad[index],
                      onChanged: (bool? value) {
                        _toggleCheckbox_bad(value, index);
                      },
                    ),
                    const Text("delete"),
                    // SizedBox(width: 10,),
                    Checkbox(
                      value: widget.list_bool_save_to_bad[index],
                      onChanged: (bool? value) {
                        _toggleCheckbox_save_bad_to_dataset(value, index);
                      },
                    ),
                    const Text("save"),
                  ],
                ),
                CachedNetworkImage(
                  imageUrl:
                      "http://210.246.215.145:1234/show/bad/${widget.list_image_bad_pool[index]}",
                  height: 250,
                  // placeholder: (context, url) => const CircularProgressIndicator(),
                  placeholder: (context, url) => const SizedBox(
                    width: 250.0,
                    height: 100.0,
                    child: CircularProgressIndicator(
                      color: Color.fromARGB(255, 136, 32, 255),
                    ),
                  ),
                  errorWidget: (context, url, error) {
                    return Column(
                      children: [
                        const Icon(Icons.error),
                        ElevatedButton(
                          onPressed: () {
                            setState(
                                () {}); // Force rebuild to retry image loading
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    );
                  },
                )
              ],
            ),
          );
        },
      ),
    );
  }

  void set_mode_display() {
    setState(() {
      widget.display_swich = !widget.display_swich;
    });
  }

  @override
  Widget build(BuildContext context) {
    int windowsHight = ((MediaQuery.of(context).size).height).toInt();
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    if (width <= 1460) {
      return Center(
        child: Column(
          children: [
            Icon(
              Icons.warning_amber_outlined,
              color: Color.fromARGB(255, 255, 153, 0),
              size: 300,
            ),
            Text("website support only pc (1080 x 1920)")
          ],
        ),
      );
    } else {
      return Column(
        children: [
          SizedBox(
            width: 1300,
            height: 50,
            // color: Colors.amber,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CupertinoButton(
                  onPressed: () {
                    setState(() {
                      widget.display_swich = true;
                      runGetListFromGoodPool();
                    });
                  },
                  color: widget.display_swich
                      ? const Color.fromARGB(255, 138, 148, 209)
                      : const Color(0xFF5A67BA),
                  child: const SizedBox(
                    width: 150,
                    child: Text(
                      "Good",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(color: Colors.white, fontFamily: 'Poppins'),
                    ),
                  ),
                ),
                CupertinoButton(
                  onPressed: () {
                    setState(() {
                      widget.display_swich = false;
                      runGetListFromBadPool();
                    });
                  },
                  color: widget.display_swich
                      ? const Color(0xFF5A67BA)
                      : const Color.fromARGB(255, 138, 148, 209),
                  child: const SizedBox(
                    width: 150,
                    child: Text(
                      "Bad",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(color: Colors.white, fontFamily: 'Poppins'),
                    ),
                  ),
                ),
                CupertinoButton(
                  onPressed: () {
                    runPopupLoading();
                  },
                  color: const Color(0xFF5A67BA),
                  child: const SizedBox(
                    width: 150,
                    child: Text(
                      "Process",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(color: Colors.white, fontFamily: 'Poppins'),
                    ),
                  ),
                ),
                CupertinoButton(
                  onPressed: () {
                    runPopupLoading_move_to_train();
                  },
                  color: const Color(0xFF5A67BA),
                  child: const SizedBox(
                    width: 150,
                    child: Text(
                      "move to train",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(color: Colors.white, fontFamily: 'Poppins'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          widget.display_swich ? Goodrender_image() : badrender_image(),
        ],
      );
    }
  }
}

class DataCenter_for_train extends StatefulWidget {
  DataCenter_for_train({super.key});
  bool display_swich = true;

  //good pool
  List<String> list_image_good_pool = <String>[];
  late List GoodPool_list;

  //bad pool
  List<String> list_image_bad_pool = <String>[];
  late List badPool_list;

  @override
  State<DataCenter_for_train> createState() =>
      _DataCenter_WidgetState_fortrain_model();
}

class _DataCenter_WidgetState_fortrain_model
    extends State<DataCenter_for_train> {
  Future<void> runGetListFromGoodPool() async {
    final response = await http.get(
      Uri.parse(
          'http://210.246.215.145:1234/get_name_data_set_in_good_train'), // Replace with your backend URL
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      widget.GoodPool_list = responseData['files'];

      // widget.badPool_list = (responseData['files'] as List).sublist(0, 30);

      widget.list_image_good_pool = [];
      for (var i in widget.GoodPool_list) {
        widget.list_image_good_pool.add(i);
      }
    }
  }

  Future<void> runGetListFromBadPool() async {
    final response = await http.get(
      Uri.parse(
          'http://210.246.215.145:1234/get_name_data_set_in_bad_train'), // Replace with your backend URL
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      widget.badPool_list = responseData['files'];

      // widget.badPool_list = (responseData['files'] as List).sublist(0, 30);

      widget.list_image_bad_pool = [];
      for (var i in widget.badPool_list) {
        widget.list_image_bad_pool.add(i);
      }
    }
  }

  Future<void> move_all_to_pool() async {
    final response5 = await http.post(
      Uri.parse(
          'http://210.246.215.145:1234/move_or_delete_dataset_pool_to_train'),
      headers: {
        'Content-Type': 'application/json', // Set content type to JSON
      },
      body: jsonEncode({
        "mode": "train_to_pool",
      }),
    );
  }

  void runPopupLoading_move_to_pool() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text('Processing'),
              LoadingAnimationWidget.dotsTriangle(
                color: const Color.fromARGB(255, 106, 55, 248),
                size: 150,
              ),
              const SizedBox(height: 20),
              const Text('Please wait...'),
            ],
          ),
        );
      },
    );
    await move_all_to_pool();
    Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  void initState() {
    super.initState();
    // runGetListFromGoodPool();
    // runGetListFromBadPool();
    // runGetListFromGoodPool();
    // runGetListFromBadPool();
  }

  Widget Goodrender_image() {
    return SizedBox(
      height: 800,
      width: 1600,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          crossAxisSpacing: 5.0,
          mainAxisSpacing: 5.0,
        ),
        itemCount: widget.list_image_good_pool.length,
        itemBuilder: (context, index) {
          return Container(
            child: Column(
              children: [
                CachedNetworkImage(
                  imageUrl:
                      "http://210.246.215.145:1234/show/train_good/${widget.list_image_good_pool[index]}",
                  height: 250,
                  // placeholder: (context, url) => const CircularProgressIndicator(),
                  placeholder: (context, url) => const SizedBox(
                    width: 250.0,
                    height: 100.0,
                    child: CircularProgressIndicator(
                      color: Color.fromARGB(255, 136, 32, 255),
                    ),
                  ),
                  errorWidget: (context, url, error) {
                    return Column(
                      children: [
                        const Icon(Icons.error),
                        ElevatedButton(
                          onPressed: () {
                            setState(
                                () {}); // Force rebuild to retry image loading
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    );
                  },
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget badrender_image() {
    return SizedBox(
      height: 800,
      width: 1600,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          crossAxisSpacing: 5.0,
          mainAxisSpacing: 5.0,
        ),
        itemCount: widget.list_image_bad_pool.length,
        itemBuilder: (context, index) {
          return Container(
            child: Column(
              children: [
                CachedNetworkImage(
                  imageUrl:
                      "http://210.246.215.145:1234/show/train_bad/${widget.list_image_bad_pool[index]}",
                  height: 250,
                  // placeholder: (context, url) => const CircularProgressIndicator(),
                  placeholder: (context, url) => const SizedBox(
                    width: 250.0,
                    height: 100.0,
                    child: CircularProgressIndicator(
                      color: Color.fromARGB(255, 136, 32, 255),
                    ),
                  ),
                  errorWidget: (context, url, error) {
                    return Column(
                      children: [
                        const Icon(Icons.error),
                        ElevatedButton(
                          onPressed: () {
                            setState(
                                () {}); // Force rebuild to retry image loading
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    );
                  },
                )
              ],
            ),
          );
        },
      ),
    );
  }

  void set_mode_display() {
    setState(() {
      widget.display_swich = !widget.display_swich;
    });
  }

  @override
  Widget build(BuildContext context) {
    int windowsHight = ((MediaQuery.of(context).size).height).toInt();
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    if (width <= 1460) {
      return Center(
        child: Column(
          children: [
            Icon(
              Icons.warning_amber_outlined,
              color: Color.fromARGB(255, 255, 153, 0),
              size: 300,
            ),
            Text("website support only pc (1080 x 1920)")
          ],
        ),
      );
    } else {
      return Column(
        children: [
          SizedBox(
            width: 1300,
            height: 50,
            // color: Colors.amber,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CupertinoButton(
                  onPressed: () {
                    setState(() {
                      widget.display_swich = true;
                      runGetListFromGoodPool();
                    });
                  },
                  color: widget.display_swich
                      ? const Color.fromARGB(255, 138, 148, 209)
                      : const Color(0xFF5A67BA),
                  child: const SizedBox(
                    width: 150,
                    child: Text(
                      "Good",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(color: Colors.white, fontFamily: 'Poppins'),
                    ),
                  ),
                ),
                CupertinoButton(
                  onPressed: () {
                    setState(() {
                      widget.display_swich = false;
                      runGetListFromBadPool();
                    });
                  },
                  color: widget.display_swich
                      ? const Color(0xFF5A67BA)
                      : const Color.fromARGB(255, 138, 148, 209),
                  child: const SizedBox(
                    width: 150,
                    child: Text(
                      "Bad",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(color: Colors.white, fontFamily: 'Poppins'),
                    ),
                  ),
                ),
                CupertinoButton(
                  onPressed: () {
                    runPopupLoading_move_to_pool();
                  },
                  color: const Color(0xFF5A67BA),
                  child: const SizedBox(
                    width: 150,
                    child: Text(
                      "move to pool",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(color: Colors.white, fontFamily: 'Poppins'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          widget.display_swich
              ? Text("Images All : ${widget.list_image_good_pool.length}")
              : Text("Images All : ${widget.list_image_bad_pool.length}"),
          widget.display_swich ? Goodrender_image() : badrender_image(),
        ],
      );
    }
  }
}

_launchURL() async {
  final Uri url = Uri.parse(
      'https://colab.research.google.com/drive/1Yq_w4lpbOx-ALFTP9RZY-fkpBkhsoLQp?usp=sharing');
  if (!await launchUrl(url)) {
    throw Exception('Could not launch');
  }
}

_open_maskURL() async {
  final Uri url = Uri.parse('http://210.246.215.145:3501/video_feed_process_on');
  if (!await launchUrl(url)) {
    throw Exception('Could not launch');
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double? y;
}

class Model {
  final String version;
  final String rate;
  final String filename;
  final String mse;
  final String performance;
  final bool st_model_incom;

  Model(
      {required this.filename,
      required this.version,
      required this.rate,
      required this.mse,
      required this.performance,
      required this.st_model_incom});
}

class Hislist {
  final String name;
  final String tube_hight;
  final String tube_diameter;
  final String mm;
  final String px;
  final String id;
  Hislist(
      {required this.name,
      required this.tube_hight,
      required this.tube_diameter,
      required this.mm,
      required this.px,
      required this.id});
}

class ChartData_dasboard {
  final String x;
  final int y;
  // ChartData('01', 35);

  ChartData_dasboard(this.x, this.y);
}

Widget GUI_version_model_V2(
    String globalVersion, String globalMse1, String globalPerformance1) {
  double mseValue = double.parse(globalMse1);
  String globalMse = NumberFormat('0.000').format(mseValue);

  double mseValue1 = double.parse(globalPerformance1);
  String globalPerformance = NumberFormat('0.0').format(mseValue1);

  return Stack(
    children: [
      Container(
        width: 350,
        height: 350,
        color: const Color.fromARGB(255, 255, 255, 255),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Image.asset("images/canvas.png", fit: BoxFit.fill),
          ],
        ),
      ),
      Positioned(
        left: 90, // ระบุค่าพิกัด x
        top: 100, // ระบุค่าพิกัด y
        child: Text(
          globalVersion,
          style: const TextStyle(
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
      Positioned(
        left: 200, // ระบุค่าพิกัด x
        top: 150, // ระบุค่าพิกัด y
        child: Text(
          globalMse,
          style: const TextStyle(
              fontSize: 40,
              color: Color.fromARGB(255, 255, 255, 255),
              fontFamily: 'Poppins'),
        ),
      ),
      const Positioned(
        left: 230, // ระบุค่าพิกัด x
        top: 200, // ระบุค่าพิกัด y
        child: Text(
          "Loss",
          style: TextStyle(
              fontSize: 14,
              color: Color.fromARGB(255, 255, 255, 255),
              fontFamily: 'Poppins'),
        ),
      ),
      Positioned(
        left: 55, // ระบุค่าพิกัด x
        top: 240, // ระบุค่าพิกัด y
        child: Text(
          globalPerformance,
          style: const TextStyle(
              fontSize: 25,
              color: Color.fromARGB(255, 255, 255, 255),
              fontFamily: 'Poppins'),
        ),
      ),
      const Positioned(
        left: 45, // ระบุค่าพิกัด x
        top: 280, // ระบุค่าพิกัด y
        child: Text(
          "Accuracy",
          style: TextStyle(
              fontSize: 14,
              color: Color.fromARGB(255, 255, 255, 255),
              fontFamily: 'Poppins'),
        ),
      ),
    ],
  );
}

Widget List_command_display(List dataListCommand) {
  return Expanded(
    child: ListView.builder(
      itemCount: dataListCommand.length,
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const SizedBox(
                  width: 20,
                ),
                Text("$index ${dataListCommand[index]}"),
              ],
            ),
          ],
        );
      },
    ),
  );
}

List<double> _currentSliderSecondaryValue = [
  20,
  30,
  100,
  255,
  100,
  255,
  1,
  0,
  1,
  1
];
List<String> _nameSlider = [
  "Hue Min",
  "Hue Max",
  "Sat Min",
  "Sat Max",
  "Val Min",
  "Val MAX",
  "Brightness",
  "Contrast",
  "Saturation",
  "Range"
];
List<double> _max = [179, 179, 255, 255, 255, 255, 100, 15, 10, 1000];
List<double> _min = [1, 1, 1, 1, 1, 1, 1, -15, 1, 1];
List<int> _divisions = [179, 179, 255, 255, 255, 255, 100, 30, 10, 1000];

void mask_setting() async {
  final response = await http.post(
    Uri.parse(
        'http://210.246.215.145:2545/Setting_realtime_mask'), // Replace with your backend URL
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      "Hue_Min": _currentSliderSecondaryValue[0].toInt().toString(),
      "Hue_Max": _currentSliderSecondaryValue[1].toInt().toString(),
      "Sat_Min": _currentSliderSecondaryValue[2].toInt().toString(),
      "Sat_Max": _currentSliderSecondaryValue[3].toInt().toString(),
      "Val_Min": _currentSliderSecondaryValue[4].toInt().toString(),
      "Val_MAX": _currentSliderSecondaryValue[5].toInt().toString(),
      "Brightness": _currentSliderSecondaryValue[6].toInt().toString(),
      "Contrast": _currentSliderSecondaryValue[7].toInt().toString(),
      "Saturation": _currentSliderSecondaryValue[8].toInt().toString(),
      "Range": _currentSliderSecondaryValue[9].toInt().toString(),
    }),
  );
}

void mask_get_setting() async {
  final response = await http.get(
    Uri.parse(
        'http://210.246.215.145:3500/get_setting_mask'), // Replace with your backend URL
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    _currentSliderSecondaryValue[0] = (responseData['h_min']).toDouble();
    _currentSliderSecondaryValue[1] = (responseData['h_max']).toDouble();
    _currentSliderSecondaryValue[2] = (responseData['s_min']).toDouble();
    _currentSliderSecondaryValue[3] = (responseData['s_max']).toDouble();
    _currentSliderSecondaryValue[4] = (responseData['v_min']).toDouble();
    _currentSliderSecondaryValue[5] = (responseData['v_max']).toDouble();
    _currentSliderSecondaryValue[6] = (responseData['brightness']).toDouble();
    _currentSliderSecondaryValue[7] = (responseData['contrast']).toDouble();
    _currentSliderSecondaryValue[8] =
        (responseData['saturation_boost']).toDouble();
    _currentSliderSecondaryValue[9] = (responseData['range_detect']).toDouble();
  }
}

void mask_save_setting() async {
  final response = await http.get(
    Uri.parse(
        'http://210.246.215.145:3500/save_setting_detect_yellow'), // Replace with your backend URL
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
}

Widget Setting_mask() {
  // mask_get_setting();
  return Expanded(
    child: ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const SizedBox(
                  width: 50,
                ),
                Text(_nameSlider[index]),
              ],
            ),
            Slider(
              value: _currentSliderSecondaryValue[index],
              label: _currentSliderSecondaryValue[index].round().toString(),
              max: _max[index],
              min: _min[index],
              divisions: _divisions[index],
              onChanged: (double value) {
                _currentSliderSecondaryValue[index] = value;
                mask_setting();
              },
              // onChangeStart: (double value){
              //   mask_get_setting();
              // },
            ),
          ],
        );
      },
    ),
  );
}

Map<dynamic, dynamic> data_dashdoard_histry() {
  return {};
}

class GlobalData {
  static final GlobalData _instance = GlobalData._internal();
  factory GlobalData() {
    return _instance;
  }
  GlobalData._internal();

  // ข้อมูลที่ต้องการเก็บ
  List<Hislist> myData = [];

  // เมธอดที่ใช้ในการเข้าถึงและแก้ไขข้อมูล
  void addData(List<Hislist> data) {
    myData = data;
  }

  List<Hislist> getData() {
    return myData;
  }
}

class GlobalData_model_for_web {
  static final GlobalData_model_for_web _instance =
      GlobalData_model_for_web._internal();
  factory GlobalData_model_for_web() {
    return _instance;
  }
  GlobalData_model_for_web._internal();
  List<Model> myData = [];
  void addData(List<Model> data) {
    myData = data;
  }

  List<Model> getData() {
    return myData;
  }
}

Widget render_log_load(List<dynamic> data) {
  return ListView.builder(
    itemCount: data.length, // replace `models` with your data source
    itemBuilder: (context, index) {
      return ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(data[index][0]),
              const SizedBox(
                width: 100,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Detect status:${data[index][8]}"),
                  const SizedBox(
                    width: 20,
                  ),
                  data[index][8]
                      ? const Icon(
                          Icons.circle,
                          size: 20,
                          color: Colors.green,
                        )
                      : const Icon(
                          Icons.circle,
                          size: 20,
                          color: Colors.red,
                        )
                ],
              ),
              Text(
                  "H:${data[index][3]} P:${data[index][4]} V:${data[index][5]} D:${data[index][6]}"),
              Text("Qr:${data[index][7]}"),
              const SizedBox(
                width: 30,
              ),
            ],
          ),
          subtitle: const Divider(color: Colors.black));
    },
  );
}

class ai_process extends StatefulWidget {
  ai_process({super.key});

  bool st_notification = true;
  ValueNotifier<int> limit_bad_setting = ValueNotifier<int>(100);
  ValueNotifier<int> image_good_now = ValueNotifier<int>(0);
  ValueNotifier<int> image_bad_now = ValueNotifier<int>(0);

  @override
  State<ai_process> createState() => _ai_process();
}

class _ai_process extends State<ai_process> {
  final textLimit_setting = TextEditingController();
  void save_setting_limit_image() async {
    widget.limit_bad_setting;
    final response = await http.post(
      Uri.parse(
          'http://210.246.215.145:3500/setting_limit_bad_image'), // Replace with your backend URL
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'tube_mm_str': textLimit_setting.text,
      }),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
    }
  }

  void show_image_limit_set() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("setting (${widget.limit_bad_setting.value})"),
          content: SizedBox(
            height: 300,
            width: 300,
            child: Column(
              children: [
                SizedBox(
                  width: 400,
                  child: TextField(
                    controller: textLimit_setting,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Limit image',
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Save"),
              onPressed: () {
                save_setting_limit_image();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void use_now_setting() async {
    // final response = await http.get(
    //   Uri.parse(
    //       'http://210.246.215.145:3500/get_limit_bad_image'), // Replace with your backend URL
    //   headers: <String, String>{
    //     'Content-Type': 'application/json; charset=UTF-8',
    //   },
    // );
    // if (response.statusCode == 200) {
    //   final Map<String, dynamic> responseData = jsonDecode(response.body);
    //   widget.st_notification = responseData['limit_bad_image']['st'];
    //   widget.limit_bad_setting =
    //       ValueNotifier<int>(responseData['limit_bad_image']['setlimit_image']);
    //   widget.image_bad_now =
    //       ValueNotifier<int>(responseData['limit_bad_image']['image_pr_bad']);
    //   widget.image_good_now =
    //       ValueNotifier<int>(responseData['limit_bad_image']['image_pr_good']);

    // }
    setState(() {});
  }

  final bool _updating = false;
  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(milliseconds: 5000), (Timer timer) {
      if (!_updating) {
        use_now_setting();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Column(children: []);
  }
}
