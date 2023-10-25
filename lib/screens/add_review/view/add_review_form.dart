/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables

import 'dart:io';

import 'package:bagisto_app_demo/helper/application_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';

import '../../../Configuration/mobikul_theme.dart';
import '../../../common_widget/common_widgets.dart';
import '../../../common_widget/image_view.dart';
import '../../../common_widget/loader.dart';
import '../../../helper/string_constants.dart';
import '../bloc/add_review_bloc.dart';
import '../event/image_picker_event.dart';

class AddReviewForm extends StatefulWidget {
  String? imageUrl;
  String? productName;
  VoidCallback? reload;

  AddReviewForm({this.imageUrl, this.productName, this.reload, Key? key})
      : super(key: key);

  @override
  State<AddReviewForm> createState() => _AddReviewFormState();
}

class _AddReviewFormState extends State<AddReviewForm> {
  final _reviewFormKey = GlobalKey<FormState>();
  final bool _autoValidate = false;
  final titleController = TextEditingController();
  final commentController = TextEditingController();
  var rating;
  bool isLoading = false;
  XFile? imageFile;
  AddReviewBloc? addReviewBloc;

  @override
  void initState() {
    addReviewBloc = context.read<AddReviewBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SafeArea(
          child: SingleChildScrollView(
            child: Container(
              // color: Colors.white,
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
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
                          fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    CommonWidgets().getTextFieldHeight(NormalHeight),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "rating".localized(),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    RatingBar.builder(
                      // glowColor: Colors.green,
                      unratedColor: MobikulTheme.appBarBackgroundColor,
                      itemSize: 30,
                      initialRating: num.tryParse('0.0')?.toDouble() ?? 0.0,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (updatedRating) {
                        rating = updatedRating;
                        debugPrint(rating.toString());
                      },
                    ),
                    CommonWidgets().getTextFieldHeight(20.0),
                    CommonWidgets().getTextField(
                      context,
                      titleController,
                      "titleLabel".localized(),
                      "titleHint".localized(),
                      "PleaseFillLabel".localized() + "titleLabel".localized(),
                      validator: (email) {
                        if (email!.isEmpty) {
                          return "PleaseFillLabel".localized() +
                              "titleLabel".localized();
                        }
                        return null;
                      },
                    ),
                    CommonWidgets().getTextFieldHeight(20.0),
                    TextFormField(
                      maxLines: 8,
                      controller: commentController,
                      style: Theme.of(context).textTheme.bodyMedium,
                      decoration: InputDecoration(
                        labelText: "commentLabel".localized(),
                        hintText: "commentHint".localized(),
                        labelStyle: Theme.of(context).textTheme.titleLarge,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(Radius.zero),
                            borderSide:
                                BorderSide(color: Colors.grey.shade500)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(Radius.zero),
                            borderSide:
                                BorderSide(color: Colors.grey.shade500)),
                        errorBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(Radius.zero),
                            borderSide: BorderSide(color: Colors.red.shade500)),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(Radius.zero),
                          borderSide: BorderSide(color: Colors.grey.shade500),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "PleaseFillLabel".localized() +
                              "commentLabel".localized();
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    CommonWidgets().getTextFieldHeight(30.0),
                    Card(
                      child: (imageFile == null)
                          ? Container()
                          : Stack(
                              children: [
                                SizedBox(
                                  height: 200,
                                  width: 200,
                                  child: Image.file(File(imageFile!.path)),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      imageFile = null;
                                    });
                                  },
                                  icon: const Icon(Icons.cancel_outlined),
                                ),
                              ],
                            ),
                    ),
                    imageFile == null
                        ? Container()
                        : CommonWidgets().getTextFieldHeight(30.0),
                    MaterialButton(
                      elevation: 0.0,
                      height: 48,
                      minWidth: MediaQuery.of(context).size.width,
                      color: Theme.of(context).colorScheme.background,
                      textColor: Theme.of(context).colorScheme.primaryContainer,
                      onPressed: () {
                        _onPressAddImage(context);
                      },
                      child: Text(
                        imageFile == null
                            ? "addImage".localized().toUpperCase()
                            : "replaceImage".localized().toUpperCase(),
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ),
                    CommonWidgets().getTextFieldHeight(30.0),
                    MaterialButton(
                      elevation: 0.0,
                      height: 48,
                      minWidth: MediaQuery.of(context).size.width,
                      color: Theme.of(context).colorScheme.background,
                      textColor: Theme.of(context).colorScheme.primaryContainer,
                      onPressed: () {
                        if (widget.reload != null) {
                          widget.reload!();
                        }
                        // _onPressSubmitButton();
                      },
                      child: Text(
                        "submitReview".localized().toUpperCase(),
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ),
                    CommonWidgets().getTextFieldHeight(20.0),
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

  Future<void> _onPressAddImage(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            title: Text(
              "PleaseChoose"
                  .localized(), /*style: TextStyle(color: MobikulTheme.accentColor),*/
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  CommonWidgets().divider(),
                  ListTile(
                    onTap: () {
                      _openGallery();
                    },
                    title: CommonWidgets()
                        .getDrawerTileText("Gallery".localized(), context),
                    /*Text(ApplicationLocalizations.of(context)!
                    .translate("Gallery")),*/
                    leading: Icon(
                      Icons.account_box,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  CommonWidgets().divider(),
                  ListTile(
                    onTap: () {
                      _openCamera();
                    },
                    title: CommonWidgets().getDrawerTileText(
                        "Camera".localized(),
                        context) /*Text(ApplicationLocalizations.of(context)!
                    .translate("Camera"))*/
                    ,
                    leading: Icon(
                      Icons.camera,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _openGallery() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    addReviewBloc?.add(ImagePickerEvent(pickedFile: pickedFile));
    imageFile = pickedFile;

    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  void _openCamera() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    addReviewBloc?.add(ImagePickerEvent(pickedFile: pickedFile));
    imageFile = pickedFile;
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }
}
