/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

import 'dart:async';
import 'package:bagisto_app_demo/screens/cart_screen/cart_index.dart';
import 'package:bagisto_app_demo/utils/no_data_found_widget.dart';
import 'package:bagisto_app_demo/screens/review/utils/index.dart';

class ReviewsScreen extends StatefulWidget {
  ReviewsScreen({Key? key, this.isFromDashboard}) : super(key: key);
 final  bool? isFromDashboard;

  @override
  _ReviewsScreenState createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  ReviewModel? reviewModel;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
  GlobalKey<ScaffoldMessengerState>();
  final StreamController streamController = StreamController.broadcast();
  ReviewsBloc? reviewsBloc;

  Stream get onUpdate => streamController.stream;
  bool _isVisible = false;

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
            title: Text(
                StringConstants.reviews.localized(),
          )),
          body: _reviewsBloc(context),
          floatingActionButton: (widget.isFromDashboard ?? false)
              ? null
              : StreamBuilder(
            stream: onUpdate,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Visibility(
                  visible: _isVisible,
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
        ),
      ),
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
            ShowMessage.showNotification(
                "Failed", state.error, Colors.red, Icon(Icons.cancel_outlined));
          } else if (state.status == ReviewStatus.success) {
            ShowMessage.showNotification(
                "Success",
                state.baseModel?.message,
                Color.fromRGBO(140, 194, 74, 5),
                Icon(Icons.check_circle_outline));
          }
        } else if (state is RemoveAllReviewState) {
          if (state.status == ReviewStatus.fail) {
            ShowMessage.showNotification(
                "Failed", state.error, Colors.red, Icon(Icons.cancel_outlined));
          } else if (state.status == ReviewStatus.success) {
            ShowMessage.showNotification(
                "Success",
                state.baseModel?.message,
                Color.fromRGBO(140, 194, 74, 5),
                Icon(Icons.check_circle_outline));
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
      return const ReviewLoader();
    }

    return Container();
  }

  ///method use to show review list
  _reviewsList(ReviewModel reviewModel) {
    if (reviewModel == null) {
      return const NoDataFound();
    } else {
      if ((reviewModel.data ?? []).isEmpty) {
        streamController.add(false);
        return const EmptyDataView(
          assetPath: AssetConstants.emptyReviews,
          message: "noReview",
        );
      } else {
        streamController.add(true);
        return Padding(
          padding: const EdgeInsets.fromLTRB(8.0,8,8,0),
          child: ListView.builder(
              itemCount: (widget.isFromDashboard ?? false)
                  ? ((reviewModel.data?.length ?? 0) > 5)
                  ? 5
                  : reviewModel.data?.length ?? 0
                  : reviewModel.data?.length ?? 0,
              itemBuilder: (context, index) {
                return ReviewsList(
                  reviewData: reviewModel.data?[index],
                  reviewsBloc:
                  reviewsBloc, /*callback:  _callBack(int.parse(reviewModel.data?[index].id??"")),*/
                );
              }),
        );
      }
    }
  }
}
