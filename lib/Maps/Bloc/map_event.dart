import 'package:equatable/equatable.dart';
import 'package:flutter_google_places_hoc081098/google_maps_webservice_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class MapEvent extends Equatable {
  @override
  List<Object?> get props => [];

  @override
  bool get stringify => true;
}

class UpdateCameraPositionEvent extends MapEvent {
  final CameraPosition position;

  UpdateCameraPositionEvent(this.position);

  @override
  List<Object> get props => [position];
}

class UpdateAddressEvent extends MapEvent {
  final CameraPosition position;

  UpdateAddressEvent(this.position);

  @override
  List<Object> get props => [position];
}

class LocationSelectedEvent extends MapEvent {
  final Prediction prediction;

  LocationSelectedEvent(this.prediction);

  @override
  List<Object?> get props => [prediction];
}

class MarkerMovedEvent extends MapEvent {}

class FetchCurrentLocation extends MapEvent {}

class SetCurrentLocation extends MapEvent {
  final String? address;
  final LatLng? latLng;
  SetCurrentLocation(this.address, this.latLng);
  @override
  List<Object?> get props => [address, latLng];
}

class ShowCardEvent extends MapEvent {}

class AddressSubmittedEvent extends MapEvent {
  final String title;
  final String formattedAddress;
  final String address1;
  final double longitude;
  final double latitude;

  AddressSubmittedEvent(this.title, this.formattedAddress, this.address1,
      this.longitude, this.latitude);

  @override
  List<Object> get props => [title, formattedAddress, longitude, latitude];
}
