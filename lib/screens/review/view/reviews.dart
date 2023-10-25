// ignore_for_file: must_be_immutable

/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// ignore_for_file: file_names, unnecessary_null_comparison

import 'dart:async';

import 'package:bagisto_app_demo/common_widget/common_widgets.dart';
import 'package:bagisto_app_demo/helper/no_data_class.dart';
import 'package:bagisto_app_demo/helper/application_localization.dart';
import 'package:bagisto_app_demo/models/review_model/review_model.dart';
import 'package:bagisto_app_demo/screens/review/bloc/review_bloc.dart';
import 'package:bagisto_app_demo/screens/review/events/fetch_review_evnt.dart';
import 'package:bagisto_app_demo/screens/review/state/fetch_review_state.dart';
import 'package:bagisto_app_demo/screens/review/state/review_base_state.dart';
import 'package:bagisto_app_demo/screens/review/state/review_initial_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common_widget/circular_progress_indicator.dart';
import '../../../common_widget/common_error_msg.dart';
import '../../../common_widget/show_message.dart';
import '../../../configuration/app_global_data.dart';
import 'empty_reviews.dart';
import 'reviews_list.dart';

class ReviewsScreen extends StatefulWidget {
  ReviewsScreen({Key? key, this.isFromDashboard}) : super(key: key);
  bool? isFromDashboard;

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  ReviewModel? reviewModel;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  final StreamController streamController = StreamController.broadcast();
  ReviewsBloc? reviewsBloc;

  Stream get onUpdate => streamController.stream;
  bool isVisible = false;

  @override
  void initState() {
    reviewsBloc = context.read<ReviewsBloc>();
    reviewsBloc?.add(FetchReviewsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Directionality(
        textDirection: GlobalData.contentDirection(),
        child: Scaffold(
        appBar: (widget.isFromDashboard ?? false)
            ? null
            : AppBar(
                centerTitle: false,
                title: CommonWidgets.getHeadingText(
                    "Reviews".localized(), context),
              ),
        body:  _reviewsBloc(context),
        floatingActionButton: (widget.isFromDashboard ?? false)
            ? null
            : StreamBuilder(
                stream: onUpdate,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Visibility(
                      visible: isVisible,
                      child: FloatingActionButton(
                        onPressed: () {},
                        child: const Icon(Icons.delete),
                      ),
                    );
                  }
                  return Visibility(
                    visible: snapshot.data.toString() == "true" ? true : false,
                    child: FloatingActionButton(
                      onPressed: () {
                        ReviewsBloc reviewsBloc = context.read<ReviewsBloc>();
                        reviewsBloc.add(RemoveAllReviewsEvent());
                      },
                      child: Icon(
                        Icons.delete,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                  );
                },
              ),
      ), ),
    );
  }

  ///Reviews Bloc container
  _reviewsBloc(BuildContext context) {
    return BlocConsumer<ReviewsBloc, ReviewsBaseState>(
      listener: (BuildContext context, ReviewsBaseState state) {
        if (state is FetchReviewState) {
          if (state.status == ReviewStatus.fail) {
          } else if (state.status == ReviewStatus.success) {}
        } else if (state is RemoveReviewState) {
          if (state.status == ReviewStatus.fail) {
            ShowMessage.showNotification("Failed", state.error, Colors.red,
                const Icon(Icons.cancel_outlined));
          } else if (state.status == ReviewStatus.success) {
            ShowMessage.showNotification(
                state.baseModel?.message,
                "",
                const Color.fromRGBO(140, 194, 74, 5),
                const Icon(Icons.check_circle_outline));
          }
        } else if (state is RemoveAllReviewState) {
          if (state.status == ReviewStatus.fail) {
            ShowMessage.showNotification("Failed", state.error, Colors.red,
                const Icon(Icons.cancel_outlined));
          } else if (state.status == ReviewStatus.success) {
            ShowMessage.showNotification(
                state.baseModel?.message,
                "",
                const Color.fromRGBO(140, 194, 74, 5),
                const Icon(Icons.check_circle_outline));
          }
        }
      },
      builder: (BuildContext context, ReviewsBaseState state) {
        return buildUI(context, state);
      },
    );
  }

  ///Reviews UI methods
  Widget buildUI(BuildContext context, ReviewsBaseState state) {
    if (state is FetchReviewState) {
      if (state.status == ReviewStatus.success) {
        reviewModel = state.reviewModel;
        return _reviewsList(state.reviewModel!);
      }
      if (state.status == ReviewStatus.fail) {
        return ErrorMessage.errorMsg(state.error ?? "");
      }
    }

    if (state is RemoveReviewState) {
      if (state.status == ReviewStatus.success) {
        var productId = state.productDeletedId;
        if (reviewModel != null) {
          reviewModel!.data!.removeWhere(
              (element) => element.id.toString() == productId.toString());

          return _reviewsList(reviewModel!);
        } else {}
      }
    }
    if (state is RemoveAllReviewState) {
      if (state.status == ReviewStatus.success) {
        if (reviewModel != null) {
          reviewModel?.data?.clear();
          streamController.add(false);
          return _reviewsList(reviewModel!);
        } else {}
      }
    }
    if (state is ReviewInitialState) {
      return CircularProgressIndicatorClass.circularProgressIndicator(context);
    }

    return Container();
  }

  ///method use to show review list
  _reviewsList(ReviewModel reviewModel) {
    if (reviewModel == null) {
      return const NoDataFound();
    } else {
      if (reviewModel.data!.isEmpty) {
        streamController.add(false);
        return const EmptyReviews();
      } else {
        streamController.add(true);
        return ListView.builder(
            itemCount: (widget.isFromDashboard ?? false)
                ? ((reviewModel.data?.length ?? 0) > 5)
                    ? 5
                    : reviewModel.data?.length ?? 0
                : reviewModel.data?.length ?? 0,
            itemBuilder: (context, index) {
              return ReviewsList(
                reviewData: reviewModel.data?[index],
                reviewsBloc: reviewsBloc,
              );
            });
      }
    }
  }
}
