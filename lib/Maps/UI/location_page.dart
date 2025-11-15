import 'package:delivoo_store/Components/confirm_dialog.dart';
import 'package:delivoo_store/Components/show_toast.dart';
import 'package:delivoo_store/Maps/Bloc/location_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:flutter_google_places_hoc081098/google_maps_webservice_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:delivoo_store/AppConfig/app_config.dart';
import 'package:delivoo_store/Components/bottom_bar.dart';
import 'package:delivoo_store/Components/custom_appbar.dart';
import 'package:delivoo_store/Components/search_bar.dart';
import 'package:delivoo_store/Locale/locales.dart';
import 'package:delivoo_store/Maps/Bloc/map_bloc.dart';
import 'package:delivoo_store/Maps/Bloc/map_state.dart';
import 'package:delivoo_store/Maps/map_repository.dart';
import 'package:delivoo_store/Themes/colors.dart';
import 'package:delivoo_store/Themes/style.dart';
import 'package:delivoo_store/theme_cubit.dart';

class LocationPage extends StatelessWidget {
  final String? address;
  final LatLng? latLng;

  LocationPage([this.address, this.latLng]);

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider<MapCubit>(
            create: (context) => MapCubit(),
          ),
          BlocProvider<LocationCubit>(
            create: (context) => LocationCubit(),
          ),
        ],
        child: SetLocation(this.address, this.latLng),
      );
}

class SetLocation extends StatefulWidget {
  final String? address;
  final LatLng? latLng;

  SetLocation(this.address, this.latLng);

  @override
  _SetLocationState createState() => _SetLocationState();
}

class _SetLocationState extends State<SetLocation> {
  late MapCubit _mapBloc;
  late LocationCubit _locationCubit;
  late ThemeCubit _themeCubit;
  late GoogleMapController _googleMapController;

