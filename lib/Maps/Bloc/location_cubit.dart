import 'package:delivoo_store/JsonFiles/custom_location.dart';
import 'package:delivoo_store/UtilityFunctions/helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';

part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  Location location = Location();

  LocationCubit() : super(const LocationInitial());

  void initFetchCurrentLocation(bool freshLocation) async {
    emit(const LocationLoading());
    CustomLocation? savedLocation;
    if (!freshLocation) {
      savedLocation = await Helper().getSavedLocation();
      if (savedLocation != null) {
        emit(LocationLoaded(savedLocation.latitude, savedLocation.longitude));
      }
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.granted) {
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
      }
      if (serviceEnabled) {
        LocationData locationData = await location.getLocation();
        Helper().setSavedLocation(CustomLocation(
            locationData.latitude ?? 0, locationData.longitude ?? 0));
        if (freshLocation || savedLocation == null) {
          emit(LocationLoaded(locationData.latitude, locationData.longitude));
        }
      } else {
        if (freshLocation || savedLocation == null) {
          emit(const LocationFail("error_service"));
        }
      }
    } else {
      if (freshLocation || savedLocation == null) {
        emit(const LocationFail("error_permission"));
      }
    }
  }

  void initRequestLocationPermission() async {
    emit(const LocationLoading());
    PermissionStatus permissionGranted = await location.requestPermission();
    emit(LocationPermissionStatus(permissionGranted));
  }
}
