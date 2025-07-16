import 'package:bagisto_app_demo/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../utils/app_constants.dart';
import 'dart:developer';

class CommonWebView extends StatefulWidget {
  final String? redirectUrl;
  final String? title;

  const CommonWebView({super.key, this.redirectUrl, this.title});

  @override
  State<StatefulWidget> createState() {
    return CommonWebViewState();
  }
}

class CommonWebViewState extends State<CommonWebView> {
  var loadData = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? ""),
      ),
      body: Stack(
        children: [
          InAppWebView(
            keepAlive: InAppWebViewKeepAlive(),
            initialUrlRequest: URLRequest(
              url: WebUri(Uri.parse(widget.redirectUrl ?? '').toString()),
              headers: {
                "Cookie": appStoragePref.getCookieGet(),
                "x-currency": GlobalData.currencyCode,
                "x-locale": GlobalData.locale,
                "is-cookie-exist": "1",
                'Accept': 'application/json',
                "Authorization": appStoragePref.getCustomerToken() ?? "",
              },
            ),
            onLoadStart: (controller, url) {
              debugPrint('Page start loading: $url');
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
    );
  }
}
