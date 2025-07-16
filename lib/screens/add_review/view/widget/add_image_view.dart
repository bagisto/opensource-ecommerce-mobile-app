/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:bagisto_app_demo/utils/application_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/string_constants.dart';
import '../../../../widgets/common_widgets.dart';
import '../../bloc/add_review_event.dart';
import '../../bloc/add_review_bloc.dart';
import 'package:http/http.dart' as http;

class AddImageView extends StatefulWidget {
  final AddReviewBloc? addReviewBloc;
  final List<XFile?>? images;

  AddImageView({
    Key? key,
    this.addReviewBloc,
    required this.images
  }) : super(key: key);

  @override
  State<AddImageView> createState() => _AddImageViewState();
}

class _AddImageViewState extends State<AddImageView> {
  XFile? imageFile;
  String? base64string;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          children: [
            ...?widget.images?.map((image) => Stack(
              children: [
                SizedBox(
                  height: 100,
                  width: 100,
                  child: Image.file(File(image?.path ?? "")),
                ),
                IconButton(
                  onPressed: () {
                    widget.addReviewBloc?.add(ImagePickerEvent(isDelete: true,
                      deleteImage: image
                    ));
                  },
                  icon: const Icon(Icons.cancel_outlined),
                ),
              ],
            ))
          ],
        ),
        if (imageFile != null) const SizedBox(height: AppSizes.spacingWide),
        SizedBox(
          height: AppSizes.buttonHeight,
          width: MediaQuery.of(context).size.width,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
                side: BorderSide(
                    color: Theme.of(context).colorScheme.onBackground)),
            child: Text(StringConstants.addImage.localized().toUpperCase(),
              style: TextStyle(
                  fontSize: AppSizes.spacingLarge,
                  color: Theme.of(context).colorScheme.onBackground),
            ),
            onPressed: () {
              _onPressAddImage(context);
            },
          ),
        ),
      ],
    );
  }

  Future<void> _onPressAddImage(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.background,
            title: Text(
              StringConstants.pleaseChoose.localized(),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  CommonWidgets().divider(),
                  ListTile(
                    onTap: () {
                      _openGallery();
                    },
                    title: CommonWidgets().getDrawerTileText(
                        StringConstants.gallery.localized(), context),
                    leading: Icon(
                      Icons.account_box,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  CommonWidgets().divider(),
                  ListTile(
                    leading: Icon(
                      Icons.camera,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    title: Text(
                      StringConstants.camera.localized(),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    onTap: () {
                      _openCamera();
                    },
                  )
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
    imageFile = pickedFile;
    if (imageFile != null) {
      Uint8List imageBytes = await imageFile!.readAsBytes(); //convert to bytes
      base64string = base64.encode(imageBytes);
      widget.addReviewBloc
          ?.add(ImagePickerEvent(pickedFile: pickedFile));
    }

    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  void _openCamera() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    imageFile = pickedFile;
    if (imageFile != null) {
      Uint8List imageBytes = await imageFile!.readAsBytes(); //convert to bytes
      base64string = base64.encode(imageBytes);
      widget.addReviewBloc
          ?.add(ImagePickerEvent(pickedFile: pickedFile));
    }

    if (!mounted) return;
    Navigator.pop(context);
  }
}
