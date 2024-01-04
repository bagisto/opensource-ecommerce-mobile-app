import 'package:floor/floor.dart';

@entity
class RecentProduct {
  @primaryKey
  String? id;
  int? rating;
  String? type;
  String? name;
  String? productId;
  String? shortDescription;
  String? price;
  String? specialPrice;
  String? url;
  bool? isInWishlist;
  bool? isNew;
  bool? isInSale;
  String? urlKey;

  RecentProduct(
      {this.url,
      this.rating,
      this.id,
      this.type,
      this.name,
        this.isInSale,
      this.productId,
      this.shortDescription,
      this.isInWishlist,
      this.isNew,
      this.price,this.specialPrice, this.urlKey});
}
