/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

abstract class DrawerEvent {}

class FetchDrawerPageEvent extends DrawerEvent {
  List<Map<String, dynamic>>? filters;
  FetchDrawerPageEvent(this.filters);

}
class CurrencyLanguageEvent extends DrawerEvent {}
