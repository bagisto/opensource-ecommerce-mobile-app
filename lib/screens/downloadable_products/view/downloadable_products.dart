
import 'package:bagisto_app_demo/common_widget/common_widgets.dart';
import 'package:bagisto_app_demo/helper/application_localization.dart';
import 'package:bagisto_app_demo/screens/downloadable_products/bloc/downloadable_products_bloc.dart';
import 'package:bagisto_app_demo/screens/downloadable_products/state/downlaodable_products_state.dart';
import 'package:bagisto_app_demo/screens/downloadable_products/view/widgets/download_product_item.dart';
import 'package:bagisto_app_demo/screens/downloadable_products/view/widgets/no_downlodable_products.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../common_widget/circular_progress_indicator.dart';
import '../../../common_widget/common_error_msg.dart';
import '../../../common_widget/show_message.dart';
import '../../../configuration/app_global_data.dart';
import '../../../models/downloadable_products/download_product_model.dart';
import '../../../models/downloadable_products/downloadable_product_model.dart';
import '../../../models/homepage_model/new_product_data.dart';
import '../../product_screen/view/file_download.dart';
import '../events/downloadable_products_events.dart';

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
    downloadableProductsBloc?.add(DownloadableProductsCustomerEvent(page, limit));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: CommonWidgets.getHeadingText(
              "DownloadableProductsList".localized(), context),
        ),
        body:  Directionality(
          textDirection: GlobalData.contentDirection(),
          child: _downloadableProductsList() ,
        ),);
  }

  ///Downloadable Product bloc method
  _downloadableProductsList() {
    return BlocConsumer<DownloadableProductsBloc,
        DownloadableProductsBaseState>(
      listener: (BuildContext context, DownloadableProductsBaseState state) {
        if (state is DownloadProductState) {
            downloadLink = state.downloadLink;
            if (downloadLink?.status == true) {
              ShowMessage.showNotification("success".localized(), "downloadSuccess".localized(),Colors.green,const Icon(Icons.check_circle));
            }
            downloadableProductsBloc?.add(DownloadableProductsCustomerEvent(page, limit));
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
      return CircularProgressIndicatorClass.circularProgressIndicator(context);
    }
    if (state is DownloadProductState) {
      downloadLink = state.downloadLink;
      DownloadFile().saveBase64String(downloadLink?.string ?? "", (downloadLink?.download?.name ?? "") + (downloadLink?.download?.fileName ?? "image.jpg"));
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
        return ErrorMessage.errorMsg(state.error ?? "Error");
      }
    }
    return downloadableList();
  }

  Widget downloadableList() {
    if((productsList?.downloadableLinkPurchases ??[]).isNotEmpty){
      return ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: productsList?.downloadableLinkPurchases?.length ?? 0,
          itemBuilder: (context, index) {
            linkPurchases = productsList?.downloadableLinkPurchases?[index];
            int available = (linkPurchases?.downloadBought ??0) - (linkPurchases?.downloadUsed ??0);
            return DownloadProductItem(available: available, downloadableProductsBloc: downloadableProductsBloc,
            linkPurchases: linkPurchases, product: data?[index],);
          });
    }
    else{
      return const NoDownloadableProduct();
    }
  }
}


