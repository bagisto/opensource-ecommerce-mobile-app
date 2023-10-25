// ignore_for_file: file_names, must_be_immutable


import 'package:bagisto_app_demo/common_widget/common_widgets.dart';
import 'package:bagisto_app_demo/models/cms_model/cms_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '../../../configuration/app_global_data.dart';
import '../../../configuration/app_sizes.dart';
import '../../../common_widget/circular_progress_indicator.dart';
import '../../../common_widget/common_error_msg.dart';
import '../bloc/cms_bloc.dart';
import '../event/fetch_cms_data_event.dart';
import '../state/cms_base_state.dart';
import '../state/cms_initial_state.dart';
import '../state/fetch_cms_data_state.dart';
import 'package:collection/collection.dart';

class CmsContent extends StatefulWidget {
String? title;
int?index;
int? id;
CmsContent({Key? key, this.title, this.id,this.index}) : super(key: key);
@override
  State<CmsContent> createState() => _CmsContentState();
}

class _CmsContentState extends State<CmsContent> {
  @override
  void initState() {
    CmsBloc cmsBloc = context.read<CmsBloc>();
    cmsBloc.add(FetchCmsDataEvent(widget.id.toString()));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: GlobalData.contentDirection(),
        child: Scaffold(
        appBar: AppBar(
          title: CommonWidgets.getHeadingText(
            widget.title ?? "",context),
         centerTitle: false,
        ),
        body:  _setCmsContent( context),
        ));
  }

  ///cms bloc method
  _setCmsContent(BuildContext context) {

    return BlocConsumer<CmsBloc, CmsBaseState>(
      listener: (BuildContext context, CmsBaseState state) {},
      builder: (BuildContext context, CmsBaseState state) {
        return buildContainer(context, state);
      },
    );
  }

  ///build container method
  Widget buildContainer(BuildContext context, CmsBaseState state) {
    if (state is CmsInitialState) {
      return   CircularProgressIndicatorClass.circularProgressIndicator(context);
    }
    if (state is FetchCmsDataState) {
      if (state.status == CmsStatus.success) {
        return _cmsContent(state.cmsData!);
      }
      if (state.status == CmsStatus.fail) {
        return ErrorMessage.errorMsg(state.error??"Error");
      }
    }
    return Container();
  }

  ///method which contain cms data
  _cmsContent(CmsData cmsData) {
    var title=  cmsData.data?[widget.index??0].translations?.firstWhereOrNull((e) => e.locale==GlobalData.locale);

    return Padding(
      padding: const EdgeInsets.all(AppSizes.normalPadding),
      child: HtmlWidget( title?.pageTitle ??"",
      ),
    );
  }
}
