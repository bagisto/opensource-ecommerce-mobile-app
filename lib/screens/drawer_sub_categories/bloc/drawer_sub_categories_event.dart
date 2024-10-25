/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

abstract class DrawerSubCategoriesEvent{}

class FetchDrawerSubCategoryEvent extends DrawerSubCategoriesEvent {
  List<Map<String, dynamic>>? filters;

  FetchDrawerSubCategoryEvent(this.filters);
}

class FetchCategoryProductsEvent extends DrawerSubCategoriesEvent {
  List<Map<String, dynamic>> filters;
  int? page;

  FetchCategoryProductsEvent(this.filters, this.page);

}

class AddWishlistEvent extends DrawerSubCategoriesEvent {
  String? productId;
  AddWishlistEvent(this.productId);
}

class RemoveWishlistItemEvent extends DrawerSubCategoriesEvent {
  String? productId;
  RemoveWishlistItemEvent(this.productId);
}

class AddToCartEvent extends DrawerSubCategoriesEvent {
  int productId;
  int quantity;
  AddToCartEvent(this.productId, this.quantity);
}

class AddToCompareEvent extends DrawerSubCategoriesEvent {
  String? productId;
  AddToCompareEvent(this.productId);
}