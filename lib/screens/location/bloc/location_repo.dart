
import 'package:dio/dio.dart';
import 'package:bagisto_app_demo/screens/location/utils/index.dart';
import '../../../utils/index.dart';

abstract class LocationRepository{
  Future<GooglePlaceModel> getPlace(String text);
}

class LocationRepositoryImp implements LocationRepository{
  @override
   Future<GooglePlaceModel> getPlace(String text)async{
    GooglePlaceModel model;
    String endPoint = "$text&key=AIzaSyBAlqVDV_6ec8DKG3yJPAE29HV4f-GOsdk&language=${GlobalData.locale}";
    model = await GooglePlaceApiClient(Dio(BaseOptions(contentType: 'application/json'))).getGooglePlace(endPoint);
     return model;
  }
}
