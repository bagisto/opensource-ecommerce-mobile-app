import 'package:bagisto_app_demo/screens/home_page/data_model/theme_customization.dart';
import '../utils/index.dart';

class FooterColumnsScreen extends StatefulWidget {
  final Options? options;
  final String? title;
  final HomePageBloc? homePageBloc;
  const FooterColumnsScreen(this.options,
      {super.key, this.title, this.homePageBloc});

  @override
  State<FooterColumnsScreen> createState() => _FooterColumnsScreenState();
}

class _FooterColumnsScreenState extends State<FooterColumnsScreen>
    with EmailValidator {
  final emailController = TextEditingController();
  final _signUpFormKey = GlobalKey<FormState>();

  Widget buildColumn(List<ColumnModel>? items, BuildContext context) {
    if (items == null || items.isEmpty) return const SizedBox();

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items.map((item) {
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, commonWebView, arguments: item);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: Text(
                item.title ?? '',
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text("Get Ready for our Fun Newsletter!"),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text("Subscribe to stay in touch"),
        ),
        SizedBox(height: 12),
        Form(
          key: _signUpFormKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: CommonWidgets().getTextField(
                    context,
                    emailController,
                    StringConstants.signInEmailHint.localized(),
                    label: StringConstants.signInEmailLabel.localized(),
                    isRequired: true,
                    validator: (email) {
                      if (email!.isEmpty) {
                        return StringConstants.pleaseFillLabel.localized() +
                            StringConstants.signInEmailLabel.localized();
                      } else if (!isValidEmail(email)) {
                        return StringConstants.enterValidEmail.localized();
                      }
                      return null;
                    },
                    validLabel: StringConstants.validEmailLabel.localized(),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  height: 51, // Matches the height of the text field
                  child: MaterialButton(
                    elevation: 0.0,
                    color: Theme.of(context).colorScheme.onBackground,
                    textColor: Theme.of(context).colorScheme.secondaryContainer,
                    onPressed: () {
                      if (_signUpFormKey.currentState?.validate() == true) {
                        widget.homePageBloc?.add(
                            SubscribeNewsLetterEvent(emailController.text));
                        emailController.clear();
                      }
                    },
                    child: Text(
                      StringConstants.subscribe.localized().toUpperCase(),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color:
                              Theme.of(context).colorScheme.secondaryContainer),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            showTrailingIcon: true,
            collapsedIconColor: Theme.of(context).iconTheme.color,
            iconColor: Theme.of(context).iconTheme.color,
            title: Text(widget.title ?? ""),
            childrenPadding: EdgeInsets.symmetric(horizontal: 16),
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildColumn(widget.options?.column1, context),
                  const SizedBox(width: 16),
                  buildColumn(widget.options?.column2, context),
                  const SizedBox(width: 16),
                  buildColumn(widget.options?.column3, context),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
