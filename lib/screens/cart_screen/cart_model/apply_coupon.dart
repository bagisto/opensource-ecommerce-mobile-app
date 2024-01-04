import 'package:json_annotation/json_annotation.dart';
part 'apply_coupon.g.dart';

@JsonSerializable()
class ApplyCoupon {
  bool? success;
  String? message;

  ApplyCoupon({this.success,this.message});
  factory ApplyCoupon.fromJson(Map<String, dynamic> json) =>
      _$ApplyCouponFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ApplyCouponToJson(this);
}