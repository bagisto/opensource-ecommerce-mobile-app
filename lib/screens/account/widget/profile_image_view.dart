import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:bagisto_app_demo/screens/cart_screen/cart_index.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../utils/index.dart';

//ignore: must_be_immutable
class ProfileImageView extends StatefulWidget {
  Function(String? base64string)? callback;

  ProfileImageView({Key? key, this.callback}) : super(key: key);

  @override
  State<ProfileImageView> createState() => _ProfileImageViewState();
}

class _ProfileImageViewState extends State<ProfileImageView> {
  String profileImageEdit = "";
  String? base64string;
  XFile? image;
  XFile selectedImage = XFile("");

  @override
  void initState() {
    image = null;
    SharedPreferenceHelper.getCustomerImage().then((value) {
      setState(() {
        profileImageEdit = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey),
          color: MobikulTheme.accentColor),
      child: Stack(
        alignment: AlignmentDirectional.bottomEnd,
        children: [
          GestureDetector(
              onTap: () {
                _showChoiceBottomSheet(context);
              },
              child: CircleAvatar(
                radius: MediaQuery.of(context).size.width * 0.13,
                backgroundImage: const AssetImage(
                    'assets/images/customer_profile_placeholder.png'),
                backgroundColor: Colors.white,
                foregroundImage: (image != null)
                    ? FileImage(File(image!.path))
                    : (profileImageEdit.isNotEmpty)
                        ? NetworkImage('$profileImageEdit?${DateTime.now().millisecondsSinceEpoch.toString()}')
                        : Image.asset(
                                'assets/images/customer_profile_placeholder.png')
                            .image,
              )),
          GestureDetector(
            onTap: () {
              _showChoiceBottomSheet(context);
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18.0),
                color: MobikulTheme.accentColor,
              ),
              child: Icon(
                Icons.camera_alt,
                size: 18,
                color: MobikulTheme.primaryColor,
              ),
            ),
          )
        ],
      ),
    );
  }

  void _showChoiceBottomSheet(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: Theme.of(context).cardColor,
        context: context,
        builder: (context) {
          return Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 17, 0, 10),
                child: Text(
                  StringConstants.chooseOption.localized(),
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.onPrimary),
                ),
              ),
              const Divider(
                thickness: 1,
              ),
              ListTile(
                leading: Icon(
                  Icons.folder,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                title: Text(StringConstants.gallery.localized(),
                    style: Theme.of(context).textTheme.bodyMedium),
                onTap: () {
                  _openGallery(context);
                },
              ),
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
                  _openCamera(context);
                },
              )
            ],
          );
        });
    //Navigator.pop(context);
  }

  void _openCamera(BuildContext context) async {
    await ImagePicker()
        .pickImage(
      source: ImageSource.camera,
    )
        .then((value) async {
      selectedImage = XFile(value?.path ?? "");
      Uint8List imageBytes =
          await selectedImage.readAsBytes(); //convert to bytes
      base64string = base64.encode(imageBytes);
      widget.callback!(base64string);
      setState(() {
        image = value;
      });
    });
    Navigator.pop(context);
  }

  void _openGallery(BuildContext context) async {
    await ImagePicker()
        .pickImage(
      source: ImageSource.gallery,
    )
        .then((value) async {
      selectedImage = XFile(value?.path ?? "");
      Uint8List imageBytes =
          await selectedImage.readAsBytes(); //convert to bytes
      base64string = base64.encode(imageBytes);
      widget.callback!(base64string);
      setState(() {
        image = value;
      });
    });
    Navigator.pop(context);
  }
}
