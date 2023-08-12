import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:lims_app/models/patient.dart';
import 'package:lims_app/models/test.dart';
import 'package:lims_app/screens/lab_management.dart';
import 'package:lims_app/screens/login.dart';
import 'package:lims_app/screens/patient_management.dart';
import 'package:lims_app/screens/process_management.dart';
import 'package:lims_app/screens/sample_management.dart';
import 'package:lims_app/screens/test_management.dart';
import 'package:lims_app/screens/test_status.dart';
import 'package:lims_app/screens/transit_management.dart';
import 'package:lims_app/utils/color_provider.dart';
import 'package:lims_app/utils/text_utility.dart';
import 'package:lims_app/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'easy_sidemenu Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'easy_sidemenu Demo'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PageController pageController = PageController();
  SideMenuController sideMenu = SideMenuController();

  @override
  void initState() {
    sideMenu.addListener((index) {
      pageController.jumpToPage(index);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 500),
        child: Container(
          color: ColorProvider.blueDarkShade,
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: (){
                  showToast(msg: "LIMS");
                },
                child: Container(
                    margin: EdgeInsets.all(20),
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      'LIMS',
                      style: TextUtility.getBoldStyle(28),
                    )),
              ),
              logoutWidget()
            ],
          ),
        ),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SideMenu(
            controller: sideMenu,
            style: SideMenuStyle(
              // showTooltip: false,
              compactSideMenuWidth: 100,
              openSideMenuWidth: 200,
              displayMode: SideMenuDisplayMode.auto,
              hoverColor: Colors.blue[100],
              selectedHoverColor: Colors.blue[100],
              selectedColor: ColorProvider.blueDarkShade,
              selectedTitleTextStyle: const TextStyle(color: Colors.white),
              selectedIconColor: Colors.white,
              backgroundColor: ColorProvider.blueDarkShade
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.all(Radius.circular(10)),
              // ),
              // backgroundColor: Colors.blueGrey[700]
            ),
            footer: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                // decoration: BoxDecoration(
                //     color: Colors.lightBlue[100],
                //     borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                  child: Text(
                    '',
                    style: TextStyle(fontSize: 15, color: Colors.grey[800]),
                  ),
                ),
              ),
            ),
            items: [
              sideMenuItem(index: 0, title: "Patient\n Management", iconName: "ic_management",isSelected: sideMenu.currentPage == 0),
              // sideMenuItem(index: 1, title: "Test\n Management", iconName: "ic_Layer",isSelected: sideMenu.currentPage == 1),
              // sideMenuItem(index: 2, title: "Sample\n Management", iconName: "ic_chemistry", isSelected: sideMenu.currentPage == 2),
              // sideMenuItem(index: 3, title: "In Transit\n Management", iconName: "ic_in_transit_mgmt", isSelected:
              // sideMenu
              //     .currentPage == 3),
              // sideMenuItem(index: 4, title: "Process\n Management",iconName: "ic_process_mgmt", isSelected: sideMenu
              //     .currentPage == 4),
              // sideMenuItem(index: 5, title: "Lab\n Management", iconName: "ic_Lab_Report",isSelected: sideMenu.currentPage == 5),
              // sideMenuItem(index: 6, title: "Test\n Status", iconName: "ic_processing_time",isSelected: sideMenu.currentPage == 6),
            ],
          ),
          Expanded(
            child: PageView(
              controller: pageController,
              children: const [
                PatientManagement(),
                // TestManagement(),
                // SampleManagement(),
                // TransitManagement(),
                // ProcessManagement(),
                // LabManagement(),
                // TestStatus(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  sideMenuItem({required int index, String iconName = "ic_home",required String title, bool isSelected = false}) {
    return SideMenuItem(
      builder: (context, displayMode) {
        return InkWell(
          onTap: () {
            setState(() {
              sideMenu.changePage(index);
            });
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 2),
            padding: const EdgeInsets.symmetric(vertical: 10),
            color: isSelected ? Colors.black: Colors.transparent,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset("assets/$iconName.png",
                  height: 26, width: 26, color: Colors.transparent,),
                  // const Icon(Icons.home, size: 40, color: Colors.white,),
                  Text(title,
                      style: TextUtility.getStyle(18, color: Colors.white),
                      textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  logoutWidget() {
    return Row(
      children: [
        const Icon(Icons.notifications, size: 30, color: Colors.white,),
        InkWell(
          onTap: (){
            SharedPreferences.getInstance().then((value) {
              value.clear();
            });
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),);
          },
          child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'LOGOUT',
                style: TextUtility.getBoldStyle(28),
              )),
        ),
      ],
    );
  }
}
