/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */
import '../../../configuration/app_global_data.dart';
import 'add_review_index.dart';

// ignore: must_be_immutable
class AddReview extends StatefulWidget {
  String? imageUrl;
  String? productId;
  String? productName;

  AddReview({Key? key, this.imageUrl, this.productId, this.productName})
      : super(key: key);

  @override
  State<AddReview> createState() => _AddReviewState();
}

class _AddReviewState extends State<AddReview> {
  final bool _autoValidate = false;
  final _reviewFormKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final commentController = TextEditingController();
  dynamic rating;
  bool isLoading = false;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  AddReviewBloc? addReviewBloc;

  @override
  void initState() {
    addReviewBloc = context.read<AddReviewBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Directionality(
        textDirection: GlobalData.contentDirection(),
        child:Scaffold(
        appBar: AppBar(
          title:
              CommonWidgets.getHeadingText("AddaReview".localized(), context),
          centerTitle: false,
        ),
        body:  _addReviewBloc(context),
        ),
      ),
    );
  }

  ///Bloc Container
  _addReviewBloc(BuildContext context) {
    return BlocConsumer<AddReviewBloc, AddReviewBaseState>(
      listener: (BuildContext context, AddReviewBaseState state) {
        if (state is AddReviewFetchState) {
          isLoading = true;
          if (state.status == AddReviewStatus.fail) {
            ShowMessage.showNotification(
                state.error, "", Colors.red, const Icon(Icons.cancel_outlined));
          } else if (state.status == AddReviewStatus.success) {
            ShowMessage.showNotification(
                state.addReviewModel!.success ??
                   "Updated".localized(),
                "",
                const Color.fromRGBO(140, 194, 74, 5),
                const Icon(Icons.check_circle_outline));
          }
        }
      },
      builder: (BuildContext context, AddReviewBaseState state) {
        return buildUI(context, state);
      },
    );
  }

  ///add Review Ui method
  Widget buildUI(BuildContext context, AddReviewBaseState state) {
    if (state is AddReviewFetchState) {
      isLoading = true;
      if (state.status == AddReviewStatus.success) {
        return _reviewForm();
      }
      if (state.status == AddReviewStatus.fail) {
        return ErrorMessage.errorMsg(state.error ?? "");
      }
    }

    if (state is AddReviewInitialState) {
      return _reviewForm();
    }
    if (state is ImagePickerState) {
      return _reviewForm();
    }
    return Container();
  }

  /// review form
  _reviewForm() {
    return Stack(
      children: [
        SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(
                  vertical: AppSizes.mediumPadding,
                  horizontal: AppSizes.widgetSidePadding),
              child: Form(
                key: _reviewFormKey,
                autovalidateMode: _autoValidate
                    ? AutovalidateMode.onUserInteraction
                    : AutovalidateMode.disabled,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ImageView(
                        url: widget.imageUrl ?? "",
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.4),
                    CommonWidgets().getTextFieldHeight(NormalHeight),
                    Text(
                      widget.productName ?? "",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: AppSizes.mediumFontSize),
                    ),
                    CommonWidgets().getTextFieldHeight(NormalHeight),
                    Text(
                      "rating".localized(),
                      style: const TextStyle(fontSize: 16),
                    ),
                    CommonWidgets().getTextFieldHeight(AppSizes.normalPadding),
                    RatingBar.builder(
                      unratedColor: MobikulTheme.appBarBackgroundColor,
                      itemSize: 30,
                      initialRating: num.tryParse('0.0')?.toDouble() ?? 0.0,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (updatedRating) {
                        rating = updatedRating.toInt();
                      },
                    ),
                    CommonWidgets().getTextFieldHeight(AppSizes.widgetHeight),
                    CommonWidgets().getTextField(
                      context,
                      titleController,
                      "titleLabel".localized(),
                      "titleHint".localized(),
                      "PleaseFillLabel".localized() + "titleLabel".localized(),
                      validator: (email) {
                        if (((email ?? "").trim()).isEmpty) {
                          return "PleaseFillLabel".localized() +
                              "titleLabel".localized();
                        }
                        return null;
                      },
                    ),
                    CommonWidgets().getTextFieldHeight(AppSizes.widgetHeight),
                    TextFormField(
                      maxLines: 8,
                      controller: commentController,
                      style: Theme.of(context).textTheme.bodyMedium,
                      decoration: InputDecoration(
                        alignLabelWithHint: true,
                        labelText: "commentLabel".localized(),
                        hintText: "commentHint".localized(),
                        labelStyle: Theme.of(context).textTheme.bodyMedium,
                        enabledBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8.0)),
                            borderSide:
                                BorderSide(color: Colors.grey.shade500)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8.0)),
                            borderSide:
                                BorderSide(color: Colors.grey.shade500)),
                        errorBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8.0)),
                            borderSide: BorderSide(color: Colors.red.shade500)),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(Radius.zero),
                          borderSide: BorderSide(color: Colors.grey.shade500),
                        ),
                      ),
                      validator: (value) {
                        if (((value ?? "").trim()).isEmpty) {
                          return "PleaseFillLabel".localized() +
                              "commentLabel".localized();
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    CommonWidgets().getTextFieldHeight(30.0),
                    AddImageView(addReviewBloc: addReviewBloc),
                    CommonWidgets().getTextFieldHeight(20.0),
                    MaterialButton(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          side: BorderSide(width: 2)),
                      elevation: 0.0,
                      height: AppSizes.buttonHeight,
                      minWidth: MediaQuery.of(context).size.width,
                      color: Theme.of(context).colorScheme.background,
                      textColor: MobikulTheme.primaryColor,
                      onPressed: () {
                        _onPressSubmitButton();
                      },
                      child: Text(
                        "submitReview".localized().toUpperCase(),
                        style:
                            const TextStyle(fontSize: AppSizes.normalFontSize),
                      ),
                    ),
                    CommonWidgets().getTextFieldHeight(AppSizes.widgetHeight),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (isLoading) Loader()
      ],
    );
  }

  ///method will call on press submit review button
  _onPressSubmitButton() {
    if (_reviewFormKey.currentState!.validate()) {
      if ((rating ?? 0) > 0) {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return Dialog(
                child: Container(
                  padding: const EdgeInsets.all(AppSizes.widgetSidePadding),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: AppSizes.normalHeight,
                      ),
                      CircularProgressIndicatorClass.circularProgressIndicator(
                          context),
                      const SizedBox(
                        height: AppSizes.widgetHeight,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2.5,
                        child: Center(
                          child: Text(
                            "PleaseWaitProcessingRequest".localized(),
                            softWrap: true,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: AppSizes.normalHeight,
                      ),
                    ],
                  ),
                ),
              );
            });
        AddReviewBloc addReviewBloc = context.read<AddReviewBloc>();
        addReviewBloc.add(AddReviewFetchEvent(
            productId: int.parse(widget.productId ?? ''),
            rating: rating,
            title: titleController.text,
            comment: commentController.text,
            name: "test"));
        Future.delayed(const Duration(seconds: 3)).then((value) {
          Navigator.pop(context);
          Navigator.pop(context);
        });
      } else {
        ShowMessage.showNotification("PleaseAddRating".localized(), "",
            Colors.yellow, const Icon(Icons.warning_amber));
      }
    }
  }
}
