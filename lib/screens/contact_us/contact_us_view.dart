import 'package:bagisto_app_demo/screens/account/utils/index.dart';

import 'bloc/contact_us_bloc.dart';
import 'bloc/contact_us_event.dart';
import 'bloc/contact_us_state.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({super.key});

  @override
  _ContactUsPageState createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> with EmailValidator {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _email;
  String? _phone;
  String? _message;
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  ContactUsScreenBloc? contactUsScreenBloc;
  bool isLoading = false;
  @override
  void initState() {
    contactUsScreenBloc = context.read<ContactUsScreenBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text(StringConstants.contactUs.localized()),
          centerTitle: false,
        ),
        body: _contactUsBloc(context),
      ),
    );
  }

  _contactUsBloc(BuildContext context) {
    return BlocConsumer<ContactUsScreenBloc, ContactUsBaseState>(
      listener: (BuildContext context, ContactUsBaseState state) {
        if (state is ContactUsState) {
          isLoading = true;
          if (state.status == ContactUsStatus.fail) {
            ShowMessage.showNotification(StringConstants.failed, state.error,
                Colors.red, const Icon(Icons.cancel_outlined));
          } else if (state.status == ContactUsStatus.success) {
            ShowMessage.showNotification(
                StringConstants.success.localized(),
                state.successMsg ?? StringConstants.updated.localized(),
                Colors.green.shade400,
                const Icon(Icons.check_circle_outline));
            nameController.clear();
            emailController.clear();
            phoneController.clear();
            commentController.clear();
          }
        }
      },
      builder: (BuildContext context, ContactUsBaseState state) {
        return _reviewForm();
      },
    );
  }

  _reviewForm() {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 40),
                  child: Text(StringConstants.contactUsDetail.localized()),
                ),
                CommonWidgets().getTextField(
                  context,
                  nameController,
                  StringConstants.nameLabel.localized(),
                  label: StringConstants.name.localized(),
                  isRequired: true,
                  validator: (name) {
                    if ((name ?? "").isEmpty) {
                      return StringConstants.pleaseFillLabel.localized() +
                          StringConstants.name.localized();
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSizes.spacingWide),
                CommonWidgets().getTextField(
                  context,
                  emailController,
                  StringConstants.enterYourEmail.localized(),
                  label: StringConstants.email.localized(),
                  isRequired: true,
                  validLabel: StringConstants.pleaseFillLabel.localized() +
                      StringConstants.contactUsPhoneLabel.localized(),
                  keyboardType: TextInputType.emailAddress,
                  validator: (email) {
                    if ((email ?? "").isEmpty) {
                      return StringConstants.pleaseFillLabel.localized() +
                          StringConstants.email.localized();
                    } else if (!isValidEmail(email)) {
                      return StringConstants.validEmailLabel.localized();
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSizes.spacingWide),
                CommonWidgets().getTextField(
                  context,
                  phoneController,
                  StringConstants.contactUsPhoneHint.localized(),
                  label: StringConstants.contactUsPhoneLabel.localized(),
                  isRequired: true,
                  validLabel: StringConstants.pleaseFillLabel.localized() +
                      StringConstants.contactUsPhoneLabel.localized(),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if ((value ?? "").isEmpty) {
                      return StringConstants.pleaseFillLabel.localized() +
                          StringConstants.contactUsPhoneLabel.localized();
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSizes.spacingWide),
                TextFormField(
                  maxLines: 4,
                  style: Theme.of(context).textTheme.bodyMedium,
                  controller: commentController,
                  decoration: InputDecoration(
                      label: Text.rich(TextSpan(
                        children: <InlineSpan>[
                          WidgetSpan(
                            child: Text(
                              StringConstants.whatOnYourMind.localized(),
                            ),
                          ),
                          const WidgetSpan(
                            child: Text(
                              '*',
                              style: TextStyle(color: Colors.red, fontSize: 14),
                            ),
                          ),
                        ],
                      )),
                      hintText: StringConstants.describeHere.localized(),
                      isDense: true,
                      errorStyle: const TextStyle(fontSize: 12),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      //   prefixIcon: prefixIcon,
                      prefixIconColor: Theme.of(context).iconTheme.color,
                      hintStyle: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.grey.shade500),
                      labelStyle: Theme.of(context).textTheme.bodyMedium,
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4.0)),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4.0)),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4.0)),
                        borderSide: BorderSide(color: Colors.red.shade300),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4.0)),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      // suffixIcon: suffixIcon,
                      suffixIconColor: Theme.of(context).iconTheme.color),
                  validator: (value) {
                    if ((value ?? "").trim().isEmpty) {
                      return StringConstants.pleaseFillLabel.localized() +
                          StringConstants.commentLabel.localized();
                    }
                    return null; // Returns null if the input is valid
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: AppSizes.spacingMedium,
            horizontal: AppSizes.spacingMedium),
        child: MaterialButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.spacingNormal)),
          elevation: 2.0,
          height: AppSizes.buttonHeight,
          minWidth: MediaQuery.of(context).size.width,
          color: Theme.of(context).colorScheme.onBackground,
          onPressed: () {
            _submitForm();
          },
          child: Text(
            StringConstants.submit.localized().toUpperCase(),
            style: TextStyle(
                fontSize: AppSizes.spacingLarge,
                color: Theme.of(context).colorScheme.secondaryContainer),
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      _name = nameController.text;
      _email = emailController.text;
      _phone = phoneController.text;
      _message = commentController.text;

      contactUsScreenBloc?.add(ContactUsEvent(_name, _email, _phone, _message));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Form submitted successfully!')),
      );
    }
  }
}
