/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/screens/add_review/view/widget/add_image_view.dart';
import 'package:bagisto_app_demo/utils/application_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/app_global_data.dart';
import '../../../utils/mobikul_theme.dart';
import '../../../utils/string_constants.dart';
import '../../../widgets/common_error_msg.dart';
import '../../../widgets/common_widgets.dart';
import '../../../widgets/image_view.dart';
import '../../../widgets/loader.dart';
import '../../../widgets/show_message.dart';
import '../bloc/add_review_base_event.dart';
import '../bloc/add_review_bloc.dart';
import '../bloc/add_review_fetch_state.dart';

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
  var rating;
  bool isLoading = false;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  AddReviewBloc? addReviewBloc;
  List<Map<String, String>> images = [];

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
        child: Scaffold(
          appBar: AppBar(
            title: Text(StringConstants.addaReview.localized()),
            centerTitle: false,
          ),
          body: _addReviewBloc(context),
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
            ShowMessage.showNotification(StringConstants.failed, state.error, Colors.red,
                const Icon(Icons.cancel_outlined));
          } else if (state.status == AddReviewStatus.success) {
            ShowMessage.showNotification(
                StringConstants.success.localized(),
                state.addReviewModel!.success ?? StringConstants.updated.localized(),
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
      String? image = state.image;
      images.clear();
      if(image != null){
        images.add({
          "uploadType": '\"base64\"',
          "imageUrl": '\"data:image/png;base64,$image\"'
        });
      }
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
                  vertical: AppSizes.spacingMedium,
                  horizontal: AppSizes.spacingLarge),
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
                    const SizedBox(height: AppSizes.spacingWide),
                    Text(
                      widget.productName ?? "",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: AppSizes.spacingLarge),
                    ),
                    const SizedBox(height: AppSizes.spacingWide),
                    Text(
                      StringConstants.rating.localized(),
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: AppSizes.spacingNormal),
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
                    const SizedBox(height: AppSizes.spacingWide),
                    CommonWidgets().getTextField(
                      context,
                      titleController,
                      StringConstants.titleHint.localized(),
                      label: StringConstants.titleLabel.localized(),
                      validLabel: StringConstants.pleaseFillLabel.localized() + StringConstants.titleLabel.localized(),
                      isRequired: true,
                      validator: (email) {
                        if (((email ?? "").trim()).isEmpty) {
                          return StringConstants.pleaseFillLabel.localized() +
                              StringConstants.titleLabel.localized();
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSizes.spacingWide),
                    TextFormField(
                      maxLines: 8,
                      controller: commentController,
                      style: Theme.of(context).textTheme.bodyMedium,
                      decoration: InputDecoration(
                        alignLabelWithHint: true,
                        labelText: StringConstants.commentLabel.localized(),
                        hintText: StringConstants.commentHint.localized(),
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
                          return StringConstants.pleaseFillLabel.localized() +
                              StringConstants.commentLabel.localized();
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 30),
                    AddImageView(addReviewBloc: addReviewBloc),
                    const SizedBox(height: AppSizes.spacingWide),
                    MaterialButton(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          side: BorderSide(width: 2)),
                      elevation: 0.0,
                      height: AppSizes.buttonHeight,
                      minWidth: MediaQuery.of(context).size.width,
                      color: Theme.of(context).colorScheme.onBackground,
                      textColor: MobikulTheme.primaryColor,
                      onPressed: () {
                        _onPressSubmitButton();
                      },
                      child: Text(
                        StringConstants.submitReview.localized().toUpperCase(),
                        style:
                            const TextStyle(fontSize: AppSizes.spacingLarge),
                      ),
                    ),
                    const SizedBox(height: AppSizes.spacingWide),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (isLoading) const Loader()
      ],
    );
  }

  ///method will call on press submit review button
  _onPressSubmitButton() {
    if (_reviewFormKey.currentState!.validate()) {
      if(images.isNotEmpty){
        if ((rating ?? 0) > 0) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return Dialog(
                  child: Container(
                    padding: const EdgeInsets.all(AppSizes.spacingWide),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          height: AppSizes.spacingMedium,
                        ),
                        const Loader(),
                        const SizedBox(
                          height: AppSizes.spacingWide,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2.5,
                          child: Center(
                            child: Text(
                              StringConstants.processWaitingMsg.localized(),
                              softWrap: true,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: AppSizes.spacingMedium,
                        ),
                      ],
                    ),
                  ),
                );
              });
          addReviewBloc?.add(AddReviewFetchEvent(
              productId: int.parse(widget.productId ?? ''),
              rating: rating,
              title: titleController.text,
              comment: commentController.text,
              name: "", attachments: images));
          Future.delayed(const Duration(seconds: 3)).then((value) {
            Navigator.pop(context);
            Navigator.pop(context);
          });
        } else {
          ShowMessage.showNotification(
              StringConstants.warning.localized(),
              StringConstants.pleaseAddRating.localized(),
              Colors.yellow,
              const Icon(Icons.warning_amber));
        }
      }
      else {
        ShowMessage.showNotification(
            StringConstants.warning.localized(),
            StringConstants.addReviewImage.localized(),
            Colors.yellow,
            const Icon(Icons.warning_amber));
      }
    }
  }
}
