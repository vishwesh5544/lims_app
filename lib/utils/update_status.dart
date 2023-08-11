abstract class UpdateStatus {
  const UpdateStatus();
}

class InitialUpdateStatus extends UpdateStatus {
  const InitialUpdateStatus();
}

class Updating extends UpdateStatus {}

class Updated extends UpdateStatus {}

class UpdatingFailed extends UpdateStatus {
  final Exception exception;

  UpdatingFailed({required this.exception});
}
