import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lims_app/bloc/login_bloc/login_bloc.dart';
import 'package:lims_app/bloc/patient_bloc/patient_bloc.dart';
import 'package:lims_app/bloc/test_bloc/test_bloc.dart';
import 'package:lims_app/dashboard.dart';
import 'package:lims_app/repositories/patient_repository.dart';
import 'package:lims_app/repositories/tests_repository.dart';
import 'package:lims_app/repositories/user_repository.dart';
import 'package:lims_app/screens/test_management.dart';
import "package:lims_app/utils/router.dart";
import 'package:lims_app/screens/login.dart';
import 'package:lims_app/screens/patient_management.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:side_navigation/side_navigation.dart';

Future<void> main() async {
  SharedPreferences value = await SharedPreferences.getInstance();
  runApp( MyApp(value));
}

class MyApp extends StatelessWidget {
  SharedPreferences instance;
  MyApp(this.instance, {super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<UserRepository>(create: (context) => UserRepository()),
        RepositoryProvider<TestRepository>(create: (context) => TestRepository()),
        RepositoryProvider<PatientRepository>(create: (context) => PatientRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<LoginBloc>(create: (context) => LoginBloc(userRepository: context.read<UserRepository>())),
          BlocProvider<TestBloc>(create: (context) => TestBloc(testRepository: context.read<TestRepository>())),
          BlocProvider<PatientBloc>(
              create: (context) => PatientBloc(patientRepository: context.read<PatientRepository>()))
        ],
        child: MaterialApp(
          title: 'LIMS Application',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          onGenerateRoute: LimsRouter.generateRoute,
          home: Dashboard()/*instance.getBool("isLogin") == true ? const Dashboard() : const LoginScreen(),*/
        ),
      ),
    );
  }
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  List<Widget> screens = [const PatientManagement(), const TestManagement()];
  /// The currently selected index of the bar
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SideNavigationBar(
            selectedIndex: _selectedIndex,
            items: const [
              SideNavigationBarItem(icon: Icons.add, label: "Patient Management"),
              SideNavigationBarItem(icon: Icons.add, label: "Test Management")
            ],
            onTap: (value) {
              setState(() {
                _selectedIndex = value;
              });
            },
          ),
          Expanded(child: screens.elementAt(_selectedIndex))
        ],
      ),
    );
  }
}
