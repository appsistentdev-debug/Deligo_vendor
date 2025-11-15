abstract class SendToBankState {}

class SuccessSendToBankState extends SendToBankState {}

class FailureSendToBankState extends SendToBankState {
  final e;
  FailureSendToBankState(this.e);

  List<Object> get props => [e];
}

class LoadingSendToBankState extends SendToBankState {}

class InitialSendToBankState extends SendToBankState {}
