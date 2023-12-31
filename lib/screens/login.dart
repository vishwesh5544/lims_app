import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:lims_app/bloc/login_bloc/login_bloc.dart";
import "package:lims_app/bloc/login_bloc/login_event.dart";
import "package:lims_app/bloc/login_bloc/login_state.dart";
import "package:lims_app/utils/form_submission_status.dart";
import "package:lims_app/utils/text_utility.dart";

import "../dashboard.dart";

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController(text: "admin@gmail.com");

  final TextEditingController _passwordController = TextEditingController(text: "12345678");
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 60.0),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/login_bg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox.fromSize(
                  size: const Size(500, 650),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                      // Form Column
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Form heading
                            Text('Scylex Labs', style: TextUtility.getBoldStyle(40.0, color: Colors.black)),
                            // Form sub heading
                            Text('Welcome Back', style: TextUtility.getBoldStyle(30.0, color: Colors.black)),
                            // Form instructions
                            const Text('Please enter your details to sign in'),
                            // Username/Email input field
                            _emailField(),
                            // Password input field
                            _passwordField(),
                            // Login button
                            _loginButton(context),
                            // Forgot password section
                            _getForgetPasswordSection(),
                            const SizedBox(
                              height: 150,
                            ),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('@Powered by Risamsoft Inc'),
                              ],
                            )
                          ]
                              .map((el) => Padding(padding: const EdgeInsets.symmetric(vertical: 5.0), child: el))
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _emailField() {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return TextFormField(
          controller: _emailController,
          onChanged: (value) => context.read<LoginBloc>().add(LoginEmailChanged(email: value)),
          decoration: const InputDecoration(
              labelText: "Username or Email", border: OutlineInputBorder(), hintText: "Enter username or email"),
        );
      },
    );
  }

  Widget _passwordField() {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return TextFormField(
          controller: _passwordController,
          onChanged: (value) => context.read<LoginBloc>().add(LoginPasswordChanged(password: value)),
          obscureText: true,
          decoration:
              const InputDecoration(labelText: "Password", border: OutlineInputBorder(), hintText: "Enter password"),
        );
      },
    );
  }

  Widget _loginButton(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        // if (state.formStatus is SubmissionSuccess) {
        // Navigator.pushReplacementNamed(context, RouteStrings.testMenu);
        // Parth_parth
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Dashboard()),
        );
        // }
      },
      builder: (context, state) {
        return state.formStatus is FormSubmitting
            ? const CircularProgressIndicator()
            : SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade700),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('LOGIN', style: TextUtility.getBoldStyle(15.0)),
                  ),
                  onPressed: () {
                    var formState = _formKey.currentState;
                    if (formState != null && formState.validate()) {
                      context
                          .read<LoginBloc>()
                          .add(LoginSubmitted(email: _emailController.text, password: _passwordController.text));
                    }
                  },
                ),
              );
      },
    );
  }

  Widget _getForgetPasswordSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        RichText(
            text: TextSpan(children: [
          TextSpan(text: "Forgot Password?", style: TextUtility.getBoldStyle(15.0, color: Colors.black)),
          const WidgetSpan(
              child: SizedBox(
            width: 4,
          )),
          TextSpan(
              text: "Reset now",
              style: const TextStyle(color: Colors.blue, fontSize: 15.0, fontWeight: FontWeight.bold),
              recognizer: TapGestureRecognizer()..onTap = () {})
        ]))
      ],
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
