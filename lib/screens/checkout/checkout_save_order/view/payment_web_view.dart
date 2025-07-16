/*
 *  Webkul Software.
 *
 *  @package  Mobikul Application Code.
 *  @Category Mobikul
 *  @author Webkul <support@webkul.com>
 *  @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *  @license https://store.webkul.com/license.html 
 *  @link https://store.webkul.com/license.html
 *
 */

import 'package:bagisto_app_demo/utils/app_global_data.dart';
import 'package:bagisto_app_demo/utils/shared_preference_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/route_constants.dart';
import '../../data_model/save_order_model.dart';

class PaymentWebView extends StatefulWidget {
  final SaveOrderModel? dataModel;
  final String? redirectUrl;
  Function(String) callBack;

  PaymentWebView(
      {Key? key, this.dataModel, this.redirectUrl, required this.callBack})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PaymentWebViewState();
  }
}

class PaymentWebViewState extends State<PaymentWebView> {
  var loadData = 0.0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamed(context, cartScreen);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushNamed(context, cartScreen);
              });
            },
            icon: const Icon(Icons.close),
          ),
        ),
        body: Stack(
          children: [
            InAppWebView(
              // Removed invalid headlessWebView parameter
              keepAlive: InAppWebViewKeepAlive(),
              initialUrlRequest: URLRequest(
                url: WebUri(Uri.parse(widget.redirectUrl ?? '').toString()),
                headers: {
                  'Cookie': appStoragePref.getCookieGet(),
                  "x-currency": GlobalData.currencyCode,
                  "x-locale": GlobalData.locale,
                  'Authorization': appStoragePref.getCustomerToken(),
                  'Accept': 'application/json',
                },
              ),
              onLoadStart: (controller, url) {
                final urlStr = url.toString();

                if (urlStr.contains("success")) {
                  widget.callBack("success");
                  Navigator.of(context).pop();
                } else if (urlStr.contains("cancel")) {
                  widget.callBack("cancel");
                  Navigator.of(context).pop();
                }
              },
              onLoadStop: (controller, url) {
                debugPrint('Page finished loading: $url');
              },
              onProgressChanged:
                  (InAppWebViewController controller, int progress) {
                setState(() {
                  loadData = progress / 100;
                });
              },
              onReceivedError: (controller, request, error) {
                debugPrint(
                    'Page finished loading with error : ${error.description}');
              },
              shouldOverrideUrlLoading: (controller, navigationAction) async {
                // String urlString = navigationAction.request.url!.toString();
                debugPrint('allowing navigation to $navigationAction');
                return NavigationActionPolicy.ALLOW;
              },
            ),
            Positioned(
                width: AppSizes.screenWidth,
                top: 0,
                child: Visibility(
                    visible: loadData < 1,
                    child: const LinearProgressIndicator(
                      color: Colors.grey,
                      backgroundColor: Colors.red,
                    )))
          ],
        ),
      ),
    );
  }
}
