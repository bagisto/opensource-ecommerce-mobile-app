import 'package:floor/floor.dart';

@entity
class RecentProduct{
  @primaryKey
  String? id;
  int ? rating;
  String? type;
  String? name;
  String? productId;
  String? shortDescription;
  String? price;
  String? url;
  bool? isInWishlist;
  bool? isNew;
  RecentProduct( {this.url,this.rating,this.id,this.type,this.name,this.productId,this.shortDescription, this.isInWishlist,this.isNew,this.price});
}
