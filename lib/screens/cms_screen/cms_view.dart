/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/screens/cms_screen/utils/index.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? ""),
        centerTitle: false,
      ),
      body: _setCmsContent(context),
    );
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
          baseColor: Theme.of(context).colorScheme.secondaryContainer,
          builder: Container(
            height: MediaQuery.of(context).size.height,
            color: Theme.of(context).colorScheme.secondaryContainer,
          ),
        ),
      );
    }
    if (state is FetchCmsDataState) {
      if (state.status == CmsStatus.success) {
        return _cmsContent(state.cmsData);
      }
      if (state.status == CmsStatus.fail) {
        return EmptyDataView();
      }
    }
    return const SizedBox();
  }

  _cmsContent(CmsPage? cmsData) {
    var title = cmsData?.translations
        ?.firstWhereOrNull((e) => e.locale == GlobalData.locale);

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(AppSizes.spacingNormal),
            child: HtmlWidget(
              title?.htmlContent ?? "",
            )),
      ),
    );
  }
}
