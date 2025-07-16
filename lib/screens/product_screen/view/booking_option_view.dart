import 'dart:developer';

import 'package:bagisto_app_demo/data_model/product_model/booking_slots_modal.dart';
import 'package:bagisto_app_demo/screens/location/view/location_screen.dart';
import 'package:bagisto_app_demo/screens/product_screen/utils/index.dart';
import 'package:bagisto_app_demo/screens/product_screen/view/widget/booking_product_availbility.dart';
import 'package:bagisto_app_demo/screens/product_screen/view/widget/event_booking.dart';
import 'package:intl/intl.dart';

class BookingOptionView extends StatefulWidget {
  final BookingSlotsData? bookingSlotsData;
  final ProductScreenBLoc? productScreenBLoc;
  final Function(Map<String, dynamic>)? callBack;
  final List<BookingProduct>? options;

  const BookingOptionView(
      {super.key,
      required this.options,
      this.callBack,
      this.productScreenBLoc,
      required this.bookingSlotsData});

  @override
  State<StatefulWidget> createState() {
    return _BookingOptionViewState();
  }
}

class _BookingOptionViewState extends State<BookingOptionView> {
  Map<String, dynamic> selectedBooking = {};
  List<dynamic> setSlotsOnPickedDate = [];
  BookingProduct? bookingOptions;
  String today = "";
  final double pricePerBooking = 50.0; // Define a default price per booking
  @override
  void initState() {
    super.initState();
    if (widget.options != null && widget.options!.isNotEmpty) {
      // var defaultBooking = widget.options!.first;
      bookingOptions = widget.options!.first;
      selectedBooking = {
        "type": bookingOptions?.type,
        "from": null,
        "to": null,
        "date": null,
        "slot": null,
        "qty": 1,
        "rentingType": bookingOptions?.rentalSlot != null
            ? (bookingOptions?.rentalSlot["rentingType"] != null &&
                    bookingOptions?.rentalSlot["rentingType"] == "daily_hourly")
                ? "daily"
                : bookingOptions?.rentalSlot["rentingType"] == "hourly"
                    ? "hourly"
                    : "daily"
            : null,
        "availableBookingSlots": [],
      };
    }
    today = getTodayDayOfWeek();
  }

  double calculateTotal(int? qty) {
    return (qty ?? 0) * pricePerBooking;
  }

  int timeToMilliseconds(String time, String date // date in yyyy-MM-dd format
      ) {
    List<String> parts = time.split(":");
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);

    List<String> dateParts = date.split("-");
    int year = int.parse(dateParts[0]);
    int month = int.parse(dateParts[1]);
    int day = int.parse(dateParts[2]);

    DateTime dateWithTime = DateTime(
      year,
      month,
      day,
      hours,
      minutes,
    );

