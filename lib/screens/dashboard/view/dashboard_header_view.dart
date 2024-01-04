import 'package:bagisto_app_demo/screens/cart_screen/cart_index.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../utils/index.dart';

class DashboardHeaderView extends StatefulWidget {
  const DashboardHeaderView({Key? key}) : super(key: key);

  @override
  State<DashboardHeaderView> createState() => _DashboardHeaderViewState();
}

class _DashboardHeaderViewState extends State<DashboardHeaderView> {
  String? name;
  String? customerEmail;
  String? image;

  @override
  void initState() {
    SharedPreferenceHelper.getCustomerName().then((value) {
      SharedPreferenceHelper.getCustomerEmail().then((email) {
        SharedPreferenceHelper.getCustomerImage().then((img) {
          setState(() {
            name = value;
            customerEmail = email;
            image = img;
          });
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 3,
      width: MediaQuery.of(context).size.width,
      child: Card(
          elevation: 0,
          margin: EdgeInsets.zero,
          child: Stack(
            children: [
              Image.asset(
                "assets/images/customer_banner_placeholder.png",
                width: MediaQuery.of(context).size.width,
              ),
              Container(
                  height: MediaQuery.of(context).size.height / 3,
                  decoration: const BoxDecoration(
                    color: Color(0x0bd7f77d),
                    shape: BoxShape.rectangle,
                  )),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: MobikulTheme.accentColor,
                                    width: 1.0)),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(100.0),
                                child:CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: image ?? "",
                                  placeholder: (context, url) => Image.asset('assets/images/customer_profile_placeholder.png'),
                                  errorWidget: (context, url, error) => Image.asset('assets/images/customer_profile_placeholder.png'),
                                ))),
                      ],
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: AppSizes.spacingNormal),
                        child: Column(
                          children: [
                            Text(
                              name ?? "",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(
                                      color: Colors.white),
                            ),
                            const SizedBox(
                              height: AppSizes.spacingSmall,
                            ),
                            Text(
                              customerEmail ?? "",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      fontSize: AppSizes.spacingMedium,
                                      color: Colors.white,
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.w400),
                            ),
                            const SizedBox(
                              height: AppSizes.spacingNormal,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed(accountInfo)
                                    .then((value) {
                                  SharedPreferenceHelper.getCustomerName()
                                      .then((value) {
                                    SharedPreferenceHelper.getCustomerEmail()
                                        .then((email) {
                                      SharedPreferenceHelper.getCustomerImage()
                                          .then((img) {
                                        setState(() {
                                          name = value;
                                          customerEmail = email;
                                          image = img;
                                        });
                                      });
                                    });
                                  });
                                });
                              },
                              child: Container(
                                  decoration: const BoxDecoration(
                                      color: Colors.white30,
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(25.0))),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: AppSizes.spacingNormal,
                                      horizontal: AppSizes.spacingMedium,
                                    ),
                                    child: Text(
                                      StringConstants.editInfo.localized().toUpperCase(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium
                                          ?.copyWith(
                                              color: Colors.white),
                                    ),
                                  )),
                            ),
                          ],
                        ))
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
