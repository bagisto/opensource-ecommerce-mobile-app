import 'package:flutter/material.dart';
import 'package:bagisto_app_demo/screens/drawer/utils/index.dart';
import '../../../home_page/data_model/new_product_data.dart';

class Availability extends StatelessWidget {
  final BookingProduct? bookingOptions;
  const Availability({super.key, this.bookingOptions});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          Text(
            "Today's Availability",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ]),

        if (bookingOptions?.type == "appointment")
          Padding(
            padding: const EdgeInsets.only(left: 48.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: _buildAppointmentSlots(),
            ),
          ),

        if (bookingOptions?.type == "table")
          Padding(
            padding: const EdgeInsets.only(
              left: 48.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _buildTableSlots(),
            ),
          ),
      ],
    );
  }

  List<Widget> _buildAppointmentSlots() {
    final appointmentSlot = bookingOptions?.appointmentSlot;

    if (appointmentSlot?.sameSlotAllDays == true) {
      final slots = appointmentSlot?.slotOneDay;

      if (slots == null || slots.isEmpty || slots.first.isEmpty) {
        return [const Text("Closed")];
      }

      final validSlots = slots.first
          .where((slot) => slot.from != null && slot.to != null)
          .toList();

      if (validSlots.isEmpty) {
        return [const Text("Closed")];
      }

      return validSlots
          .map((slot) => Text("${slot.from} - ${slot.to}"))
          .toList();
    }

    else if (appointmentSlot?.sameSlotAllDays == false) {
      final weekdayIndex = DateTime.now().weekday;
      final slotList = appointmentSlot?.slotOneDay;

      if (slotList == null || weekdayIndex < 0 || weekdayIndex >= slotList.length) {
        return [const Text("Closed")];
      }

      final todaySlots = slotList[weekdayIndex];

      if (todaySlots == null || todaySlots.isEmpty) {
        return [const Text("Closed")];
      }

      final validSlots = todaySlots
          .where((slot) => slot.from != null && slot.to != null)
          .toList();

      if (validSlots.isEmpty) {
        return [const Text("Closed")];
      }

      return validSlots
          .map((slot) => Text("${slot.from} - ${slot.to}"))
          .toList();
    }


    return [const Text("Closed")];
  }


  List<Widget> _buildTableSlots() {
    final tableSlot = bookingOptions?.tableSlot;

    if (tableSlot?.sameSlotAllDays == true) {
      final slots = tableSlot?.slotManyDays;

      if (slots == null || slots.isEmpty) {
        return [const Text("Closed")];
      }

      // Filter out any invalid slots (optional)
      final validSlots = slots.where((slot) => slot.from != null && slot.to != null).toList();

      if (validSlots.isEmpty) {
        return [const Text("Closed")];
      }

      return validSlots
          .map((slot) => Text("${slot.from} - ${slot.to}"))
          .toList();
    }

    else if (tableSlot?.sameSlotAllDays == false) {
      final weekdayIndex = DateTime.now().weekday;
      final slotList = tableSlot?.slotOneDay;

      if (slotList == null || weekdayIndex < 0 || weekdayIndex >= slotList.length) {
        return [const Text("Closed")];
      }

      final todaySlots = slotList[weekdayIndex];

      if (todaySlots == null || todaySlots.isEmpty) {
        return [const Text("Closed")];
      }

      final validSlots = todaySlots
          .where((slot) => slot.from != null && slot.to != null)
          .toList();

      if (validSlots.isEmpty) {
        return [const Text("Closed")];
      }

      return validSlots
          .map((slot) => Text("${slot.from} - ${slot.to}"))
          .toList();
    }

    return [const Text("Closed")];
  }


}
