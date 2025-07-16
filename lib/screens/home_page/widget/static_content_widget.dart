import 'dart:developer';

import 'package:bagisto_app_demo/utils/extension.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../data_model/theme_customization.dart';
import '../utils/index.dart';

class StaticContentWidget extends StatefulWidget {
  final String html;
  final String? css;
  final List<LinkModel>? links;

  const StaticContentWidget({
    Key? key,
    required this.html,
    this.css,
    this.links,
  }) : super(key: key);

  @override
  State<StaticContentWidget> createState() => _StaticContentWidgetState();
}

class _StaticContentWidgetState extends State<StaticContentWidget>
    with AutomaticKeepAliveClientMixin {
  String? _fullHtml;
  double _height = 1.0;
  bool _isLoading = true;
  InAppWebViewController? _webViewController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _fullHtml = _generateHtml();
  }

  String _generateHtml() {
    final accentColor = MobiKulTheme.accentColor.toCssHex();

    return """
    <!DOCTYPE html>
    <html>
    <head>
     <meta charset="UTF-8">
     <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
      <style>
      .primary-button, .secondary-button {
      background-color: $accentColor;
      border-color: $accentColor;
    }
      .primary-button:hover, .secondary-button:hover {
      background-color: $accentColor;
    }
    a {
      text-decoration: none !important;
    }
      ${widget.css}
    
      ${GlobalData.style}
        .top-collection-container {
        display: flex;
        flex-direction: column;
        align-items: center;
        margin: 0 auto;
        padding: 0px;
        box-sizing: border-box;
      }
      .top-collection-grid {
        display: grid;
        grid-template-columns: repeat(2, 1fr); /* Two columns, each taking half the width */
        gap: 10px;
        width: 100%;
        box-sizing: border-box;
      }
      .top-collection-card {
        display: flex;
        flex-direction: column;
        align-items: center;
        text-align: center;
        width: 100%; /* Ensures the card takes full width of its grid cell */
        box-sizing: border-box;
      }
      .top-collection-card img {
        max-width: 100%;
        height: auto;
        border-radius: 8px;
      }
      .top-collection-card h3 {
        margin-top: 8px;
        font-size: 16px;
        color: #333;
      }
      .inline-col-content-wrapper {
      align-items: center;
      justify-content: center;
      text-align: center;
      }
      </style>
    </head>
    <body>
       ${widget.html}
    </body>
    </html>
    """;
  }

  void launchInBrowser(String url) async {
    final uri = Uri.parse(url);
    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
  }

  void _handleLinkTap(String url, InAppWebViewController controller) async {
    if (await controller.canGoBack()) {
      controller.goBack();
    }
    final link = widget.links?.firstWhereOrNull((item) => item.url == url);

    if (link == null) {
      launchInBrowser(url);
      return;
    }

    switch (link.type) {
      case "product":
        Navigator.pushNamed(context, productScreen,
            arguments: PassProductData(title: link.slug, urlKey: link.slug));
        break;
      case "category":
        Navigator.pushNamed(context, categoryScreen,
            arguments: CategoriesArguments(
                categorySlug: link.slug, title: link.slug, id: link.id));
        break;
      case "cms":
        Navigator.pushNamed(context, cmsScreen,
            arguments: CmsDataContent(
                title: link.slug, id: int.tryParse(link.id ?? "0") ?? 0));
        break;
      default:
        launchInBrowser(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    log("Building StaticContentWidget with HTML: ${_fullHtml}");

    return Column(
      children: [
        _fullHtml == null
            ? SizedBox.shrink()
            : SizedBox(
                height: _height > 1.0 ? _height : 40,
                width: MediaQuery.of(context).size.width,
                child: InAppWebView(
                  initialData: InAppWebViewInitialData(data: _fullHtml!),
                  onWebViewCreated: (controller) {
                    _webViewController = controller;
                    debugPrint("WebView created");
                  },
                  onLoadStart: (controller, url) {
                    debugPrint("Load Start url==>${url.toString()}");
                  },
                  onLoadStop: (controller, uri) async {
                    debugPrint("WebView loaded: $uri");
                    if (_isLoading) {
                      try {
                        final jsResult = await controller.evaluateJavascript(
                          source:
                              'Math.max(document.body.scrollHeight, document.documentElement.scrollHeight);',
                        );
                        if (jsResult != null) {
                          final height =
                              double.tryParse(jsResult.toString()) ?? 0;
                          if (height > 0) {
                            setState(() {
                              _height = height;
                              _isLoading = false;
                            });
                          }
                        }
                      } catch (e) {
                        debugPrint("Error evaluating JavaScript: $e");
                      }
                    }
                  },
                  onProgressChanged: (controller, progress) async {
                    debugPrint("WebView loading progress: $progress%");

                    try {
                      final jsResult = await controller.evaluateJavascript(
                        source:
                            'Math.max(document.body.scrollHeight, document.documentElement.scrollHeight);',
                      );
                      if (jsResult != null) {
                        final height =
                            double.tryParse(jsResult.toString()) ?? 0;
                        if (height > 0) {
                          setState(() {
                            _height = height;
                            _isLoading = false;
                          });
                        }
                      }
                    } catch (e) {
                      debugPrint("Error evaluating JavaScript: $e");
                    }
                  },
                  onReceivedError: (controller, request, error) {
                    setState(() {
                      _isLoading = false;
                    });
                    debugPrint(
                        "WebView load error: ${error.description} (Code: ${error.type})");
                  },
                  onReceivedHttpError: (controller, request, errorResponse) {
                    setState(() {
                      _isLoading = false;
                    });
                    debugPrint(
                        "WebView HTTP error: ${errorResponse.statusCode} for URL: ${request.url}");
                  },
                  shouldOverrideUrlLoading:
                      (controller, navigationAction) async {
                    final url = navigationAction.request.url.toString();
                    _handleLinkTap(url, controller);
                    if (url.contains("about:blank")) {
                      return NavigationActionPolicy.ALLOW;
                    }

                    return NavigationActionPolicy.CANCEL;
                  },
                  initialSettings: InAppWebViewSettings(
                    useShouldOverrideUrlLoading: true,
                    supportZoom: false,
                    javaScriptEnabled: true,
                    transparentBackground: false,
                    disableVerticalScroll: true,
                    disableHorizontalScroll: true,
                    useWideViewPort: true,
                    loadWithOverviewMode: true,
                    domStorageEnabled: true,
                    mediaPlaybackRequiresUserGesture: false,
                  ),
                ),
              )
        //   child: InAppWebView(
        //     initialData: InAppWebViewInitialData(
        //         baseUrl: WebUri("https://webkul.com/"),
        //         data: _generateHtml2()),

        //     // initialData: InAppWebViewInitialData(data: _fullHtml!),
        //     onWebViewCreated: (controller) {
        //       _webViewController = controller;
        //       debugPrint("WebView created");
        //     },
        //     onLoadStart: (controller, url) {
        //       print("Load Start url==>${url.toString()}");
        //     },
        //     onLoadStop: (controller, uri) async {
        //       debugPrint("WebView loaded: $uri");
        //       if (_isLoading) {
        //         try {
        //           final jsResult = await controller.evaluateJavascript(
        //             source:
        //                 'Math.max(document.body.scrollHeight, document.documentElement.scrollHeight);',
        //           );
        //           if (jsResult != null) {
        //             final height =
        //                 double.tryParse(jsResult.toString()) ?? 0;
        //             if (height > 0) {
        //               setState(() {
        //                 _height = height;
        //                 _isLoading = false;
        //               });
        //             }
        //           }
        //         } catch (e) {
        //           debugPrint("Error evaluating JavaScript: $e");
        //         }
        //       }
        //     },
        //     onProgressChanged: (controller, progress) async {
        //       debugPrint("WebView loading progress: $progress%");
        //       if (progress == 100) {
        //         // When the page is fully loaded
        //         try {
        //           final jsResult = await controller.evaluateJavascript(
        //             source:
        //                 'Math.max(document.body.scrollHeight, document.documentElement.scrollHeight);',
        //           );
        //           if (jsResult != null) {
        //             final height =
        //                 double.tryParse(jsResult.toString()) ?? 0;
        //             if (height > 0) {
        //               setState(() {
        //                 _height = height;
        //                 _isLoading = false;
        //               });
        //             }
        //           }
        //         } catch (e) {
        //           debugPrint("Error evaluating JavaScript: $e");
        //         }
        //       }
        //     },
        //     onReceivedError: (controller, request, error) {
        //       setState(() {
        //         _isLoading = false;
        //       });
        //       debugPrint(
        //           "WebView load error: ${error.description} (Code: ${error.type})");
        //     },
        //     onLoadError: (controller, url, code, message) => {
        //       setState(() {
        //         _isLoading = false;
        //       }),
        //       debugPrint(
        //           "WebView load error: $message (Code: $code) for URL: $url"),
        //     },
        //     onReceivedHttpError: (controller, request, errorResponse) => {
        //       setState(() {
        //         _isLoading = false;
        //       }),
        //       debugPrint(
        //           "WebView HTTP error: ${errorResponse.statusCode} for URL: ${request.url}"),
        //     },
        //     shouldOverrideUrlLoading:
        //         (controller, navigationAction) async {
        //       final url = navigationAction.request.url.toString();
        //       _handleLinkTap(url);
        //       return NavigationActionPolicy.CANCEL;
        //     },
        //     initialSettings: InAppWebViewSettings(
        //         useShouldOverrideUrlLoading: true,
        //         supportZoom: false,
        //         javaScriptEnabled: true,
        //         transparentBackground: false,
        //         disableVerticalScroll: true,
        //         disableHorizontalScroll: true,
        //         useWideViewPort: true,
        //         loadWithOverviewMode: true,
        //         domStorageEnabled: true,
        //         mediaPlaybackRequiresUserGesture: false,
        //         javaScriptCanOpenWindowsAutomatically: true),
        //   ),
        // ),
      ],
    );
  }
}
