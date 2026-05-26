import 'package:flutter/material.dart';

class CheckoutInteractionBlocker extends StatelessWidget {
  final bool isBlocking;
  final Widget child;

  const CheckoutInteractionBlocker({
    super.key,
    required this.isBlocking,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AbsorbPointer(absorbing: isBlocking, child: child),
        if (isBlocking) ...[
          const Positioned.fill(
            child: ModalBarrier(dismissible: false, color: Color(0x66000000)),
          ),
          const Positioned.fill(
            child: Center(child: CircularProgressIndicator()),
          ),
        ],
      ],
    );
  }
}
