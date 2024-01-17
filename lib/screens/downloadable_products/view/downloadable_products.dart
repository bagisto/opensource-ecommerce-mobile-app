import 'package:bagisto_app_demo/screens/account/view/account_screen.dart';
import 'package:bagisto_app_demo/screens/downloadable_products/bloc/downloadable_products_bloc.dart';
import 'package:bagisto_app_demo/screens/downloadable_products/bloc/downlaodable_products_state.dart';
import 'package:bagisto_app_demo/screens/downloadable_products/view/widgets/download_product_item.dart';
import 'package:bagisto_app_demo/utils/application_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeleton_loader/skeleton_loader.dart';
import '../../../utils/app_global_data.dart';
import '../../../utils/assets_constants.dart';
import '../../../utils/string_constants.dart';
import '../../../widgets/common_error_msg.dart';
import '../../../widgets/empty_data_view.dart';
import '../../../widgets/show_message.dart';
import '../../home_page/data_model/new_product_data.dart';
import '../../product_screen/view/file_download.dart';
import '../bloc/downloadable_products_events.dart';
import '../data_model/download_product_model.dart';
import '../data_model/downloadable_product_model.dart';

class DownLoadableScreen extends StatefulWidget {
  const DownLoadableScreen({Key? key}) : super(key: key);

  @override
  State<DownLoadableScreen> createState() => _DownLoadableScreenState();
}

class _DownLoadableScreenState extends State<DownLoadableScreen> {
  List<NewProducts>? data;
  int page = 1;
  int limit = 10;
  DownloadLink? downloadLink;
  DownloadableProductModel? productsList;
  DownloadableLinkPurchases? linkPurchases;
  DownloadableProductsBloc? downloadableProductsBloc;

  @override
  void initState() {
    downloadableProductsBloc = context.read<DownloadableProductsBloc>();
    downloadableProductsBloc
        ?.add(DownloadableProductsCustomerEvent(page, limit));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: GlobalData.contentDirection(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text(StringConstants.downloadableProductsList.localized()),
        ),
        body: _downloadableProductsList(),
      ),
    );
  }

  ///Downloadable Product bloc method
  _downloadableProductsList() {
    return BlocConsumer<DownloadableProductsBloc,
        DownloadableProductsBaseState>(
      listener: (BuildContext context, DownloadableProductsBaseState state) {
        if (state is DownloadProductState) {
          downloadLink = state.downloadLink;
          if (downloadLink?.status == true) {
            ShowMessage.showNotification(StringConstants.downloadSuccess.localized(), "",
                Colors.green, const Icon(Icons.check_circle));
          }
          downloadableProductsBloc
              ?.add(DownloadableProductsCustomerEvent(page, limit));
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
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 8, 8, 8),
          child: SkeletonLoader(
            items: 6,
            builder: Card(
              child: Container(
                height: 125,
              ),
            ),
          ),
        ),
      );
    }
    if (state is DownloadProductState) {
      downloadLink = state.downloadLink;
      DownloadFile().downloadPersonalData(
          downloadLink?.download?.url ?? "",
          (downloadLink?.download?.name ?? "product"),
              downloadLink?.download?.type ?? "", context, scaffoldMessengerKey);
    }
    if (state is DownloadableProductsCustomerDataState) {
      productsList = state.productsList;
    }
    if (state is DownloadableProductsDataState) {
      if (state.status == DownloadableProductsStatus.success) {
        data = state.productsModel?.data;
        return downloadableList();
      }
      if (state.status == DownloadableProductsStatus.fail) {
        return ErrorMessage.errorMsg(state.error ?? StringConstants.error);
      }
    }
    return downloadableList();
  }

  Widget downloadableList() {
    if ((productsList?.downloadableLinkPurchases ?? []).isNotEmpty) {
      return ListView.builder(
          scrollDirection: Axis.vertical,
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
          });
    } else {
      return EmptyDataView(
          assetPath: AssetConstants.emptyCart,
          message: StringConstants.noProducts,
          width: MediaQuery.of(context).size.width / 1.5,
          height: MediaQuery.of(context).size.width / 2);
    }
  }
}
