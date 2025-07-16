import 'package:bagisto_app_demo/utils/extension.dart';
import 'package:bagisto_app_demo/utils/index.dart';
import 'package:flutter/material.dart';
import '../../../home_page/data_model/new_product_data.dart';

class EventScreen extends StatefulWidget {
  final BookingProduct? bookingOptions;
  final Function(List<Map<String, dynamic>>)? callBack;

  const EventScreen({super.key, this.bookingOptions, this.callBack});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  List<Map<String, dynamic>> selectedTickets = [];

  // Add or update ticket quantity
  void updateTicketQuantity(int ticketId, int change) {
    setState(() {
      final index =
          selectedTickets.indexWhere((t) => t['ticketId'] == ticketId);
      if (index != -1) {
        final newQty = selectedTickets[index]['quantity'] + change;
        if (newQty > 0) {
          selectedTickets[index]['quantity'] = newQty;
        } else {
          selectedTickets.removeAt(index);
        }
      } else if (change > 0) {
        selectedTickets.add({'ticketId': ticketId, 'quantity': change});
      }
    });
    widget.callBack?.call(selectedTickets);
  }

  // Get current quantity for a ticket
  int getTicketQuantity(int ticketId) {
    final ticket = selectedTickets.firstWhere(
      (t) => t['ticketId'] == ticketId,
      orElse: () => {'quantity': 0},
    );
    return ticket['quantity'];
  }

  @override
  Widget build(BuildContext context) {
    final eventTickets = widget.bookingOptions?.eventTickets ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Event Date Info
        Row(
          children: [
            const Icon(Icons.calendar_today_outlined, size: 15),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(StringConstants.eventOn.localized() + ":",
                    style: Theme.of(context).textTheme.titleSmall),
                Text(
                  "${widget.bookingOptions?.availableFrom ?? ''} - ${widget.bookingOptions?.availableTo ?? ''}",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),

        Text(StringConstants.bookYourTickets.localized(),
            style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),

        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: eventTickets.length,
          itemBuilder: (context, index) {
            final ticket = eventTickets[index];
            final ticketId = int.tryParse(ticket.id?.toString() ?? '') ?? 0;
            final quantity = getTicketQuantity(ticketId);

            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(ticket.name ?? "",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Price & Description
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(ticket.price != 0 || ticket.price != null
                              ? "${formatCurrency(ticket.price?.toDouble() ?? 0, appStoragePref.getCurrencyCode())} per ticket"
                              : ""),
                          const SizedBox(height: 4),
                          Text(ticket.description ?? "",
                              style: const TextStyle(fontSize: 14)),
                        ],
                      ),

                      // Quantity Selector
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, size: 18),
                              onPressed: () =>
                                  updateTicketQuantity(ticketId, -1),
                            ),
                            Text(
                              "$quantity",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () =>
                                  updateTicketQuantity(ticketId, 1),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
