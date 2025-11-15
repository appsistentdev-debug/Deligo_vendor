import 'package:equatable/equatable.dart';

abstract class SummaryEvent extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class FetchSummaryEvent extends SummaryEvent {
  final String duration;
  FetchSummaryEvent(this.duration);
  @override
  List<Object> get props => [duration];

  @override
  bool get stringify => true;
}

class FetchBestSellingEvent extends SummaryEvent {}
