import 'package:delivoo_store/AppConfig/app_config.dart';
import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_google_places_hoc081098/google_maps_webservice_places.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as l;
import 'package:permission_handler/permission_handler.dart';

class MapRepository {
  final Dio dio;

  MapRepository._(this.dio);

  factory MapRepository() {
    Dio dio = Dio();
    dio.options.headers = {
      "content-type": "application/json",
      'Accept': 'application/json'
    };
    return MapRepository._(dio);
  }

  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: AppConfig.googleApiKey);
  DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  l.Location location = l.Location();

  Future<Placemark> getPlaceMarkFromLatLng(LatLng latLng) async {
    List<Placemark> p =
        await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
    Placemark place = p[0];
    return place;
  }

  Future<LatLng?> getCurrentLocation() async {
    // bool serviceEnabled;
    // LocationPermission permission;
    // serviceEnabled = await Geolocator.isLocationServiceEnabled();
    // if (!serviceEnabled) {
    //   return Future.error('Location services are disabled.');
    // }
    // permission = await Geolocator.checkPermission();
    // if (permission == LocationPermission.denied) {
    //   permission = await Geolocator.requestPermission();
    //   if (permission == LocationPermission.denied) {
    //     return Future.error('Location permissions are denied');
    //   }
    // }
    // if (permission == LocationPermission.deniedForever) {
    //   return Future.error(
    //       'Location permissions are permanently denied, we cannot request permissions.');
    // }
    // return Geolocator.getCurrentPosition();

    l.PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.granted) {
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
      }
      if (serviceEnabled) {
        l.LocationData locationData = await location.getLocation();
        return LatLng(locationData.latitude ?? 0, locationData.longitude ?? 0);
      } else {
        return Future.error('Location services are disabled.');
      }
    } else {
      return Future.error('Location permissions are denied');
    }
  }

  Future<PlaceDetails> getPlaceDetails(String placeId) async {
    PlacesDetailsResponse response = await _places.getDetailsByPlaceId(placeId);
    return response.result;
  }

  Stream<DatabaseEvent> getDeliveryLatLng(int deliveryId) {
    return _databaseReference.child('deliveries/$deliveryId/location').onValue;
  }

  LatLng getLatLng(PlaceDetails placeDetails) {
    LatLng latLng = LatLng(placeDetails.geometry!.location.lat,
        placeDetails.geometry!.location.lng);
    return latLng;
  }

  Future<String> loadSilverMap(bool isDark) async {
    String mapStyle = await rootBundle.loadString(
        isDark ? 'assets/map_style_dark.json' : 'assets/map_style.json');
    return mapStyle;
  }

  Future<RouteInfo?> fetchRouteInfo(
      LatLng pickupLatLng, LatLng dropLatLng) async {
    final queryParameters = <String, dynamic>{};
    queryParameters["key"] = AppConfig.googleApiKey;
    queryParameters["origin"] =
        "${pickupLatLng.latitude},${pickupLatLng.longitude}";
    queryParameters["destination"] =
        "${dropLatLng.latitude},${dropLatLng.longitude}";
    Response<Map<String, dynamic>> _response =
        await dio.request<Map<String, dynamic>>(
            'https://maps.googleapis.com/maps/api/directions/json',
            queryParameters: queryParameters,
            options: Options(
              method: 'GET',
              headers: {},
              extra: {},
            ));
    Map<String, dynamic>? _result = _response.data;
    print("fetchRouteInfoStatus: ${_result?["status"]}");
    List<dynamic>? routes = _result?["routes"];
    if (routes != null && routes.isNotEmpty) {
      List<dynamic>? legs = routes[0]["legs"];
      double distance = 0;
      double duration = 0;
      if (legs != null && legs.isNotEmpty) {
        for (dynamic leg in legs) {
          print("distance: ${leg["distance"]["value"]}");
          print("duration: ${leg["duration"]["value"]}");
          distance += leg["distance"]["value"] is num
              ? leg["distance"]["value"]
              : double.tryParse(leg["distance"]["value"]) ?? 0;
          duration += leg["duration"]["value"] is num
              ? leg["duration"]["value"]
              : int.tryParse(leg["duration"]["value"]) ?? 0;
        }
      }
      return RouteInfo(
        decodeEncodedPolyline(routes[0]["overview_polyline"]["points"]),
        distance,
        duration.toInt(),
      );
    } else {
      return null;
    }
  }

  List<LatLng> decodeEncodedPolyline(String encoded) {
    List<LatLng> poly = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;
      LatLng p = new LatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble());
      poly.add(p);
    }
    return poly;
  }
}

class RouteInfo {
  final List<LatLng> polylineCoordinates;
  final double totalDistance;
  final int totalDuration;

  RouteInfo(
    this.polylineCoordinates,
    this.totalDistance,
    this.totalDuration,
  );

  @override
  String toString() =>
      'RouteInfo(polylineCoordinates: ${polylineCoordinates.length}, totalDistance: $totalDistance, totalDuration: $totalDuration)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RouteInfo &&
        listEquals(other.polylineCoordinates, polylineCoordinates) &&
        other.totalDistance == totalDistance &&
        other.totalDuration == totalDuration;
  }

  @override
  int get hashCode =>
      polylineCoordinates.hashCode ^
      totalDistance.hashCode ^
      totalDuration.hashCode;
}
