/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/screens/location/utils/index.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart' as location;
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
export 'package:location/location.dart';

class LocationScreen extends StatefulWidget {
  final String? address;

  const LocationScreen({Key? key, this.address}) : super(key: key);

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
  double defaultLatitude = 28.6296987;
  double defaultLongitude = 77.3762753;

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
    return _buildUI();
  }

  Widget _buildUI() {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ((latitude != null) && (longitude != null))
                  ? Stack(children: [
                      GoogleMap(
                        zoomControlsEnabled: false,
                        myLocationButtonEnabled: false,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(latitude ?? defaultLatitude,
                              longitude ?? defaultLongitude),
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
                      const Positioned(
                          right: 0,
                          top: 0,
                          left: 0,
                          bottom: 0,
                          child: Icon(
                            Icons.location_pin,
                            color: Colors.red,
                            size: AppSizes.spacingWide * 2,
                          )),
                      Positioned(
                          bottom: AppSizes.spacingLarge,
                          right: AppSizes.spacingLarge,
                          child: InkWell(
                            onTap: getCurrentLocation,
                            child: const CircleAvatar(
                              backgroundColor: MobiKulTheme.accentColor,
                              child: Icon(
                                Icons.my_location_sharp,
                                color: Colors.white,
                              ),
                            ),
                          )),
                      Row(
                        children: [
                          GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: AppSizes.spacingNormal),
                                child: Icon(Icons.arrow_back,
                                    color: MobiKulTheme.accentColor),
                              )),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => BlocProvider(
                                            create: (context) =>
                                                LocationScreenBloc(
                                                    repository:
                                                        LocationRepositoryImp()),
                                            child: const PlaceSearch()))).then(
                                    (value) {
                                  if (value is LatLng) {
                                    placeSearch(value);
                                  }
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(
                                    AppSizes.spacingMedium),
                                margin: const EdgeInsets.all(
                                    AppSizes.spacingMedium),
                                color: Theme.of(context).cardColor,
                                child: Row(
                                  children: [
                                    const Icon(Icons.search),
                                    const SizedBox(
                                      width: AppSizes.spacingWide,
                                    ),
                                    Text(
                                      StringConstants.searchLocation
                                          .localized(),
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ])
                  : const Loader(),
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
                    Row(
                      children: [
                        const Icon(
                          Icons.location_pin,
                        ),
                        const SizedBox(
                          width: AppSizes.spacingMedium,
                        ),
                        Text(
                          StringConstants.selectLocation.localized(),
                          style: const TextStyle(color: Colors.grey),
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
                        : Text(
                            StringConstants.pleaseWait.localized(),
                          )
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
    LocationData? location;
    try {
      List<geocoding.Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        var location = locations?.firstOrNull;
        latitude = location?.latitude;
        longitude = location?.longitude;
      } else {
        location = await currentLocation.getLocation();
        latitude = location?.latitude;
        longitude = location?.longitude;
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
    }

    setState(() {});

    position =
        LatLng(latitude ?? defaultLatitude, longitude ?? defaultLongitude);
    _controller?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target:
          LatLng(latitude ?? defaultLatitude, longitude ?? defaultLongitude),
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
      target:
          LatLng(latitude ?? defaultLatitude, longitude ?? defaultLongitude),
      zoom: 16.0,
    )));
    getLocation(location);
  }

  void getLocation(LatLng latLng) async {
    List<Placemark> placeMarks = await placemarkFromCoordinates(
      latLng.latitude,
      latLng.longitude,
    );
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
