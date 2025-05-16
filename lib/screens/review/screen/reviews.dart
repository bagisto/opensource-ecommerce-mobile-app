/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/screens/review/utils/index.dart';

class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({Key? key, this.isFromDashboard}) : super(key: key);
  final bool? isFromDashboard;

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  ReviewModel? reviewModel;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  ReviewsBloc? reviewsBloc;
  int page = 1;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    reviewsBloc = context.read<ReviewsBloc>();
    reviewsBloc?.add(FetchReviewsEvent(page));
    _scrollController.addListener(() {
      paginationFunction();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Scaffold(
        appBar: (widget.isFromDashboard ?? false)
            ? null
            : AppBar(
                centerTitle: false,
                title: Text(
                  StringConstants.reviews.localized(),
                )),
        body: _reviewsBloc(context),
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
        if (page > 1) {
          reviewModel?.data?.addAll(state.reviewModel?.data ?? []);
          reviewModel?.paginatorInfo = state.reviewModel?.paginatorInfo;
        } else {
          reviewModel = state.reviewModel;
        }
        return _reviewsList(reviewModel!);
      }
      if (state.status == ReviewStatus.fail) {
        return EmptyDataView();
      }
    }

    if (state is ReviewInitialState) {
      return const ReviewLoader();
    }

    return const SizedBox();
  }

  ///method use to show review list
  _reviewsList(ReviewModel? reviewModel) {
    if (reviewModel == null) {
      return const NoDataFound();
    } else {
      if ((reviewModel.data ?? []).isEmpty) {
        return EmptyDataView(
          assetPath: AssetConstants.emptyReviews,
          message: "noReview".localized(),
        );
      } else {
        return Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 8, 8, 0),
          child: ListView.builder(
              controller: _scrollController,
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
              }),
        );
      }
    }
  }

  void paginationFunction() {
    if (_scrollController.offset ==
            _scrollController.position.maxScrollExtent &&
        ((reviewModel?.paginatorInfo?.currentPage ?? 0) <
            (reviewModel?.paginatorInfo?.lastPage ?? 0))) {
      page++;
      reviewsBloc?.add(FetchReviewsEvent(page));
    }
  }
}
