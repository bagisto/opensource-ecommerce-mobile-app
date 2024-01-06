import '../cart_index.dart';

class PriceDetailView extends StatelessWidget {
  final CartModel cartDetailsModel;

  const PriceDetailView({Key? key, required this.cartDetailsModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
            initiallyExpanded: true,
            iconColor: Colors.grey,
            title: Text(
              StringConstants.priceDetails.localized(),
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(16, 0, 10, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      StringConstants.subTotal.localized(),
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      cartDetailsModel.formattedPrice?.subTotal.toString() ??
                          "",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              Container(
                      padding: const EdgeInsets.fromLTRB(16, 5, 10, 0),
                      // color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            StringConstants.tax.localized(),
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            cartDetailsModel.formattedPrice?.taxTotal
                                    .toString() ??
                                "",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(16, 5, 10, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            StringConstants.discount.localized(),
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            cartDetailsModel.formattedPrice?.discount
                                    .toString() ??
                                "",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                  ),
              Container(
                padding: const EdgeInsets.fromLTRB(16, 5, 10, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(StringConstants.grandTotal.localized(),
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                      cartDetailsModel.formattedPrice?.grandTotal.toString() ??
                          "",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: AppSizes.spacingMedium,
              ),
            ]),
      ),
    );
  }
}