    return (dateWithTime.millisecondsSinceEpoch / 1000).toInt();
  }

  List<Map<String, dynamic>> getWeekDaysWithSlots() {
    List<Map<String, dynamic>> weekDays = [
      {"key": "Sunday", "value": []},
      {"key": "Monday", "value": []},
      {"key": "Tuesday", "value": []},
      {"key": "Wednesday", "value": []},
      {"key": "Thursday", "value": []},
      {"key": "Friday", "value": []},
      {"key": "Saturday", "value": []},
    ];
    return weekDays;
  }

  List<dynamic> getSlotsForSelectedDate(DateTime date) {
    List<dynamic> slotsForDate = [];

    if (bookingOptions?.defaultSlot != null) {
      if (bookingOptions?.id != null) {
        widget.productScreenBLoc?.add(GetSlotEvent(
            int.parse(bookingOptions?.id ?? ""),
            DateFormat('yyyy-MM-dd').format(date).toString()));
        slotsForDate = widget.bookingSlotsData?.data ?? [];
      }
    }

    if (bookingOptions?.rentalSlot != null) {
      if (bookingOptions?.id != null) {
        widget.productScreenBLoc?.add(GetSlotEvent(
            int.parse(bookingOptions?.id ?? ""),
            DateFormat('yyyy-MM-dd').format(date).toString()));
        slotsForDate = widget?.bookingSlotsData?.data ?? [];
      }
    }
    if (bookingOptions?.appointmentSlot != null) {
      if (bookingOptions?.id != null) {
        widget.productScreenBLoc?.add(GetSlotEvent(
            int.parse(bookingOptions?.id ?? ""),
            DateFormat('yyyy-MM-dd').format(date).toString()));
        slotsForDate = widget?.bookingSlotsData?.data ?? [];
      }
    }
    if (bookingOptions?.tableSlot != null) {
      if (bookingOptions?.id != null) {
        widget.productScreenBLoc?.add(GetSlotEvent(
            int.parse(bookingOptions?.id ?? ""),
            DateFormat('yyyy-MM-dd').format(date).toString()));
        slotsForDate = widget?.bookingSlotsData?.data ?? [];
      }
    }
    return widget?.bookingSlotsData?.data ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: bookingOptions?.showLocation ?? false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.location_on),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Text(
                      StringConstants.location.localized(),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
                Padding(
                    padding: const EdgeInsets.only(
                        left:
                            48.0), // Matches the left padding of the Row widget
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bookingOptions?.location ?? "",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        InkWell(
                          child: Text(
                            StringConstants.viewOnMap.localized() ?? "",
                            style: TextStyle(
                                color: MobiKulTheme.linkColor,
                                fontWeight: FontWeight.bold),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => LocationScreen(
                                        address: bookingOptions?.location)));
                          },
                        ),
                      ],
                    )),
              ],
            ),
          ),
          if ((bookingOptions?.type == "default" &&
                  bookingOptions?.defaultSlot?.duration != null) ||
              (bookingOptions?.type == "appointment" &&
                  bookingOptions?.appointmentSlot?.duration != null) ||
              (bookingOptions?.type == "table" &&
                  bookingOptions?.tableSlot?.duration != null))
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Text(
                  "Slot Duration",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ]),
              Padding(
                  padding: const EdgeInsets.only(
                      left: 48.0), // Matches the left padding of the Row widget
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bookingOptions?.type == "default"
                            ? "${bookingOptions?.defaultSlot?.duration} mins"
                            : bookingOptions?.type == "appointment"
                                ? "${bookingOptions?.appointmentSlot?.duration} mins"
                                : bookingOptions?.type == "table"
                                    ? "${bookingOptions?.tableSlot?.duration} mins"
                                    : "",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  )),
              if (bookingOptions?.type == "appointment" ||
                  bookingOptions?.type == "table")
                Availability(
                  bookingOptions: bookingOptions,
                ),
              if (bookingOptions?.type == "appointment")
                Padding(
                    padding: const EdgeInsets.only(left: 48.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (bookingOptions?.appointmentSlot?.sameSlotAllDays ==
                            true)
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: bookingOptions
                                    ?.appointmentSlot?.slotManyDays?.length ??
                                0,
                            itemBuilder: (context, index) {
                              List<SlotManyDay>? slot =
                                  bookingOptions?.appointmentSlot?.slotManyDays;
                              final from = slot?.firstOrNull?.from;
                              final to = slot?.firstOrNull?.to;
                              if (from == null && to == null) {
                                return Text(StringConstants.closed.localized());
                              }
                              return Text("$from - $to");
                            },
                          ),
                        if (bookingOptions?.appointmentSlot?.sameSlotAllDays ==
                            false)
                          Theme(
                            data: Theme.of(context).copyWith(
                                dividerColor: MobiKulTheme.transparentColor),
                            child: ExpansionTile(
                              tilePadding: const EdgeInsets.all(0),
                              childrenPadding: const EdgeInsets.all(0),
                              expandedAlignment: Alignment.centerLeft,
                              minTileHeight: 15,
                              expandedCrossAxisAlignment:
                                  CrossAxisAlignment.start,
                              trailing: const Icon(Icons.expand_more),
                              title: Text(
                                StringConstants.seeDetails.localized(),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: bookingOptions?.appointmentSlot
                                          ?.slotOneDay?.length ??
                                      0,
                                  itemBuilder: (context, index) {
                                    final dayName = daysOfWeek[index];
                                    final List<SlotOneDay>? slots =
                                        bookingOptions?.appointmentSlot
                                            ?.slotOneDay?[index];

                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4.0, horizontal: 0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 100,
                                            child: Text(
                                              "$dayName:",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Expanded(
                                            child: slots == null ||
                                                    slots.isEmpty
                                                ? Text(StringConstants.closed
                                                    .localized())
                                                : Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: slots.map((slot) {
                                                      return Text(
                                                          "${slot.from} - ${slot.to}");
                                                    }).toList(),
                                                  ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                      ],
                    )),
              if (bookingOptions?.type == "table")
                Padding(
                  padding: const EdgeInsets.only(
                      left: 48.0), // Matches the left padding of the Row widget
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (bookingOptions?.tableSlot?.sameSlotAllDays == true)
                        Theme(
                          data: Theme.of(context).copyWith(
                              dividerColor: MobiKulTheme.transparentColor),
                          child: ExpansionTile(
                            tilePadding: const EdgeInsets.all(0),
                            childrenPadding: const EdgeInsets.all(0),
                            expandedAlignment: Alignment.centerLeft,
                            minTileHeight: 15,
                            expandedCrossAxisAlignment:
                                CrossAxisAlignment.start,
                            trailing: const Icon(Icons.expand_more),
                            title: Text(
                              StringConstants.seeDetails.localized(),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: 7,
                                itemBuilder: (context, index) {
                                  final dayName = daysOfWeek[index];
                                  List<SlotManyDay>? slots =
                                      bookingOptions?.tableSlot?.slotManyDays;

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0, horizontal: 0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 100,
                                          child: Text(
                                            "$dayName:",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Expanded(
                                          child: slots == null || slots.isEmpty
                                              ? Text(StringConstants.seeDetails
                                                  .localized())
                                              : Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: slots.map((slot) {
                                                    return Text(
                                                        "${slot.from} - ${slot.to}");
                                                  }).toList(),
                                                ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      if (bookingOptions?.tableSlot?.sameSlotAllDays == false)
                        Theme(
                          data: Theme.of(context).copyWith(
                              dividerColor: MobiKulTheme.transparentColor),
                          child: ExpansionTile(
                            tilePadding: const EdgeInsets.all(0),
                            childrenPadding: const EdgeInsets.all(0),
                            expandedAlignment: Alignment.centerLeft,
                            minTileHeight: 15,
                            expandedCrossAxisAlignment:
                                CrossAxisAlignment.start,
                            trailing: const Icon(Icons.expand_more),
                            title: Text(
                              StringConstants.seeDetails.localized(),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: bookingOptions
                                        ?.tableSlot?.slotOneDay?.length ??
                                    0,
                                itemBuilder: (context, index) {
                                  final dayName = daysOfWeek[index];
                                  final List<SlotOneDay>? slots = bookingOptions
                                      ?.tableSlot?.slotOneDay?[index];

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0, horizontal: 0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 100,
                                          child: Text(
                                            "$dayName:",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Expanded(
                                          child: slots == null || slots.isEmpty
                                              ? Text(StringConstants.closed
                                                  .localized())
                                              : Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: slots.map((slot) {
                                                    return Text(
                                                        "${slot.from} - ${slot.to}");
                                                  }).toList(),
                                                ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                )
            ]),
          const SizedBox(height: 12),
          Text(
            bookingOptions?.type == "default"
                ? "Booking Options"
                : bookingOptions?.type == "rental"
                    ? "Choose Rent Option *"
                    : "Other options",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          if (bookingOptions?.type == "rental" &&
              bookingOptions?.rentalSlot["rentingType"] == "daily_hourly")
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Radio<String>(
                      value: StringConstants.daily.localized(),
                      groupValue: selectedBooking["rentingType"],
                      onChanged: (String? value) {
                        setState(() {
                          selectedBooking["rentingType"] = value;
                          widget.callBack?.call(selectedBooking);
                        });
                      },
                      fillColor:
                          WidgetStateProperty.all(MobiKulTheme.accentColor),
                    ),
                    Text(
                      StringConstants.dailyBasis.localized(),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(width: 16),
                    Radio<String>(
                      value: StringConstants.hourly.localized(),
                      groupValue: selectedBooking["rentingType"],
                      onChanged: (String? value) {
                        setState(() {
                          selectedBooking["rentingType"] = value;
                          widget.callBack?.call(selectedBooking);
                        });
                      },
                      fillColor:
                          WidgetStateProperty.all(MobiKulTheme.accentColor),
                    ),
                    Text(
                      StringConstants.hourlyBasis.localized(),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ],
            ),
          const SizedBox(height: 12),
          if (bookingOptions?.type == "rental" &&
              selectedBooking["rentingType"] == "daily")
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  StringConstants.selectDate.localized(),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                Row(children: [
                  InkWell(
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                        builder: (BuildContext context, Widget? child) {
                          return Theme(
                            data: ThemeData.light(),
                            child: child ?? const SizedBox(),
                          );
                        },
                      );
                      if (pickedDate != null) {
                        setState(() {
                          selectedBooking["from"] = DateFormat('yyyy-MM-dd')
                              .format(pickedDate)
                              .toString();
                          selectedBooking["slot"] = {
                            "from": timeToMilliseconds(
                                "00:00", selectedBooking["from"]),
                          };
                          widget.callBack?.call(selectedBooking);
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: MobiKulTheme.skeletonLoaderColorDark),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        selectedBooking["from"] != null
                            ? "${selectedBooking["from"]}".split(' ')[0]
                            : "From Date",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  InkWell(
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                        builder: (BuildContext context, Widget? child) {
                          return Theme(
                            data: ThemeData.light(),
                            child: child ?? const SizedBox(),
                          );
                        },
                      );
                      if (pickedDate != null) {
                        setState(() {
                          selectedBooking["to"] = DateFormat('yyyy-MM-dd')
                              .format(pickedDate)
                              .toString();
                          selectedBooking["slot"] = {
                            ...selectedBooking["slot"],
                            "to": timeToMilliseconds(
                                "23:59", selectedBooking["to"]),
                          };
                          widget.callBack?.call(selectedBooking);
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: MobiKulTheme.skeletonLoaderColorDark),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        selectedBooking["to"] != null
                            ? "${selectedBooking["to"]}".split(' ')[0]
                            : "To Date",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  )
                ]),
              ],
            ),
          if (bookingOptions?.type == "rental" &&
              selectedBooking["rentingType"] == "hourly")
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date Picker Field
                Text(
                  StringConstants.selectDate.localized(),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                      builder: (BuildContext context, Widget? child) {
                        return Theme(
                          data: ThemeData.light(),
                          child: child ?? const SizedBox(),
                        );
                      },
                    );
                    if (pickedDate != null) {
                      setState(() {
                        selectedBooking["date"] = DateFormat('yyyy-MM-dd')
                            .format(pickedDate)
                            .toString();
                        selectedBooking["availableBookingSlots"] = [];
                        selectedBooking["slot"] = null;
                        getSlotsForSelectedDate(pickedDate);
                        widget.callBack?.call(selectedBooking);
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: MobiKulTheme.skeletonLoaderColorDark),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      selectedBooking["date"] != null
                          ? "${selectedBooking["date"]}".split(' ')[0]
                          : "Select Date",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: widget.bookingSlotsData?.data?.any((slot) =>
                              jsonEncode(slot.slots) ==
                              jsonEncode(
                                  selectedBooking["availableBookingSlots"])) ==
                          true
                      ? jsonEncode(selectedBooking["availableBookingSlots"])
                      : null,
                  hint: (widget.bookingSlotsData?.data?.isEmpty ?? true) &&
                          selectedBooking["date"] != null
                      ? Text(StringConstants.noSlotsAvailable.localized(),
                          style: TextStyle(fontSize: 15))
                      : Text(StringConstants.selectSlot.localized(),
                          style: TextStyle(fontSize: 15)),
                  items: widget.bookingSlotsData?.data!
                      .map<DropdownMenuItem<String>>((slot) {
                    final slotLabel = "${slot.time}";
                    return DropdownMenuItem<String>(
                      value: jsonEncode(slot.slots),
                      child: Text(slotLabel),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      selectedBooking["availableBookingSlots"] =
                          value != null ? jsonDecode(value) : null;
                      widget.callBack?.call(selectedBooking);
                    });
                  },
                  borderRadius: BorderRadius.circular(8),
                  decoration: InputDecoration(
                      labelText: StringConstants.selectSlot.localized(),
                      labelStyle: Theme.of(context).textTheme.labelSmall,
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder()),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedBooking["slot"]?["from"],
                        hint: (widget.bookingSlotsData?.data?.isEmpty ??
                                    true) &&
                                selectedBooking["date"] != null
                            ? Text(StringConstants.noSlotsAvailable.localized(),
                                style: TextStyle(fontSize: 15))
                            : Text(StringConstants.selectTimeSlot.localized(),
                                style: TextStyle(fontSize: 15)),
                        items: selectedBooking["availableBookingSlots"]
                            ?.map((slot) {
                              final from = slot["from"] ?? "";
                              final fromTimestamp = slot["fromTimestamp"] ?? "";
                              return MapEntry(fromTimestamp, from);
                            })
                            .toSet() // ensure uniqueness
                            .map<DropdownMenuItem<String>>((entry) {
                              final fromTimestamp = entry.key;
                              final fromLabel = entry.value;
                              return DropdownMenuItem<String>(
                                value: fromTimestamp, // safe, clean
                                child: Text(fromLabel),
                              );
                            })
                            .toList(),
                        onChanged: (String? value) {
                          setState(() {
                            selectedBooking["slot"] = value != null
                                ? {
                                    ...?selectedBooking["slot"],
                                    "from": value,
                                  }
                                : null;
                            widget.callBack?.call(selectedBooking);
                          });
                        },
                        borderRadius: BorderRadius.circular(8),
                        decoration: InputDecoration(
                          labelText: StringConstants.selectTimeSlot.localized(),
                          labelStyle: Theme.of(context).textTheme.labelSmall,
                          border: const OutlineInputBorder(),
                          focusedBorder: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedBooking["slot"]?["to"],
                        hint: (widget.bookingSlotsData?.data?.isEmpty ??
                                    true) &&
                                selectedBooking["date"] != null
                            ? Text(StringConstants.noSlotsAvailable.localized(),
                                style: TextStyle(fontSize: 15))
                            : Text(StringConstants.selectTimeSlot.localized(),
                                style: TextStyle(fontSize: 15)),
                        items: selectedBooking["availableBookingSlots"]
                            ?.map((slot) {
                              final to = slot["to"] ?? "";
                              final toTimestamp = slot["toTimestamp"] ?? "";
                              return MapEntry(toTimestamp, to);
                            })
                            .toSet() // ensures uniqueness
                            .map<DropdownMenuItem<String>>((entry) {
                              // entry is a MapEntry of toTimestamp -> to
                              final toTimestamp = entry.key;
                              final toLabel = entry.value;
                              return DropdownMenuItem<String>(
                                value: toTimestamp,
                                child: Text(toLabel),
                              );
                            })
                            .toList(),
                        onChanged: (String? value) {
                          setState(() {
                            selectedBooking["slot"] = value != null
                                ? {
                                    ...?selectedBooking["slot"],
                                    "to": value,
                                  }
                                : null;
                            widget.callBack?.call(selectedBooking);
                          });
                        },
                        borderRadius: BorderRadius.circular(8),
                        decoration: InputDecoration(
                          labelText: StringConstants.selectTimeSlot.localized(),
                          labelStyle: Theme.of(context).textTheme.labelSmall,
                          border: const OutlineInputBorder(),
                          focusedBorder: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          const SizedBox(height: 12),
          if (bookingOptions?.type == "default" ||
              bookingOptions?.type == "appointment")
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date Picker Field
                Text(
                  StringConstants.selectDate.localized(),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                      builder: (BuildContext context, Widget? child) {
                        return Theme(
                          data: ThemeData.light(),
                          child: child ?? const SizedBox(),
                        );
                      },
                    );
                    if (pickedDate != null) {
                      setState(() {
                        selectedBooking["date"] = DateFormat('yyyy-MM-dd')
                            .format(pickedDate)
                            .toString();
                        setSlotsOnPickedDate =
                            getSlotsForSelectedDate(pickedDate);
                        widget.callBack?.call(selectedBooking);
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: MobiKulTheme.skeletonLoaderColorDark),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      selectedBooking["date"] != null
                          ? "${selectedBooking["date"]}".split(' ')[0]
                          : "Select Date",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                if (bookingOptions?.type == "default" ||
                    bookingOptions?.type == "appointment")
                  DropdownButtonFormField<String>(
                    value: widget.bookingSlotsData?.data?.any((slot) =>
                                jsonEncode({
                                  "from": slot?.timestamp?.split("-")[0] ?? "",
                                  "to": slot?.timestamp?.split("-")[1] ?? ""
                                }) ==
                                jsonEncode(selectedBooking["slot"])) ==
                            true
                        ? jsonEncode(selectedBooking["slot"])
                        : null,
                    hint: (widget.bookingSlotsData?.data?.isEmpty ?? true) &&
                            selectedBooking["date"] != null
                        ? Text(StringConstants.noSlotsAvailable.localized(),
                            style: TextStyle(fontSize: 15))
                        : const Text(StringConstants.selectSlot,
                            style: TextStyle(fontSize: 15)),
                    items: widget.bookingSlotsData?.data!
                        .map<DropdownMenuItem<String>>((slot) {
                      final from = slot.from;
                      final to = slot.to;

                      final slotLabel = "$from - $to";
                      return DropdownMenuItem<String>(
                        value: jsonEncode({
                          "from": slot?.timestamp?.split("-")[0] ?? "",
                          "to": slot?.timestamp?.split("-")[1] ?? "",
                        }),
                        child: Text(slotLabel),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        selectedBooking["slot"] =
                            value != null ? jsonDecode(value) : null;
                        widget.callBack?.call(selectedBooking);
                      });
                    },
                    borderRadius: BorderRadius.circular(8),
                    decoration: InputDecoration(
                        labelText: StringConstants.selectSlot.localized(),
                        labelStyle: Theme.of(context).textTheme.labelSmall,
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder()),
                  ),
              ],
            ),
          // if (bookingOptions?.type == "appointment")
          // Column(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     // Date Picker Field
          //     Text(
          //       "Select Date",
          //       style: Theme.of(context).textTheme.bodyMedium,
          //     ),
          //     const SizedBox(height: 8),
          //     InkWell(
          //       onTap: () async {
          //         DateTime? pickedDate = await showDatePicker(
          //           context: context,
          //           initialDate: DateTime.now(),
          //           firstDate: DateTime.now(),
          //           lastDate: DateTime.now().add(const Duration(days: 365)),
          //           builder: (BuildContext context, Widget? child) {
          //             return Theme(
          //               data: ThemeData.light(),
          //               child: child ?? const SizedBox(),
          //             );
          //           },
          //         );
          //         if (pickedDate != null) {
          //           log("picked data");
          //           log("$pickedDate");
          //           setState(() {
          //             selectedBooking["date"] = DateFormat('yyyy-MM-dd')
          //                 .format(pickedDate)
          //                 .toString();

          //             getSlotsForSelectedDate(pickedDate);
          //             widget.callBack?.call(selectedBooking);
          //           });
          //         }
          //       },
          //       child: Container(
          //         padding: const EdgeInsets.symmetric(
          //             vertical: 12, horizontal: 16),
          //         decoration: BoxDecoration(
          //           border: Border.all(color: MobiKulTheme.skeletonLoaderColorDark),
          //           borderRadius: BorderRadius.circular(8),
          //         ),
          //         child: Text(
          //           selectedBooking["date"] != null
          //               ? "${selectedBooking["date"]}".split(' ')[0]
          //               : "Select Date",
          //           style: Theme.of(context).textTheme.bodyMedium,
          //         ),
          //       ),
          //     ),
          //     const SizedBox(height: 12),
          //     DropdownButtonFormField<String>(
          //       value: setSlotsOnPickedDate.any((slot) =>
          //               jsonEncode({
          //                 "from": timeToMilliseconds(
          //                     slot?.from, selectedBooking["date"] ?? ""),
          //                 "to": timeToMilliseconds(
          //                     slot?.to, selectedBooking["date"])
          //               }) ==
          //               jsonEncode(selectedBooking["slot"]))
          //           ? jsonEncode(selectedBooking["slot"])
          //           : null,
          //       hint: setSlotsOnPickedDate.isEmpty &&
          //               selectedBooking["date"] != null
          //           ? const Text("No slots available")
          //           : const Text("Select Slot"),
          //       items: setSlotsOnPickedDate
          //           .map<DropdownMenuItem<String>>((slot) {
          //         final from = slot?.from;
          //         final to = slot?.to;
          //         final fromDay = null;
          //         final toDay = null;
          //         final slotLabel = "$from - $to";
          //         return DropdownMenuItem<String>(
          //           value: (toDay != null && fromDay != null)
          //               ? jsonEncode({
          //                   "from": timeToMilliseconds(
          //                       from, selectedBooking["date"]),
          //                   "to": toDay > fromDay
          //                       ? timeToMilliseconds(
          //                               to, selectedBooking["date"]) +
          //                           Duration(days: toDay - fromDay).inSeconds
          //                       : timeToMilliseconds(
          //                           to, selectedBooking["date"]),
          //                 })
          //               : jsonEncode({
          //                   "from": timeToMilliseconds(
          //                       from, selectedBooking["date"]),
          //                   "to": timeToMilliseconds(
          //                       to, selectedBooking["date"])
          //                 }),
          //           child: Text(slotLabel),
          //         );
          //       }).toList(),
          //       onChanged: (String? value) {
          //         setState(() {
          //           selectedBooking["slot"] =
          //               value != null ? jsonDecode(value) : null;
          //           widget.callBack?.call(selectedBooking);
          //         });
          //       },
          //       borderRadius: BorderRadius.circular(8),
          //       decoration: InputDecoration(
          //           labelText: "Select Slot",
          //           labelStyle: Theme.of(context).textTheme.labelSmall,
          //           border: OutlineInputBorder(),
          //           focusedBorder: OutlineInputBorder()),
          //     ),
          //   ],
          // ),
          if (bookingOptions?.type == "table")
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date Picker Field
                Text(
                  StringConstants.selectDate.localized(),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: bookingOptions?.availableTo != null
                          ? DateTime.parse(bookingOptions!.availableTo!)
                          : DateTime.now().add(const Duration(days: 365)),
                      builder: (BuildContext context, Widget? child) {
                        return Theme(
                          data: ThemeData.light(),
                          child: child ?? const SizedBox(),
                        );
                      },
                    );
                    if (pickedDate != null) {
                      setState(() {
                        selectedBooking["date"] = DateFormat('yyyy-MM-dd')
                            .format(pickedDate)
                            .toString();
                        setSlotsOnPickedDate =
                            getSlotsForSelectedDate(pickedDate);
                        widget.callBack?.call(selectedBooking);
                      });
                    }

                    setState(() {});
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: MobiKulTheme.skeletonLoaderColorDark),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      selectedBooking["date"] != null
                          ? "${selectedBooking["date"]}".split(' ')[0]
                          : "Select Date",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                if (bookingOptions?.type == "table")
                  DropdownButtonFormField<int>(
                    value: selectedBooking[
                        "slotIndex"], // Store selected index instead of full slot
                    hint: (widget.bookingSlotsData?.data?.isEmpty ?? true) &&
                            selectedBooking["date"] != null
                        ? Text(StringConstants.noSlotsAvailable.localized(),
                            style: TextStyle(fontSize: 15))
                        : Text(StringConstants.selectSlot.localized(),
                            style: TextStyle(fontSize: 15)),
                    items: List.generate(
                        widget.bookingSlotsData?.data?.length ?? 0, (index) {
                      final slot = widget.bookingSlotsData!.data![index];
                      final from = slot.from;
                      final to = slot.to;
                      return DropdownMenuItem<int>(
                        value: index,
                        child: Text("$from - $to"),
                      );
                    }),
                    onChanged: (int? index) {
                      setState(() {
                        if (index != null) {
                          selectedBooking["slotIndex"] = index;
                          selectedBooking["slot"] = {
                            "from": widget
                                    .bookingSlotsData!.data![index].timestamp
                                    ?.split("-")[0] ??
                                "",
                            "to": widget
                                    .bookingSlotsData!.data![index].timestamp
                                    ?.split("-")[1] ??
                                "",
                          };
                        } else {
                          selectedBooking["slotIndex"] = null;
                          selectedBooking["slot"] = null;
                        }
                        widget.callBack?.call(selectedBooking);
                      });
                    },
                    borderRadius: BorderRadius.circular(8),
                    decoration: InputDecoration(
                      labelText: StringConstants.selectSlot.localized(),
                      labelStyle: Theme.of(context).textTheme.labelSmall,
                      border: const OutlineInputBorder(),
                      focusedBorder: const OutlineInputBorder(),
                    ),
                  ),

                const SizedBox(height: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      StringConstants.specialRequestNotes.localized(),
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      style: Theme.of(context).textTheme.bodyMedium,
                      onChanged: (value) {
                        selectedBooking["note"] = value;
                        widget.callBack?.call(selectedBooking);
                      },
                      decoration: InputDecoration(
                        alignLabelWithHint: true,
                        hintText:
                            StringConstants.specialRequestNotes.localized(),
                        hintStyle: Theme.of(context).textTheme.bodySmall,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                                Radius.circular(AppSizes.spacingSmall)),
                            borderSide: BorderSide(
                                color: MobiKulTheme.skeletonLoaderColorDark)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                                Radius.circular(AppSizes.spacingSmall)),
                            borderSide: BorderSide(
                                color: MobiKulTheme.skeletonLoaderColorDark)),
                        errorBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                                Radius.circular(AppSizes.spacingSmall)),
                            borderSide:
                                BorderSide(color: MobiKulTheme.errorColor)),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(Radius.zero),
                          borderSide: BorderSide(
                              color: MobiKulTheme.skeletonLoaderColorDark),
                        ),
                      ),
                      validator: (value) {
                        if (((value ?? "").trim()).isEmpty) {
                          return StringConstants.specialRequestNotesRequired
                              .localized();
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                    )
                  ],
                )
              ],
            ),
          if (bookingOptions?.type == "event")
            EventScreen(
              bookingOptions: bookingOptions,
              callBack: (data) {
                selectedBooking["qty"] = data;
                widget.callBack?.call(selectedBooking);
              },
            ),
          if (bookingOptions?.type != "event") const SizedBox(height: 12),
          if (bookingOptions?.type != "event")
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  StringConstants.quantity.localized(),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        setState(() {
                          if (selectedBooking["qty"] > 1) {
                            selectedBooking["qty"] -= 1;

                            widget.callBack?.call(selectedBooking);
                          }
                        });
                      },
                    ),
                    Text(
                      "${selectedBooking["qty"]}",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          selectedBooking["qty"] += 1;
                          widget.callBack?.call(selectedBooking);
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }

  final List<String> daysOfWeek = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];

  String getTodayDayOfWeek() {
    final now = DateTime.now();
    return DateFormat('EEEE').format(now); // e.g., "Wednesday"
  }
}
