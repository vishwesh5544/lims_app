import "package:flutter_bloc/flutter_bloc.dart";
import "package:lims_app/bloc/login_bloc/login_event.dart";
import "package:lims_app/bloc/login_bloc/login_state.dart";
import "package:lims_app/repositories/user_repository.dart";
import "package:lims_app/utils/form_submission_status.dart";
import "package:lims_app/utils/lims_logger.dart";
import "package:shared_preferences/shared_preferences.dart";

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final IUserRepository userRepository;

  LoginBloc({required this.userRepository}) : super(LoginState());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginEmailChanged) {
      yield state.copyWith(email: event.email);
    } else if (event is LoginPasswordChanged) {
      yield state.copyWith(password: event.password);
    } else if (event is LoginSubmitted) {
      yield state.copyWith(formStatus: FormSubmitting());

      try {
        final res = await userRepository.loginUser(event.email, event.password);
        SharedPreferences.getInstance().then((value) {
          value.setBool("isLogin", true);
        });

        LimsLogger.log("*** User Fetched Successfully => ${res.data}");
        yield state.copyWith(formStatus: SubmissionSuccess());
      } on Exception catch (e) {
        yield state.copyWith(formStatus: SubmissionFailed(e));
      }
    }
  }
}
