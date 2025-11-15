import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:delivoo_store/JsonFiles/custom_location.dart';
import 'package:delivoo_store/Maps/map_repository.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'order_map_event.dart';
import 'order_map_state.dart';

class OrderMapBloc extends Bloc<OrderMapEvent, OrderMapState> {
  final int orderId;
  final LatLng _pickupLatLng;
  final LatLng _dropLatLng;
  final String _instruction;
  final bool isDark;
  int? delId;

  OrderMapBloc(this.orderId, this._pickupLatLng, this._dropLatLng,
      this._instruction, this.delId, this.isDark)
      : super(OrderMapState(
          Markers(
              getMarker(
                  _pickupLatLng, 'pickup', BitmapDescriptor.defaultMarker),
              getMarker(_dropLatLng, 'drop',
                  BitmapDescriptor.defaultMarkerWithHue(90)),
              null),
          {},
          _pickupLatLng,
          _dropLatLng,
          _instruction,
          null,
        ));

  MapRepository _mapRepository = MapRepository();
  StreamSubscription? _subscription;

  @override
  Stream<OrderMapState> mapEventToState(OrderMapEvent event) async* {
    if (event is LoadPageEvent) {
      yield* _mapLoadingPageEventToState();
    } else if (event is AddDeliveryIdEvent) {
      if (delId != event.deliveryId) {
        delId = event.deliveryId;
        _mapAddDeliveryMarkerToState(event.deliveryId);
      }
    } else if (event is UpdateDeliveryMarkerEvent) {
      yield* _mapUpdateDeliveryMarkerToState(event.deliveryMarker);
    }
  }

  Stream<OrderMapState> _mapLoadingPageEventToState() async* {
    RouteInfo? routeInfo =
        await _mapRepository.fetchRouteInfo(_pickupLatLng, _dropLatLng);
    Marker sourceMarker = await getPickupMarker(_pickupLatLng);
    Marker destMarker = await getDropMarker(_dropLatLng);

    Markers markers = Markers(sourceMarker, destMarker, null);
    Set<Polyline> polylines = Set();
    if (routeInfo != null) {
      Polyline polyline = await _getPolyLine(routeInfo.polylineCoordinates);
      polylines.add(polyline);
    }
    yield OrderMapState(
        markers, polylines, _pickupLatLng, _dropLatLng, _instruction, null);
    _mapAddDeliveryMarkerToState(delId);
  }

  Future<Marker> getDropMarker(LatLng latLng) async {
    BitmapDescriptor bitmapDescriptor = await BitmapDescriptor.asset(
        ImageConfiguration(size: Size(24, 24)), 'assets/icons/map_icon2.png');
    return getMarker(latLng, 'drop', bitmapDescriptor);
  }

  Future<Marker> getPickupMarker(LatLng latLng) async {
    BitmapDescriptor bitmapDescriptor = await BitmapDescriptor.asset(
        ImageConfiguration(size: Size(24, 24)), 'assets/icons/map_icon1.png');
    return getMarker(latLng, 'pickup', bitmapDescriptor);
  }

  _mapAddDeliveryMarkerToState(int? deliveryId) {
    if (deliveryId == null) return;
    _subscription?.cancel();
    _subscription =
        _mapRepository.getDeliveryLatLng(deliveryId).listen((event) async {
      var descriptor = await getMarkerPic();
      if (event.snapshot.value != null &&
          event.snapshot.value is Map &&
          (event.snapshot.value as Map).containsKey("latitude") &&
          (event.snapshot.value as Map).containsKey("longitude")) {
        CustomLocation location = CustomLocation.fromJson(
            jsonDecode(jsonEncode(event.snapshot.value)));
        var deliveryMarker = getMarker(
            LatLng(location.latitude, location.longitude),
            'delivery',
            descriptor);
        add(UpdateDeliveryMarkerEvent(deliveryMarker));
      }
    });
  }

  Stream<OrderMapState> _mapUpdateDeliveryMarkerToState(
      Marker delivery) async* {
    var markers = Markers.updateDelivery(state.markers, delivery);
    yield OrderMapState.updateMarkers(state, markers);
  }

  Future<BitmapDescriptor> getMarkerPic() {
    return BitmapDescriptor.asset(
        ImageConfiguration(devicePixelRatio: 2.5), 'assets/deliveryman.png');
  }

  static Marker getMarker(
      LatLng latLng, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
        Marker(markerId: markerId, icon: descriptor, position: latLng);
    return marker;
  }

  Future<Polyline> _getPolyLine(List<LatLng> points) async {
    PolylineId id = PolylineId('poly_$orderId');
    Polyline polyline = Polyline(
        width: 3,
        color: isDark ? Colors.white : Colors.black,
        polylineId: id,
        points: points);
    return polyline;
  }
}