  @override
  void initState() {
    super.initState();
    _themeCubit = BlocProvider.of<ThemeCubit>(context);
    _mapBloc = BlocProvider.of<MapCubit>(context);
    _locationCubit = BlocProvider.of<LocationCubit>(context);
    if (widget.latLng == null) {
      _locationCubit.initFetchCurrentLocation(true);
    } else {
      _mapBloc.setCurrentLocation(widget.address, widget.latLng!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LocationCubit, LocationState>(
          listener: (context, state) {
            //setState(() => _geoLocating = state is LocationLoading);

            if (state is LocationPermissionStatus) {
              if (state.isPermissionGranted()) {
                _locationCubit.initFetchCurrentLocation(false);
              } else {
                showToast(AppLocalizations.of(context)!
                    .getTranslationOf("error_permission"));
              }
            }
            if (state is LocationFail) {
              if (state.msgKey == "error_permission") {
                ConfirmDialog.showConfirmation(
                        context,
                        AppLocalizations.of(context)!
                            .getTranslationOf("location_services"),
                        AppLocalizations.of(context)!
                            .getTranslationOf("location_services_msg"),
                        null,
                        AppLocalizations.of(context)!.getTranslationOf("okay"))
                    .then((value) {
                  if (value != null && value == true) {
                    _locationCubit.initRequestLocationPermission();
                  }
                });
              } else {
                showToast(AppLocalizations.of(context)!
                    .getTranslationOf("error_service"));
              }
            }
            if (state is LocationLoaded) {
              LatLng latLng =
                  LatLng(state.lattitude ?? 0.0, state.longitude ?? 0.0);
              _mapBloc.onFetchCurrentLocation(latLng);
            }
          },
        ),
        BlocListener<MapCubit, MapState>(
          listener: (context, state) async {
            if (state.toAnimateCamera) {
              CameraUpdate cameraUpdate = CameraUpdate.newLatLng(state.latLng);
              await _googleMapController.animateCamera(cameraUpdate);
              _mapBloc.markerMoved();
              //_mapBloc.add(MarkerMovedEvent());
            }
            if (state.goToHomePage) {
              Navigator.pop(context, [state.formattedAddress, state.latLng]);
            }
          },
        ),
      ],
      child: BlocBuilder<MapCubit, MapState>(
        builder: (context, state) => Scaffold(
//          extendBodyBehindAppBar: true,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(50.0),
            child: CustomAppBar(
              titleWidget: Text(
                AppLocalizations.of(context)!.storeAddress,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(height: 8.0),
              Expanded(
                child: Stack(
                  children: <Widget>[
                    GoogleMap(
                      initialCameraPosition:
                          CameraPosition(target: state.latLng, zoom: 16.0),
                      onCameraMove: state.toAnimateCamera ? null : onCameraMove,
                      mapType: MapType.normal,
                      myLocationEnabled: false,
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                      onMapCreated: (GoogleMapController controller) async {
                        _googleMapController = controller;
                        String mapStyle = await MapRepository()
                            .loadSilverMap(_themeCubit.isDark);
                        // ignore: deprecated_member_use
                        _googleMapController.setMapStyle(mapStyle);
                      },
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: PreferredSize(
                        preferredSize: Size.fromHeight(0.0),
                        child: CustomSearchBar(
                          onTap: () => _getPrediction(),
                          hint: AppLocalizations.of(context)!.enterLocation,
                          color: kWhiteColor,
                          readOnly: true,
                          autofocus: false,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 36.0),
                        child: CircleAvatar(
                          backgroundColor: kMainColor,
                          child: Icon(
                            Icons.location_on,
                            color: kWhiteColor,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: GestureDetector(
                        onTap: () =>
                            _locationCubit.initFetchCurrentLocation(true),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: kLightTextColor,
                          ),
                          margin: EdgeInsets.all(16),
                          padding: EdgeInsets.all(8),
                          child: Icon(Icons.gps_fixed),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: kWhiteColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!
                          .getTranslationOf("select_address"),
                      style: titleTextStyle,
                    ),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () => _getPrediction(),
                      child: Row(
                        children: <Widget>[
                          CircleAvatar(
                            backgroundColor: kMainColor,
                            child: Icon(
                              Icons.location_on,
                              color: kWhiteColor,
                            ),
                          ),
                          SizedBox(width: 16.0),
                          Expanded(
                            child: Text(
                              state.formattedAddress,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // state.isCardShowing ? SaveAddressCard() : Container(),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: BottomBar(
                    text: AppLocalizations.of(context)!.continueText,
                    onTap: () => Navigator.pop(
                        context, [state.formattedAddress, state.latLng])),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onCameraMove(CameraPosition position) {
    _mapBloc.updateCameraPosition(position);
  }

  void onLocationSelected(Prediction prediction) async {
    _mapBloc.locationSelected(prediction);
  }

  _getPrediction() async {
    Prediction? prediction = await PlacesAutocomplete.show(
      context: context,
      apiKey: AppConfig.googleApiKey,
      language: 'en',
      mode: Mode.fullscreen,
      cursorColor: kMainColor,
      resultTextStyle: Theme.of(context).textTheme.bodyMedium,
      textStyle: Theme.of(context).textTheme.headlineMedium,
      onError: (response) => print(response),
    );
    if (prediction != null) onLocationSelected(prediction);
  }
}

// class SaveAddressCard extends StatefulWidget {
//   @override
//   _SaveAddressCardState createState() => _SaveAddressCardState();
// }
//
// class _SaveAddressCardState extends State<SaveAddressCard> {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: 8.0),
//           child: EntryField(
//             controller: _addressController,
//             label:
//                 'FLAT NUM, LANDMARK, APARTMENT, ETC.' /*AppLocalizations.of(context)!.addressLabel*/,
//           ),
//         ),
//         // Padding(
//         //   padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//         //   child: Text(
//         //     'Save Address as'/*AppLocalizations.of(context)!.saveAddress*/,
//         //     style: Theme.of(context).textTheme.titleSmall,
//         //   ),
//         // ),
//         // Padding(
//         //   padding: EdgeInsets.only(bottom: 16.0),
//         //   child: Row(
//         //     mainAxisAlignment: MainAxisAlignment.spaceAround,
//         //     children: <Widget>[
//         //       AddressTypeButton(
//         //         label: AppLocalizations.of(context)!.homeText,
//         //         image: 'assets/address/ic_homeblk.png',
//         //         onPressed: () {
//         //           setState(() {
//         //             selectedAddress = AddressType.Home;
//         //           });
//         //         },
//         //         isSelected: selectedAddress == AddressType.Home,
//         //       ),
//         //       AddressTypeButton(
//         //         label: 'Office'/*AppLocalizations.of(context)!.office*/,
//         //         image: 'assets/address/ic_officeblk.png',
//         //         onPressed: () {
//         //           setState(() {
//         //             selectedAddress = AddressType.Office;
//         //           });
//         //         },
//         //         isSelected: selectedAddress == AddressType.Office,
//         //       ),
//         //       AddressTypeButton(
//         //         label: 'Other'/*AppLocalizations.of(context)!.other*/,
//         //         image: 'assets/address/ic_otherblk.png',
//         //         onPressed: () {
//         //           setState(() {
//         //             selectedAddress = AddressType.Other;
//         //           });
//         //         },
//         //         isSelected: selectedAddress == AddressType.Other,
//         //       ),
//         //     ],
//         //   ),
//         // )
//       ],
//     );
//   }
// }
