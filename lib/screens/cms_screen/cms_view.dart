import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:skeleton_loader/skeleton_loader.dart';
import '../../utils/app_global_data.dart';
import '../../utils/app_constants.dart';
import '../../widgets/common_error_msg.dart';
import 'bloc/cms_bloc.dart';
import 'bloc/cms_event.dart';
import 'bloc/cms_state.dart';
import 'data_model/cms_details.dart';
import 'package:collection/collection.dart';

class CmsContent extends StatefulWidget {
  final String? title;
  final int? index;
  final int? id;
  const CmsContent({Key? key, this.title, this.id, this.index})
      : super(key: key);
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
            title: Text(widget.title ?? "",style: Theme.of(context).textTheme.titleLarge),
            centerTitle: false,
          ),
          body: _setCmsContent(context),
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
      return SingleChildScrollView(
        child: SkeletonLoader(
          highlightColor: Theme.of(context).highlightColor,
          baseColor: Theme.of(context).colorScheme.primary,
          builder: Container(
            height: MediaQuery.of(context).size.height,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      );
    }
    if (state is FetchCmsDataState) {
      if (state.status == CmsStatus.success) {
        return _cmsContent(state.cmsData);
      }
      if (state.status == CmsStatus.fail) {
        return ErrorMessage.errorMsg(state.error ?? "Error");
      }
    }
    return const SizedBox();
  }

  _cmsContent(CmsPage? cmsData) {
    var title = cmsData?.translations
        ?.firstWhereOrNull((e) => e.locale == GlobalData.locale);

    return SingleChildScrollView(
      child: Padding(
          padding: const EdgeInsets.all(AppSizes.spacingNormal),
          child: HtmlWidget(
            title?.htmlContent ?? "",
          )),
    );
  }
}
