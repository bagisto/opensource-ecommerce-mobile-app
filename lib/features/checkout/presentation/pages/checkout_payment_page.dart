import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../data/models/checkout_model.dart';

/// Hosts a Bagisto-provided payment redirect or POST form inside the app.
/// WebView return URLs are signals only; Bagisto must confirm the payment.
class CheckoutPaymentPage extends StatefulWidget {
  final CheckoutPaymentInitiationResponse launch;

  const CheckoutPaymentPage({super.key, required this.launch});

  @override
  State<CheckoutPaymentPage> createState() => _CheckoutPaymentPageState();
}

class _CheckoutPaymentPageState extends State<CheckoutPaymentPage> {
  InAppWebViewController? _controller;
  int _progress = 0;

  Uri get _launchUri {
    final raw = widget.launch.type == 'redirect'
        ? widget.launch.redirectUrl
        : widget.launch.formAction;
    final uri = Uri.tryParse(raw ?? '');
    if (uri == null ||
        (uri.scheme != 'https' && uri.scheme != 'http') ||
        uri.host.isEmpty) {
      throw const FormatException('Invalid payment gateway URL');
    }
    return uri;
  }

  URLRequest get _initialRequest {
    final uri = _launchUri;
    if (widget.launch.type == 'redirect') {
      return URLRequest(url: WebUri.uri(uri));
    }

    final body = Uri(queryParameters: widget.launch.formFields).query;
    return URLRequest(
      url: WebUri.uri(uri),
      method: 'POST',
      body: Uint8List.fromList(utf8.encode(body)),
      headers: const {'Content-Type': 'application/x-www-form-urlencoded'},
    );
  }

  Future<void> _close() async {
    if (!mounted) return;
    Navigator.of(context).pop(CheckoutPaymentReturn.cancelled);
  }

  bool _matchesReturnUrl(Uri? current, String? expected) {
    if (current == null || expected == null || expected.isEmpty) return false;
    final target = Uri.tryParse(expected);
    if (target == null) return false;
    return current.scheme.toLowerCase() == target.scheme.toLowerCase() &&
        current.host.toLowerCase() == target.host.toLowerCase() &&
        current.port == target.port &&
        current.path.replaceFirst(RegExp(r'/$'), '') ==
            target.path.replaceFirst(RegExp(r'/$'), '');
  }

  Future<void> _finishForReturn(CheckoutPaymentReturn result) async {
    if (!mounted) return;
    Navigator.of(context).pop(result);
  }

  Future<void> _handleBack() async {
    final controller = _controller;
    if (controller != null && await controller.canGoBack()) {
      await controller.goBack();
      return;
    }
    await _close();
  }

  @override
  Widget build(BuildContext context) {
    final initialRequest = _initialRequest;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Secure payment'),
        leading: IconButton(
          tooltip: 'Close payment',
          icon: const Icon(Icons.close),
          onPressed: _handleBack,
        ),
      ),
      body: Column(
        children: [
          if (_progress < 100)
            LinearProgressIndicator(
              value: _progress == 0 ? null : _progress / 100,
            ),
          const MaterialBanner(
            content: Text(
              'After payment, Bagisto must confirm the result before your order is complete.',
            ),
            leading: Icon(Icons.lock_outline),
            actions: [SizedBox.shrink()],
          ),
          Expanded(
            child: InAppWebView(
              initialUrlRequest: initialRequest,
              initialSettings: InAppWebViewSettings(
                javaScriptEnabled: true,
                useShouldOverrideUrlLoading: true,
                supportMultipleWindows: false,
              ),
              onWebViewCreated: (controller) => _controller = controller,
              onProgressChanged: (controller, progress) {
                if (mounted) setState(() => _progress = progress);
              },
              shouldOverrideUrlLoading: (controller, navigationAction) async {
                final uri = navigationAction.request.url?.uriValue;
                if (_matchesReturnUrl(uri, widget.launch.successUrl)) {
                  await _finishForReturn(CheckoutPaymentReturn.successUrl);
                  return NavigationActionPolicy.CANCEL;
                }
                if (_matchesReturnUrl(uri, widget.launch.failureUrl)) {
                  await _finishForReturn(CheckoutPaymentReturn.failureUrl);
                  return NavigationActionPolicy.CANCEL;
                }
                if (uri == null ||
                    (uri.scheme != 'https' && uri.scheme != 'http')) {
                  return NavigationActionPolicy.CANCEL;
                }
                return NavigationActionPolicy.ALLOW;
              },
            ),
          ),
        ],
      ),
    );
  }
}
