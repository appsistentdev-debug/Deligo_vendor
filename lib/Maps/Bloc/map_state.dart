import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapState extends Equatable {
  final String formattedAddress;
  final LatLng latLng;
  final bool toAnimateCamera;
  // final bool isCardShowing;
  final bool goToHomePage;

  MapState(this.formattedAddress, this.latLng, this.toAnimateCamera,
      /*this.isCardShowing,*/ this.goToHomePage);

  @override
  List<Object> get props => [
        formattedAddress,
        latLng,
        toAnimateCamera,
        /*isCardShowing,*/ goToHomePage
      ];

  @override
  bool get stringify => true;
}
