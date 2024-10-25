/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/screens/dashboard/utils/index.dart';

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
    name = appStoragePref.getCustomerName();
    customerEmail = appStoragePref.getCustomerEmail();
    image = appStoragePref.getCustomerImage();
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
                AssetConstants.customerBannerPlaceholder,
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
                            height: AppSizes.spacingWide * 4,
                            width: AppSizes.spacingWide * 4,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: MobiKulTheme.accentColor,
                                    width: 1.0)),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    AppSizes.spacingWide * 5),
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: image ?? "",
                                  placeholder: (context, url) => Image.asset(
                                      AssetConstants
                                          .customerProfilePlaceholder),
                                  errorWidget: (context, url, error) =>
                                      Image.asset(AssetConstants
                                          .customerProfilePlaceholder),
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
                                  ?.copyWith(color: Colors.white),
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
                                    setState(() {
                                      name = appStoragePref.getCustomerName();
                                      customerEmail = appStoragePref.getCustomerEmail();
                                      image = appStoragePref.getCustomerImage();
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
                                      StringConstants.editInfo
                                          .localized()
                                          .toUpperCase(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium
                                          ?.copyWith(color: Colors.white),
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
