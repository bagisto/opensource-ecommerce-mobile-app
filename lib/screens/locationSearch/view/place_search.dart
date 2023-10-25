import 'package:bagisto_app_demo/screens/cart_screen/view/cart_index.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../configuration/app_global_data.dart';
import '../../../models/google_place_model.dart';
import '../bloc/location_bloc.dart';
import '../event/location_event.dart';
import '../state/location_state.dart';


class PlaceSearch extends StatefulWidget {
  const PlaceSearch({Key? key}) : super(key: key);

  @override
  State<PlaceSearch> createState() => _PlaceSearchState();
}

class _PlaceSearchState extends State<PlaceSearch> {
  TextEditingController searchController = TextEditingController();
  GooglePlaceModel? placeModel;
  bool isLoading = false;
  LocationScreenBloc? _locationScreenBloc;

  @override
  void initState() {
    _locationScreenBloc = context.read<LocationScreenBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationScreenBloc, LocationScreenState>(
      builder: (context, state) {
        if (state is LocationScreenLoadingState) {
          isLoading = true;
        } else if (state is SearchPlaceSuccessState) {
          isLoading = false;
          placeModel = state.data;
        } else if (state is SearchPlaceErrorState) {
          isLoading = false;

        } else if (state is LocationScreenInitialState) {
          isLoading = false;
          placeModel = null;
        }
        return _buildUI();
      },
    );
  }

  Widget _buildUI() {
    return Directionality(
      textDirection: GlobalData.contentDirection(),
      child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight((MediaQuery.of(context).size.height/15) +(MediaQuery.of(context).size.height/ (MediaQuery.of(context).size.height/20))),
            child: Container(
              color: MobikulTheme.primaryColor,
              padding:  EdgeInsets.only(top: MediaQuery.of(context).size.height/ (MediaQuery.of(context).size.height/20)),
              child: AppBar(
                leading: IconButton(
                  onPressed: () {
                    SystemChannels.textInput.invokeMethod("TextInput.hide");
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                title: TextField(
                  autofocus: true,
                  controller: searchController,
                  onChanged: (searchKey) {
                    if(searchKey.isNotEmpty){
                      _locationScreenBloc?.add(SearchPlaceEvent(searchKey));
                    }
                    else{
                      _locationScreenBloc?.add(SearchPlaceInitialEvent());
                    }
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText:"SearchScreenTitle".localized(),
                    hintStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.normal,color: Colors.black
                    ),

                  ),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.black,fontWeight: FontWeight.w400,fontSize: 16),
                  cursorColor: Colors.black,
                ),
                actions: [
                  searchController.text.isNotEmpty
                      ? IconButton(
                    onPressed: () {
                      SystemChannels.textInput.invokeMethod("TextInput.hide");
                      searchController.text = "";
                      placeModel = null;
                      _locationScreenBloc?.add(SearchPlaceInitialEvent());
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Colors.black,
                    ),
                  )
                      : Container()
                ],
              ),
            ),
          ),
          body: Column(
            children: [
              ((placeModel != null))
                  ? (placeModel?.results?.isNotEmpty ?? false)
                  ? Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: placeModel?.results?.length ?? 0,
                    itemBuilder: (context, index) => Card(
                      elevation: 5,
                      child: ListTile(
                        onTap: (){
                          Navigator.pop(context, LatLng(placeModel?.results?[index].geometry?.location?.lat ?? 0.0, placeModel?.results?[index].geometry?.location?.lng ?? 0.0));
                        },
                        title: Text(
                          placeModel?.results?[index].name ?? '',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.black),
                        ),
                        subtitle: Text(
                          placeModel?.results?[index].formattedAddress ?? '',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.grey),
                        ),

                      ),
                    )),
              )
                  : Expanded(
                child: Center(
                  child: Text("NoResultFound".localized(),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.black),
                  ),
                ),
              )
                  :
              Expanded(
                child: GestureDetector(
                  onTap: (){Navigator.pop(context);},
                ),
              )
            ],
          )
      ),
    );
  }
}
