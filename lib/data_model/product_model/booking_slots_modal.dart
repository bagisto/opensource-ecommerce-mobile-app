import 'package:json_annotation/json_annotation.dart';

part 'booking_slots_modal.g.dart';

@JsonSerializable()
class BookingSlot {
  final String? from;
  final String? to;
  final String? fromTimestamp;
  final String? toTimestamp;
  final bool? qty;

  BookingSlot({
    this.from,
    this.to,
    this.fromTimestamp,
    this.toTimestamp,
    this.qty,
  });

  factory BookingSlot.fromJson(Map<String, dynamic> json) =>
      _$BookingSlotFromJson(json);

  Map<String, dynamic> toJson() => _$BookingSlotToJson(this);
}

@JsonSerializable()
class SlotGroup {
  final String? from;
  final String? to;
  final String? timestamp;
  final bool? qty;
  final String? time;
  final List<BookingSlot>? slots;

  SlotGroup({
    this.from,
    this.to,
    this.timestamp,
    this.qty,
    this.time,
    this.slots,
  });

  factory SlotGroup.fromJson(Map<String, dynamic> json) =>
      _$SlotGroupFromJson(json);

  Map<String, dynamic> toJson() => _$SlotGroupToJson(this);
}

@JsonSerializable()
class BookingSlotsData {
  final List<SlotGroup>? data;
  final bool? status;
  final bool? responseStatus;

  BookingSlotsData({this.data, this.status, this.responseStatus});

  factory BookingSlotsData.fromJson(Map<String, dynamic> json) =>
      _$BookingSlotsDataFromJson(json);

  Map<String, dynamic> toJson() => _$BookingSlotsDataToJson(this);
}
