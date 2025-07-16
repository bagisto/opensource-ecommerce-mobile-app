/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/screens/add_review/utils/index.dart';
import 'package:dio/dio.dart';
export 'dart:convert';
import 'package:http/http.dart' as http;

class AddReview extends StatefulWidget {
  final String? imageUrl;
  final String? productId;
  final String? productName;

  const AddReview({Key? key, this.imageUrl, this.productId, this.productName})
      : super(key: key);

  @override
  State<AddReview> createState() => _AddReviewState();
}

class _AddReviewState extends State<AddReview> {
  final bool _autoValidate = false;
  final _reviewFormKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final commentController = TextEditingController();
  var rating = 0;
  bool isLoading = false;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  AddReviewBloc? addReviewBloc;
  List<http.MultipartFile> images = [];
  List<XFile?>? pickedImages = [];

  @override
  void initState() {
    addReviewBloc = context.read<AddReviewBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text(StringConstants.addaReview.localized()),
          centerTitle: false,
        ),
        body: _addReviewBloc(context),
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
            ShowMessage.showNotification(StringConstants.failed, state.error,
                Colors.red, const Icon(Icons.cancel_outlined));
          } else if (state.status == AddReviewStatus.success) {
            ShowMessage.showNotification(
                StringConstants.success.localized(),
                // state.addReviewModel!.success ?? StringConstants.updated.localized(),
                state.addReviewModel?.message.toString(),
                Colors.green.shade400,
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
      pickedImages = state.pickedFile;
      images.clear();

      for(int i=0; i<(pickedImages ?? []).length; i++){
        var image = pickedImages?[i];
        if (image != null) {
          getMultipartFile(image.path, i);
        }
      }
      return _reviewForm();
    }
    return const SizedBox();
  }

  getMultipartFile(String? image, int index) async {
    final multipartFile = await http.MultipartFile.fromPath(
      "$index",
      image ?? "",
      filename: image?.split('/').last ?? "",
      contentType: DioMediaType('image', 'png'),
    );
    images.add(multipartFile);
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
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    const SizedBox(height: AppSizes.spacingNormal),
                    RatingBar.builder(
                      itemSize: AppSizes.spacingMedium * 2,
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
                      validLabel: StringConstants.pleaseFillLabel.localized() +
                          StringConstants.titleLabel.localized(),
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
                            borderRadius: const BorderRadius.all(
                                Radius.circular(AppSizes.spacingSmall)),
                            borderSide:
                                BorderSide(color: Colors.grey.shade500)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                                Radius.circular(AppSizes.spacingSmall)),
                            borderSide:
                                BorderSide(color: Colors.grey.shade500)),
                        errorBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                                Radius.circular(AppSizes.spacingSmall)),
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
                    const SizedBox(height: AppSizes.spacingMedium * 2),
                    AddImageView(addReviewBloc: addReviewBloc, images: pickedImages),
                    const SizedBox(height: AppSizes.spacingWide),
                    MaterialButton(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(AppSizes.spacingSmall)),
                      ),
                      elevation: 0.0,
                      height: AppSizes.buttonHeight,
                      minWidth: MediaQuery.of(context).size.width,
                      color: Theme.of(context).colorScheme.onBackground,
                      textColor:
                          Theme.of(context).colorScheme.secondaryContainer,
                      onPressed: () {
                        _onPressSubmitButton();
                      },
                      child: Text(
                        StringConstants.submitReview.localized().toUpperCase(),
                        style: TextStyle(
                            fontSize: AppSizes.spacingLarge,
                            color: Theme.of(context)
                                .colorScheme
                                .secondaryContainer),
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
      // if (images.isNotEmpty) {
      if ((rating) > 0) {
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
            name: "",
            attachments: images));
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
      // } else {
      //   ShowMessage.showNotification(
      //       StringConstants.warning.localized(),
      //       StringConstants.addReviewImage.localized(),
      //       Colors.yellow,
      //       const Icon(Icons.warning_amber));
      // }
    }
  }
}
