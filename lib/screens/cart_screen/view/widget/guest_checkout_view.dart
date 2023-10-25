import '../cart_index.dart';
class GuestCheckoutView extends StatelessWidget {
  final CartModel  cartDetailsModel;
  final CartScreenBloc ? cartScreenBloc;

  const GuestCheckoutView({Key? key, required this.cartDetailsModel, required this.cartScreenBloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: AppSizes.extraPadding,),
          Text("CheckoutAs".localized().toUpperCase(),style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Theme.of(context).colorScheme.onPrimary),),
          const SizedBox(height: AppSizes.mediumPadding,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 80,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 12),
                  child: MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      elevation: AppSizes.elevation,
                      height: AppSizes.buttonHeight,
                      minWidth: MediaQuery.of(context).size.width/2.3,
                      color: Theme.of(context).colorScheme.background,
                      textColor: Theme.of(context).colorScheme.onBackground,
                      onPressed: () {
                        Navigator.pushNamed(context, SignUp, arguments: false);
                      },
                      child: Text(
                        "SignUpTitle".localized().toUpperCase(),
                        style: const TextStyle(
                            fontSize: AppSizes.normalFontSize,
                            color: Colors.white),
                      )),
                ),
              ),
              SizedBox(
                height: 80,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 12),
                  child: MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      elevation: AppSizes.elevation,
                      height: AppSizes.buttonHeight,
                      minWidth: MediaQuery.of(context).size.width/2.3,
                      color: Theme.of(context).colorScheme.background,
                      textColor: Theme.of(context).colorScheme.onBackground,
                      onPressed: () {
                        Navigator.of(context).pushNamed(SignIn);
                      },
                      child: Text(
                        "SignInLabel".localized().toUpperCase(),
                        style: const TextStyle(
                            fontSize: AppSizes.normalFontSize,
                            color: Colors.white),
                      )),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 80,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 12),
              child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                  elevation: AppSizes.elevation,
                  height: AppSizes.buttonHeight,
                  minWidth: MediaQuery.of(context).size.width/1,
                  color: Theme.of(context).colorScheme.background,
                  textColor: Theme.of(context).colorScheme.onBackground,
                  onPressed: () {
                    Navigator.pushNamed(context, Checkout,
                        arguments:CartNavigationData(total:cartDetailsModel.formattedPrice?.grandTotal.toString() ?? "233",
                            cartDetailsModel: cartDetailsModel,
                            cartScreenBloc: cartScreenBloc, isDownloadable: checkDownloadable(cartDetailsModel.items)));
                  },
                  child: Text(
                    "GuestCheckoutLabel".localized().toUpperCase(),
                    style: const TextStyle(
                        fontSize: AppSizes.normalFontSize,
                        color: Colors.white),
                  )),
            ),
          ),
        ],
      );
  }
  bool checkDownloadable(List<Items>? items) {
    for(Items product in (items ?? [])){
      if(product.type?.toLowerCase() != "downloadable".toLowerCase()){
        return false;
      }
    }
    return true;
  }
}
