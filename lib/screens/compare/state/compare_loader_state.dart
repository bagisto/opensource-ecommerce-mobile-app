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

import 'package:bagisto_app_demo/screens/compare/state/compare_base_state.dart';



class OnClickCompareLoaderState extends CompareScreenBaseState {
  final bool? isReqToShowLoader;

  OnClickCompareLoaderState({this.isReqToShowLoader});

  @override
  List<Object> get props => [isReqToShowLoader!];
}
