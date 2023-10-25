
/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

import 'search_initial_state.dart';

///Circular loader event

// ignore_for_file: file_names

class CircularBarState extends SearchInitialState {
  final bool? isReqToShowLoader;

  CircularBarState({this.isReqToShowLoader});

  @override
  List<Object> get props => [isReqToShowLoader!];
}
