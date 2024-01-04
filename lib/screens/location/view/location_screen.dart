import 'package:bagisto_app_demo/widgets/loader.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;
import '../../../utils/index.dart';
import 'package:flutter/material.dart';
import 'package:bagisto_app_demo/screens/location/utils/index.dart';

class LocationScreen extends StatefulWidget {
  final String? address;

  const LocationScreen({Key? key, this.address}) : super(key: key);

  @override
  _LocationScreenState createState() => _LocationScreenState();
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
    if (widget.address != null) {
      address = widget.address ?? "";
    }

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
                          target: LatLng(
                              latitude ?? 28.6296987, longitude ?? 77.3762753),
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
                            color: Colors.red,
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
                                      child: const PlaceSearch()))).then(
                              (value) {
                            if (value is LatLng) {
                              placeSearch(value);
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(AppSizes.spacingMedium),
                          margin: const EdgeInsets.all(AppSizes.spacingMedium),
                          color: Theme.of(context).cardColor,
                          child: const Row(
                            children: [
                              Icon(Icons.search),
                              SizedBox(
                                width: AppSizes.spacingWide,
                              ),
                              Text(
                                "Search for a location",
                                style: TextStyle(color: Colors.grey),
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
                padding: const EdgeInsets.all(AppSizes.spacingWide),
                height: AppSizes.screenHeight / 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.location_pin,
                        ),
                        SizedBox(
                          width: AppSizes.spacingMedium,
                        ),
                        Text(
                          "Select this Location",
                          style: TextStyle(color: Colors.grey),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: AppSizes.spacingWide,
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
                        : const Text(
                            "Please wait...",
                            style: TextStyle(color: Colors.black),
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
    var location;
    try {
      location = await currentLocation.getLocation();
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // AlertMessage.showError(e.toString(), context);
      });
      Navigator.pop(context);
    }
    setState(() {
      latitude = location.latitude;
      longitude = location.longitude;
    });
    position = LatLng(latitude ?? 28.6296987, longitude ?? 77.3762753);
    _controller?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(latitude ?? 28.6296987, longitude ?? 77.3762753),
      zoom: 16.0,
    )));
  }

  void placeSearch(LatLng location) {
    setState(() {
      latitude = location.latitude;
      longitude = location.longitude;
    });
    position = LatLng(latitude!, longitude!);
    _controller?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(latitude ?? 28.6296987, longitude ?? 77.3762753),
      zoom: 16.0,
    )));
    getLocation(location);
  }

  void getLocation(LatLng latLng) async {
    List<Placemark> placeMarks = await placemarkFromCoordinates(
        latLng.latitude, latLng.longitude,
        localeIdentifier: GlobalData.locale);
    setState(() {
      if ((placeMarks.first.street ?? '') != '') {
        address += '${placeMarks.first.street}, ';
        addressMap['street1'] = placeMarks.first.street;
      }
      if ((placeMarks.first.thoroughfare ?? '') != '') {
        address += '${placeMarks.first.thoroughfare}, ';
        addressMap['street2'] = placeMarks.first.thoroughfare;
      }
      if ((placeMarks.first.subLocality ?? '') != '') {
        address += '${placeMarks.first.subLocality}, ';
        addressMap['street3'] = placeMarks.first.subLocality;
      }
      if ((placeMarks.first.locality ?? '') != '') {
        address += '${placeMarks.first.locality}, ';
        addressMap['city'] = placeMarks.first.locality;
      }
      if ((placeMarks.first.administrativeArea ?? '') != '') {
        address += '${placeMarks.first.administrativeArea}, ';
        addressMap['state'] = placeMarks.first.administrativeArea;
      }
      if ((placeMarks.first.postalCode ?? '') != '') {
        address += '${placeMarks.first.postalCode}, ';
        addressMap['zip'] = placeMarks.first.postalCode;
      }
      if ((placeMarks.first.country ?? '') != '') {
        address += '${placeMarks.first.country} ';
        addressMap['country'] = placeMarks.first.country;
      }
      if ((placeMarks.first.isoCountryCode ?? '') != '') {
        address += '${placeMarks.first.isoCountryCode} ';
        addressMap['countryCode'] = placeMarks.first.isoCountryCode;
      }
    });
  }
}
