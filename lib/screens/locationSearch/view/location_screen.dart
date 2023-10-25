import 'package:bagisto_app_demo/Configuration/mobikul_theme.dart';
import 'package:bagisto_app_demo/screens/cart_screen/view/cart_index.dart';
import 'package:bagisto_app_demo/screens/locationSearch/view/place_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;

import '../../../common_widget/loader.dart';
import '../../../configuration/app_global_data.dart';
import '../../../configuration/app_sizes.dart';
import '../bloc/location_bloc.dart';
import '../repository/location_repository.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({Key? key}) : super(key: key);

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  double? latitude;
  double? longitude;
  late LatLng position;
  location.Location currentLocation = location.Location();
  GoogleMapController? _controller;
  String address = '';
  Map<String, dynamic> addressMap = {};

  @override
  void initState() {
    getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Directionality(
      textDirection: GlobalData.contentDirection(),
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: ((latitude != null) && (longitude != null))
                  ? Stack(children: [
                      GoogleMap(
                        zoomControlsEnabled: false,
                        initialCameraPosition: CameraPosition(
                          target:     LatLng(-33.870840,151.206286)/*LatLng(
                              latitude ?? 28.6296987, longitude ?? 77.3762753)*/,
                          zoom: 16.0,
                        ),
                        onMapCreated: (GoogleMapController controller) {
                          _controller = controller;
                        },
                        onCameraMove: (positions) {
                          setState(() {
                            position = positions.target;
                          });
                        },
                        onCameraIdle: () {
                          getLocation(position);
                          setState(() {
                            address = '';
                          });
                        },
                      ),
                      Positioned(
                          right: 0,
                          top: 0,
                          left: 0,
                          bottom: 0,
                          child: Icon(
                            Icons.location_pin,
                            color: MobikulTheme.notInStockLabelColor,
                            size: 40,
                          )),
                      Positioned(
                          bottom: 15,
                          right: 15,
                          child: InkWell(
                            onTap: getCurrentLocation,
                            child: CircleAvatar(
                              backgroundColor: MobikulTheme.accentColor,
                              child: const Icon(
                                Icons.my_location_sharp,
                                color: Colors.white,
                              ),
                            ),
                          )),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BlocProvider(
                                      create: (context) => LocationScreenBloc(
                                          repository: LocationRepositoryImp()),
                                      child: const PlaceSearch()))).then((value) {
                            if (value is LatLng) {
                              placeSearch(value);
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(AppSizes.mediumPadding),
                          margin: const EdgeInsets.all(AppSizes.mediumPadding),
                          color: Theme.of(context).cardColor,
                          child:  Row(
                            children: [
                              const Icon(Icons.search),
                              const SizedBox(
                                width: AppSizes.extraPadding,
                              ),
                              Text(
                                "SearchLocation".localized(),
                                style: const TextStyle(color: Colors.grey),
                              )
                            ],
                          ),
                        ),
                      ),
                    ])
                  : Loader(),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context, addressMap);
              },
              child: Container(
                padding: const EdgeInsets.all(AppSizes.extraPadding),
                height: AppSizes.height / 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Row(
                      children: [
                        const Icon(
                          Icons.location_pin,
                        ),
                        const SizedBox(
                          width: AppSizes.mediumPadding,
                        ),
                        Text(
                          "SelectLocation".localized(),
                          style: const TextStyle(color: Colors.grey),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: AppSizes.extraPadding,
                    ),
                    (address != '')
                        ? Flexible(
                            child: Text(
                            address,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(color: Colors.grey[600]),
                          ))
                        :  Text(
                            "PleaseWait".localized(),
                            style: const TextStyle(color: Colors.black),
                          )
                    // GenericMethods.getStringValue(context, AppStrings.loadingMessage),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void getCurrentLocation() async {
    dynamic location;
    try {
      location = await currentLocation.getLocation();
    } catch (e) {
      Navigator.pop(context);
    }
    setState(() {
      latitude = location.latitude  ?? 28.6296987;
      longitude = location.longitude  ?? 77.3762753;
    });
    position = LatLng(latitude ?? 28.6296987, longitude ?? 77.3762753);
    Geolocator.getCurrentPosition().then((Position position) {
      _controller?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(latitude ?? 28.6296987, longitude ?? 77.3762753),
        zoom: 16.0,
      )));
    });
  }

  void placeSearch(LatLng location) {
    setState(() {
      latitude = location.latitude;
      longitude = location.longitude;
      debugPrint("latitude===>$latitude");
      debugPrint("latitude===>$longitude");
    });
    position = LatLng(latitude!, longitude!);
    Geolocator.getCurrentPosition().then((Position position) {
    _controller?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(latitude ?? 28.6296987, longitude ?? 77.3762753),
      zoom: 16.0,
    )));
    getLocation(location);
    });
  }

  void getLocation(LatLng latLng) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
    setState(() {
      if ((placemarks.first.street ?? '') != '') {
        address += '${placemarks.first.street}, ';
        addressMap['street1'] = placemarks.first.street;
      }
      if ((placemarks.first.thoroughfare ?? '') != '') {
        address += '${placemarks.first.thoroughfare}, ';
        addressMap['street2'] = placemarks.first.thoroughfare;
      }
      if ((placemarks.first.subLocality ?? '') != '') {
        address += '${placemarks.first.subLocality}, ';
        addressMap['street3'] = placemarks.first.subLocality;
      }
      if ((placemarks.first.locality ?? '') != '') {
        address += '${placemarks.first.locality}, ';
        addressMap['city'] = placemarks.first.locality;
      }
      if ((placemarks.first.administrativeArea ?? '') != '') {
        address += '${placemarks.first.administrativeArea}, ';
        addressMap['state'] = placemarks.first.administrativeArea;
      }
      if ((placemarks.first.postalCode ?? '') != '') {
        address += '${placemarks.first.postalCode}, ';
        addressMap['zip'] = placemarks.first.postalCode;
      }
      if ((placemarks.first.country ?? '') != '') {
        address += '${placemarks.first.country} ';
        addressMap['country'] = placemarks.first.country;
      }
    });
    debugPrint(" placemarks------- $placemarks");
    debugPrint("------------------------------------------------");
  }
}
