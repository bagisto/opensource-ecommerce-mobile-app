/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// ignore_for_file: file_names





import 'hoempage_base_state.dart';

class OnClickLoaderState extends HomePageBaseState {
  final bool? isReqToShowLoader;

  OnClickLoaderState({this.isReqToShowLoader});

  List<Object> get props => [isReqToShowLoader!];
}
