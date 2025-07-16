import 'package:bagisto_app_demo/utils/index.dart';
import 'package:bagisto_app_demo/utils/shared_preference_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../utils/app_constants.dart';
import 'dart:developer';

class GdprWebView extends StatefulWidget {
  final String? redirectUrl;
  final String? title;

  const GdprWebView({super.key, this.redirectUrl, this.title});

  @override
  State<StatefulWidget> createState() {
    return GdprWebViewState();
  }
}

class GdprWebViewState extends State<GdprWebView> {
  var loadData = 0.0;
  bool cookiesSet = false;

  @override
  void initState() {
    super.initState();
    _prepareCookies();
  }

  Future<void> _prepareCookies() async {
    final defaultCookies = appStoragePref.getCookieGet();
    final authToken =
        appStoragePref.getCustomerToken()?.replaceFirst('Bearer ', '') ?? '';
    String? bagistoSession;
    for (var cookie in defaultCookies.split(';')) {
      var parts = cookie.trim().split('=');
      if (parts.length == 2 && parts[0] == 'bagisto_session') {
        bagistoSession = parts[1];
        break;
      }
    }
    final url = Uri.parse(widget.redirectUrl ?? '');
    final isSecure = url.scheme == 'https';

    final cookieManager = CookieManager.instance();

    // Remove all cookies for a clean state (optional, but helps debugging)
    await cookieManager.deleteCookies(url: WebUri(url.toString()));

    // Set bagisto_session
    if (bagistoSession != null && bagistoSession.isNotEmpty) {
      await cookieManager.setCookie(
        url: WebUri(url.toString()),
        name: 'bagisto_session',
        value: bagistoSession,
        domain: url.host,
        path: '/',
        isSecure: isSecure,
        isHttpOnly: true,
        sameSite: HTTPCookieSameSitePolicy.LAX,
        maxAge: 7200,
      );
    }

    // Set XSRF-TOKEN
    if (authToken.isNotEmpty) {
      await cookieManager.setCookie(
        url: WebUri(url.toString()),
        name: 'XSRF-TOKEN',
        value: authToken,
        domain: url.host,
        path: '/',
        isSecure: isSecure,
        isHttpOnly: false,
        sameSite: HTTPCookieSameSitePolicy.LAX,
        maxAge: 7200,
      );
    }

    // Set cookie-consent
    await cookieManager.setCookie(
      url: WebUri(url.toString()),
      name: 'cookie-consent',
      value: '1',
      domain: url.host,
      path: '/',
      isSecure: isSecure,
      isHttpOnly: false,
      sameSite: HTTPCookieSameSitePolicy.LAX,
      maxAge: 7200,
    );
    setState(() {
      cookiesSet = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? ""),
      ),
      body: cookiesSet
          ? Stack(
              children: [
                InAppWebView(
                  keepAlive: InAppWebViewKeepAlive(),
                  initialUrlRequest: URLRequest(
                    url: WebUri(Uri.parse(widget.redirectUrl ?? '').toString()),
                    headers: {
                      "x-currency": GlobalData.currencyCode,
                      "x-locale": GlobalData.locale,
                      "is-cookie-exist": "1",
                      'Accept': 'application/json',
                      "Authorization": appStoragePref.getCustomerToken() ?? "",
                    },
                    httpShouldHandleCookies: true,
                  ),
                  onLoadStart: (controller, url) {
                    debugPrint('Page start loading: $url');
                  },
                  onLoadStop: (controller, url) async {
                    debugPrint('Page finished loading: $url');
                  },
                  onProgressChanged:
                      (InAppWebViewController controller, int progress) {
                    setState(() {
                      loadData = progress / 100;
                    });
                  },
                  onReceivedError: (controller, request, error) {
                    debugPrint('Page finished loading with error : ${error.description}');
                  },
                  shouldOverrideUrlLoading:
                      (controller, navigationAction) async {
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
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}