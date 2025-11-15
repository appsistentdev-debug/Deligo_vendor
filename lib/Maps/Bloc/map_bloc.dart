// ignore_for_file: deprecated_member_use

import 'package:bloc/bloc.dart';
import 'package:delivoo_store/JsonFiles/Auth/Responses/user_info.dart';
// No longer importing map_event.dart as cubits don't use events in the same way
// import 'package:delivoo_store/Maps/Bloc/map_event.dart';
import 'package:delivoo_store/Maps/Bloc/map_state.dart';
import 'package:delivoo_store/Maps/map_repository.dart';
import 'package:delivoo_store/OrderItemAccount/HomeRepository/home_repository.dart';
import 'package:delivoo_store/UtilityFunctions/helper.dart';
import 'package:flutter_google_places_hoc081098/google_maps_webservice_places.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapCubit extends Cubit<MapState> {
  HomeRepository _homeRepository = HomeRepository();
  MapRepository _mapRepository = MapRepository();
  bool _avoidFetchAddress = false;

  MapCubit()
      : super(MapState('', LatLng(20.5937, 78.9629), false, /*false,*/ false));

  // No need for mapEventToState or transformEvents in Cubit

  Future<void> updateCameraPosition(CameraPosition position) async {
    emit(MapState(state.formattedAddress, position.target, false, false));
    await _updateAddress(position); // Call the address update directly
  }

  Future<void> _updateAddress(CameraPosition position) async {
    print("_avoidFetchAddress: $_avoidFetchAddress");
    if (_avoidFetchAddress) {
      emit(MapState(state.formattedAddress, position.target, false, false));
    } else {
      String currentAddress = await _getAddress(position.target, true);
      emit(MapState(currentAddress, position.target, false, false));
    }
  }

  Future<void> locationSelected(Prediction prediction) async {
    PlaceDetails placeDetails =
        await _mapRepository.getPlaceDetails(prediction.placeId!);
    String? address = placeDetails.formattedAddress;
    LatLng latLng = _mapRepository.getLatLng(placeDetails);
    emit(MapState(address ?? "", latLng, true, false));
  }

  void markerMoved() {
    emit(MapState(state.formattedAddress, state.latLng, false, false));
  }

  Future<void> onFetchCurrentLocation(LatLng position) async {
    String currentAddress = "";
    LatLng latLng = LatLng(position.latitude, position.longitude);
    currentAddress = await _getAddress(latLng, true);
    emit(MapState(currentAddress, latLng, true, false));
  }

  Future<void> setCurrentLocation(String? address, LatLng latLng) async {
    _avoidFetchAddress = true;
    if (address == null) {
      String currentAddress = await _getAddress(latLng, true);
      emit(MapState(currentAddress, latLng, true, false));
    } else {
      emit(MapState(address, latLng, true, false));
    }
    Future.delayed(Duration(seconds: 2), () => _avoidFetchAddress = false);
  }

  Future<String> _getAddress(LatLng latLng, bool full) async {
    Placemark place = await _mapRepository.getPlaceMarkFromLatLng(latLng);
    print("Address For: ${place.toJson()}");
    String currentAddress = "";
    List<String> addressComponents = [];
    if (place.name != null && place.name!.isNotEmpty) {
      addressComponents.add(place.name!);
    }
    if (place.subThoroughfare != null && place.subThoroughfare!.isNotEmpty) {
      addressComponents.add(place.subThoroughfare!);
    }
    if (place.thoroughfare != null && place.thoroughfare!.isNotEmpty) {
      addressComponents.add(place.thoroughfare!);
    }
    if (place.subLocality != null && place.subLocality!.isNotEmpty) {
      addressComponents.add(place.subLocality!);
    }
    if (place.locality != null && place.locality!.isNotEmpty) {
      addressComponents.add(place.locality!);
    }
    if (place.subAdministrativeArea != null &&
        place.subAdministrativeArea!.isNotEmpty) {
      addressComponents.add(place.subAdministrativeArea!);
    }
    if (place.administrativeArea != null &&
        place.administrativeArea!.isNotEmpty) {
      addressComponents.add(place.administrativeArea!);
    }
    if (place.postalCode != null && place.postalCode!.isNotEmpty) {
      addressComponents.add(place.postalCode!);
    }
    if (place.country != null && place.country!.isNotEmpty) {
      addressComponents.add(place.country!);
    }
    addressComponents = [
      ...{...addressComponents}
    ];
    if (addressComponents.isNotEmpty) {
      currentAddress = full
          ? addressComponents.join(", ")
          : (double.tryParse(addressComponents[0]) == null
              ? addressComponents[0]
              : addressComponents[1]);
    }
    return currentAddress;
  }

  void showCard() {
    emit(MapState(state.formattedAddress, state.latLng, false, false));
  }

  Future<void> addressSubmitted(String title, String formattedAddress,
      String address1, double longitude, double latitude) async {
    await _homeRepository.postAddress(
        title, formattedAddress, address1, longitude, latitude);
    UserInformation? userInformation = await Helper().getUserInfo();
    if (userInformation == null) {
      emit(
          MapState(formattedAddress, LatLng(longitude, latitude), true, false));
    } else {
      emit(MapState(formattedAddress, LatLng(longitude, latitude), true, true));
    }
  }
}
