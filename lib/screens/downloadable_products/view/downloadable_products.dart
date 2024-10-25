/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/screens/categories_screen/utils/index.dart';
import 'package:bagisto_app_demo/screens/downloadable_products/utils/index.dart';

import '../data_model/download_product_Image_model.dart';
import 'widgets/downloadable_order_filter.dart';

class DownLoadableScreen extends StatefulWidget {
  const DownLoadableScreen({Key? key}) : super(key: key);

  @override
  State<DownLoadableScreen> createState() => _DownLoadableScreenState();
}

class _DownLoadableScreenState extends State<DownLoadableScreen> {
  List<NewProducts>? data;
  int page = 1;
  int limit = 10;
  Download? downloadLink;
  DownloadLinkDataModel? downloadBaseLinkData;
  bool isLoading = false;
  DownloadableProductModel? productsList;
  DownloadableLinkPurchases? linkPurchases;
  DownloadableProductsBloc? downloadableProductsBloc;
  DownloadableFiltersInput? appliedFilters;
  ScrollController scrollController =  ScrollController();

  @override
  void initState() {
    downloadableProductsBloc = context.read<DownloadableProductsBloc>();
    downloadableProductsBloc
        ?.add(DownloadableProductsCustomerEvent(page, limit));
    scrollController.addListener(() => _setItemScrollListener());
    super.initState();
  }

  _setItemScrollListener() {
    if (scrollController.hasClients &&
        scrollController.position.maxScrollExtent ==
            scrollController.offset) {
      if (hasMoreData()) {
        page += 1;
        downloadableProductsBloc?.add(DownloadableProductsCustomerEvent(
            page, limit,
            status: appliedFilters?.status?.toUpperCase(),
            title: appliedFilters?.title, orderDateTo: appliedFilters?.orderDateTo,
            orderDateFrom: appliedFilters?.orderDateFrom,
            orderId: appliedFilters?.orderId));
      }
    }
  }

  hasMoreData() {
    var total = productsList?.paginatorInfo?.total ?? 0;
    return (total > (productsList?.downloadableLinkPurchases?.length ?? 0) && !isLoading);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(StringConstants.downloadableProductsList.localized()),
        actions: [
          IconButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) => DownloadableOrderFilters(appliedFilters: appliedFilters)).then((value){
                  if(value != null){
                    appliedFilters = value as DownloadableFiltersInput?;
                    page = 1;
                    downloadableProductsBloc?.add(DownloadableProductsCustomerEvent(
                        page, limit,
                        status: appliedFilters?.status?.toUpperCase(),
                        title: appliedFilters?.title, orderDateTo: appliedFilters?.orderDateTo,
                        orderDateFrom: appliedFilters?.orderDateFrom,
                        orderId: appliedFilters?.orderId));
                  }
                  else {
                    appliedFilters = null;
                    page = 1;
                    downloadableProductsBloc?.add(DownloadableProductsCustomerEvent(page, limit));
                  }
                });
              },
              icon: const Icon(
                Icons.filter_alt,
                size: AppSizes.spacingLarge*2,
              ))
        ],
      ),
      body: _downloadableProductsList(),
    );
  }

  ///Downloadable Product bloc method
  _downloadableProductsList() {
    return BlocConsumer<DownloadableProductsBloc,
        DownloadableProductsBaseState>(
      listener: (BuildContext context, DownloadableProductsBaseState state) {
        if (state is DownloadProductState) {
          downloadLink = state.downloadLink;
          if (downloadLink?.status == true) {}
          downloadableProductsBloc
              ?.add(DownloadableProductsCustomerEvent(page, limit));
        }
        if (state is DownloadBase64ProductState) {
          isLoading = false;
          downloadBaseLinkData = state.downloadLinkProduct;
          if(state.status == DownloadableProductsStatus.success) {
            DownloadFile().saveBase64String(downloadBaseLinkData?.string ??'',
                downloadBaseLinkData?.download?.fileName??'');
          }
          else{
            ShowMessage.errorNotification(
                state.error ?? downloadBaseLinkData?.graphqlErrors ?? "", context);
          }
        }
      },
      builder: (BuildContext context, DownloadableProductsBaseState state) {
        return _downloadableProductsItems(state);
      },
    );
  }

  ///build container method
  Widget _downloadableProductsItems(DownloadableProductsBaseState state) {
    if (state is DownloadableProductsInitialState) {
      return const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(AppSizes.spacingNormal),
          child: SkeletonLoader(
            items: 6,
            builder: Card(
              child: SizedBox(
                height: 125,
              ),
            ),
          ),
        ),
      );
    }
    if(state is ShowLoaderState){
      isLoading = true;
    }
    if (state is DownloadProductState) {
      downloadLink = state.downloadLink;
      downloadableProductsBloc?.add(DownloadBase64ProductEvent(int.parse(downloadLink?.id.toString() ?? "0")));
    }
    if (state is DownloadableProductsCustomerDataState) {
      if (page > 1) {
        productsList?.downloadableLinkPurchases?.addAll(state.productsList?.downloadableLinkPurchases ?? []);
        productsList?.paginatorInfo = state.productsList?.paginatorInfo;
      } else {
        productsList = state.productsList;
        isLoading = false;
      }
    }

    return downloadableList();
  }

  Widget downloadableList() {
    if ((productsList?.downloadableLinkPurchases ?? []).isNotEmpty) {
      return Stack(
        children: [
          ListView.builder(
              scrollDirection: Axis.vertical,
              controller: scrollController,
              shrinkWrap: true,
              itemCount: productsList?.downloadableLinkPurchases?.length ?? 0,
              itemBuilder: (context, index) {
                linkPurchases = productsList?.downloadableLinkPurchases?[index];
                int available = (linkPurchases?.downloadBought ?? 0) -
                    (linkPurchases?.downloadUsed ?? 0);
                return DownloadProductItem(
                  available: available,
                  downloadableProductsBloc: downloadableProductsBloc,
                  linkPurchases: linkPurchases,
                  product: data?[index],
                );
              }),
          Visibility(
              visible: isLoading,
              child: const Loader())
        ],
      );
    } else {
      return EmptyDataView(
          assetPath: AssetConstants.emptyCart,
          message: StringConstants.noProducts,
          width: MediaQuery.of(context).size.width / 1.5,
          height: MediaQuery.of(context).size.width / 2);
    }
  }
}
