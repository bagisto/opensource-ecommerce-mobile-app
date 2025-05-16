
/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'package:dio/dio.dart';
import 'package:bagisto_app_demo/screens/location/utils/index.dart';

abstract class LocationRepository{
  Future<GooglePlaceModel> getPlace(String text);
}

class LocationRepositoryImp implements LocationRepository{
  @override
   Future<GooglePlaceModel> getPlace(String text)async{
    GooglePlaceModel model;
    String endPoint = "$text&key=AIzaSyBAlqVDV_6ec8DKG3yJPAE29HV4f-GOsdk&language=${GlobalData.locale}";
    Dio dio = Dio(BaseOptions(contentType: 'application/json'));
    dio.interceptors.add(LogInterceptor(
      request: true,
      requestBody: true,
      requestHeader: true,
      responseBody: true,
      responseHeader: true,
      error: true
    ));
    model = await GooglePlaceApiClient(dio).getGooglePlace(endPoint);
     return model;
  }
}
