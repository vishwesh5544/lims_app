import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lims_app/bloc/in_transit_bloc/in_transit_bloc.dart';
import 'package:lims_app/bloc/in_transit_bloc/in_transit_event.dart';
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
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PageController pageController = PageController();
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
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
                onTap: () {
                  showToast(msg: "LIMS");
                },
                child: Container(
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.symmetric(horizontal: 40),
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
          LayoutBuilder(builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: NavigationRail(
                    useIndicator: true,
                    backgroundColor: ColorProvider.blueDarkShade,
                    selectedIndex: currentIndex,
                    indicatorColor: Colors.black,
                    labelType: NavigationRailLabelType.all,
                    onDestinationSelected: (value) {
                      pageController.jumpToPage(value);
                    },
                    // style: SideMenuStyle(
                    //     // showTooltip: false,
                    //     compactSideMenuWidth: 100,
                    //     openSideMenuWidth: 200,
                    //     displayMode: SideMenuDisplayMode.open,
                    //     hoverColor: Colors.blue[100],
                    //     selectedHoverColor: Colors.blue[100],
                    //     selectedColor: ColorProvider.blueDarkShade,
                    //     selectedTitleTextStyle: const TextStyle(color: Colors.white),
                    //     selectedIconColor: Colors.white,

                    // decoration: BoxDecoration(
                    //   borderRadius: BorderRadius.all(Radius.circular(10)),
                    // ),
                    // backgroundColor: Colors.blueGrey[700]
                    // ),

                    destinations: [
                      sideMenuItem(
                          index: 0,
                          title: "Patient Management",
                          iconName: "ic_management",
                          isSelected: currentIndex == 0),
                      sideMenuItem(
                          index: 1,
                          title: "Test Management",
                          iconName: "ic_Layer",
                          isSelected: currentIndex == 1),
                      sideMenuItem(
                          index: 2,
                          title: "Sample Management",
                          iconName: "ic_chemistry",
                          isSelected: currentIndex == 2),
                      sideMenuItem(
                          index: 3,
                          title: "In Transit Management",
                          iconName: "ic_in_transit_mgmt",
                          isSelected: currentIndex == 3),
                      sideMenuItem(
                          index: 4,
                          title: "Process Management",
                          iconName: "ic_process_mgmt",
                          isSelected: currentIndex == 4),
                      sideMenuItem(
                          index: 5,
                          title: "Lab Management",
                          iconName: "ic_Lab_Report",
                          isSelected: currentIndex == 5),
                      sideMenuItem(
                          index: 6,
                          title: "Test Status",
                          iconName: "ic_processing_time",
                          isSelected: currentIndex == 6),
                    ],
                  ),
                ),
              ),
            );
          }),
          Expanded(
            child: PageView(
              onPageChanged: (value) {
                setState(() {
                  currentIndex = value;
                });
                // TODO : Shouldn't be done like this
                // This is done because we want to reset bloc when we move between mgmt pages
                if ([2, 3, 4].contains(value)) {
                  context.read<InTransitBloc>().add(ResetState());
                }
              },
              physics: const NeverScrollableScrollPhysics(),
              controller: pageController,
              children: const [
                PatientManagement(),
                TestManagement(),
                SampleManagement(),
                TransitManagement(),
                ProcessManagement(),
                LabManagement(),
                TestStatus(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  sideMenuItem(
      {required int index,
      String iconName = "ic_home",
      required String title,
      bool isSelected = false}) {
    return NavigationRailDestination(
      indicatorColor: Colors.black,
      icon: Image.asset(
        "assets/$iconName.png",
        height: 26,
        width: 26,
        color: Colors.transparent,
      ),
      label: Text(
        title,
        style: TextUtility.getStyle(18, color: Colors.white),
        textAlign: TextAlign.center,
      ),
    );
  }

  logoutWidget() {
    return Row(
      children: [
        const Icon(
          Icons.notifications,
          size: 30,
          color: Colors.white,
        ),
        InkWell(
          onTap: () {
            SharedPreferences.getInstance().then((value) {
              value.clear();
            });
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
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
