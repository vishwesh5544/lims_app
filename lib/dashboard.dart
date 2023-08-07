import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:lims_app/models/patient.dart';
import 'package:lims_app/models/test.dart';
import 'package:lims_app/screens/lab_management.dart';
import 'package:lims_app/screens/login.dart';
import 'package:lims_app/screens/patient_management.dart';
import 'package:lims_app/screens/test_management.dart';
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
        preferredSize: Size(double.infinity, 500),
        child: Container(
          color: Colors.blue,
          padding: EdgeInsets.symmetric(
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
              InkWell(
                onTap: (){
                  SharedPreferences.getInstance().then((value) {
                    value.clear();
                  });
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),);
                },
                child: Container(
                    margin: EdgeInsets.all(20),
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      'LOGOUT',
                      style: TextUtility.getBoldStyle(28),
                    )),
              ),
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
              selectedColor: Colors.lightBlue,
              selectedTitleTextStyle: const TextStyle(color: Colors.white),
              selectedIconColor: Colors.white,
              backgroundColor: Colors.blue,
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
              sideMenuItem(index: 0, title: "Patient\n Management", isSelected: sideMenu.currentPage == 0),
              sideMenuItem(index: 1, title: "Test\n Management", isSelected: sideMenu.currentPage == 1),
              sideMenuItem(index: 2, title: "Lab\n Management", isSelected: sideMenu.currentPage == 2),
            ],
          ),
          Expanded(
            child: PageView(
              controller: pageController,
              children: const [PatientManagement(), TestManagement(), LabManagement()],
            ),
          ),
        ],
      ),
    );
  }

  sideMenuItem({required int index, required String title, bool isSelected = false}) {
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
                  const Icon(Icons.home, size: 40, color: Colors.white,),
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
}
