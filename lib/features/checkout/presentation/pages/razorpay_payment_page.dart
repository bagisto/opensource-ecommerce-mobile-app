import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../data/models/checkout_model.dart';

class RazorpayPaymentResult {
  final String? orderId;
  final String? paymentId;
  final String? signature;
  final String? errorMessage;

  const RazorpayPaymentResult.success({
    required this.orderId,
    required this.paymentId,
    required this.signature,
  }) : errorMessage = null;

  const RazorpayPaymentResult.failure(this.errorMessage)
    : orderId = null,
      paymentId = null,
      signature = null;

  bool get isSuccess =>
      orderId != null && paymentId != null && signature != null;
}

/// Launches Razorpay's native checkout from Bagisto's server-created order.
class RazorpayPaymentPage extends StatefulWidget {
  final CheckoutPaymentInitiationResponse launch;

  const RazorpayPaymentPage({super.key, required this.launch});

  @override
  State<RazorpayPaymentPage> createState() => _RazorpayPaymentPageState();
}

class _RazorpayPaymentPageState extends State<RazorpayPaymentPage> {
  late final Razorpay _razorpay;
  bool _finished = false;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay()
      ..on(Razorpay.EVENT_PAYMENT_SUCCESS, _onPaymentSuccess)
      ..on(Razorpay.EVENT_PAYMENT_ERROR, _onPaymentError)
      ..on(Razorpay.EVENT_EXTERNAL_WALLET, _onExternalWallet);
    WidgetsBinding.instance.addPostFrameCallback((_) => _openCheckout());
  }

  void _openCheckout() {
    final data = widget.launch.sdkData;
    final options = <String, dynamic>{
      'key': data['key'],
      'amount': data['amount'],
      'currency': data['currency'],
      'order_id': data['order_id'],
      'prefill': _asStringMap(data['prefill']),
      'theme': {'color': data['theme_color']},
    };

    final name = data['name']?.toString().trim();
    final description = data['description']?.toString().trim();
    final image = data['image']?.toString().trim();
    if (name != null && name.isNotEmpty) options['name'] = name;
    if (description != null && description.isNotEmpty) {
      options['description'] = description;
    }
    if (image != null && image.isNotEmpty) options['image'] = image;

    try {
      _razorpay.open(options);
    } catch (error) {
      _finish(RazorpayPaymentResult.failure(error.toString()));
    }
  }

  Map<String, String> _asStringMap(dynamic value) {
    if (value is! Map) return const {};
    return value.map(
      (key, item) => MapEntry(key.toString(), item?.toString() ?? ''),
    );
  }

  void _onPaymentSuccess(PaymentSuccessResponse response) {
    final expectedOrderId = widget.launch.sdkData['order_id']?.toString();
    if (response.orderId == null || response.orderId != expectedOrderId) {
      _finish(
        const RazorpayPaymentResult.failure(
          'Razorpay returned an unexpected order. Please contact support before retrying.',
        ),
      );
      return;
    }
    if (response.paymentId == null || response.signature == null) {
      _finish(
        const RazorpayPaymentResult.failure(
          'Razorpay did not return the payment verification details.',
        ),
      );
      return;
    }

    _finish(
      RazorpayPaymentResult.success(
        orderId: response.orderId,
        paymentId: response.paymentId,
        signature: response.signature,
      ),
    );
  }

  void _onPaymentError(PaymentFailureResponse response) {
    final message = response.code == Razorpay.PAYMENT_CANCELLED
        ? 'Payment was cancelled.'
        : (response.message?.trim().isNotEmpty == true
              ? response.message!.trim()
              : 'Razorpay could not complete the payment.');
    _finish(RazorpayPaymentResult.failure(message));
  }

  void _onExternalWallet(ExternalWalletResponse response) {
    final wallet = response.walletName?.trim();
    // Wallet selection is not a final payment result. Keep listening for the
    // SDK's success/error callback, which is what Bagisto can verify.
    debugPrint(
      'Razorpay external wallet selected: ${wallet?.isNotEmpty == true ? wallet : 'unknown'}',
    );
  }

  void _finish(RazorpayPaymentResult result) {
    if (_finished || !mounted) return;
    _finished = true;
    Navigator.of(context).pop(result);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Razorpay'),
        leading: IconButton(
          tooltip: 'Cancel payment',
          icon: const Icon(Icons.close),
          onPressed: () => _finish(
            const RazorpayPaymentResult.failure('Payment was cancelled.'),
          ),
        ),
      ),
      body: const Center(child: CircularProgressIndicator()),
    );
  }
}
