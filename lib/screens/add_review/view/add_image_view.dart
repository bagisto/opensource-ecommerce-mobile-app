import 'add_review_index.dart';

class AddImageView extends StatefulWidget {
  final AddReviewBloc? addReviewBloc;

  const AddImageView({
    Key? key,
    this.addReviewBloc,
  }) : super(key: key);

  @override
  State<AddImageView> createState() => _AddImageViewState();
}

class _AddImageViewState extends State<AddImageView> {
  XFile? imageFile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          child: (imageFile == null)
              ? Container()
              : Stack(
                  children: [
                    SizedBox(
                      height: 200,
                      width: 200,
                      child: Image.file(File(imageFile?.path ?? "")),
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
        if (imageFile != null) CommonWidgets().getTextFieldHeight(20.0),
        SizedBox(
          height: AppSizes.buttonHeight,
          width: MediaQuery.of(context).size.width,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
                side:
                    BorderSide(color: Theme.of(context).colorScheme.onPrimary)),
            child: Text(
              imageFile == null
                  ? "addImage".localized().toUpperCase()
                  : "replaceImage".localized().toUpperCase(),
              style: TextStyle(
                fontSize: AppSizes.normalFontSize,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
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
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            title: Text(
              "PleaseChoose".localized(),
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
                      "Camera".localized(),
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
    widget.addReviewBloc?.add(ImagePickerEvent(pickedFile: pickedFile));
    imageFile = pickedFile;
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  void _openCamera() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    widget.addReviewBloc?.add(ImagePickerEvent(pickedFile: pickedFile));
    imageFile = pickedFile;
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }
}
