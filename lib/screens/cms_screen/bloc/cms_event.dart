/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'package:equatable/equatable.dart';
abstract class CmsBaseEvent extends Equatable{}

class FetchCmsDataEvent extends CmsBaseEvent {
  final String? id;
  FetchCmsDataEvent(this.id);

  @override
  List<Object> get props => [];
}