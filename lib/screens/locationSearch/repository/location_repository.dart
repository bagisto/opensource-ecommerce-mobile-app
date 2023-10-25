
import 'package:bagisto_app_demo/configuration/app_global_data.dart';

import '../../../models/google_place_model.dart';
import 'package:dio/dio.dart';

abstract class LocationRepository{
  Future<GooglePlaceModel> getPlace(String text);
}

class LocationRepositoryImp implements LocationRepository{
  @override
   Future<GooglePlaceModel> getPlace(String text)async{
    GooglePlaceModel model;
    String endPoint = "$text&key=AIzaSyBAlqVDV_6ec8DKG3yJPAE29HV4f-GOsdk&language=${GlobalData.locale}&callback=initMap";
    model = await ApiClient(Dio(BaseOptions(contentType: 'application/json'))).getGooglePlace(endPoint);
     return model;
  }
}
