/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/screens/search_screen/view/widget/product_list.dart';
import 'package:bagisto_app_demo/utils/application_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:skeleton_loader/skeleton_loader.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/app_global_data.dart';
import '../../../utils/assets_constants.dart';
import '../../../utils/dialog_helper.dart';
import '../../../utils/mobikul_theme.dart';
import '../../../utils/server_configuration.dart';
import '../../../utils/string_constants.dart';
import '../../../widgets/empty_data_view.dart';
import '../../../widgets/show_message.dart';
import '../../home_page/data_model/get_categories_drawer_data_model.dart';
import '../../home_page/data_model/new_product_data.dart';
import '../bloc/fetch_search_data_state.dart';
import '../bloc/fetch_search_event.dart';
import '../bloc/search_bloc.dart';
import 'widget/categories_view.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with TickerProviderStateMixin {
  final TextEditingController _searchText = TextEditingController();
  final SpeechToText _speechToText = SpeechToText();
  final bool _speechRecognitionAvailable = false;
  AnimationController? _controller;
  String transcription = '';
  bool _isListening = false;
  List<HomeCategories>? data;
  String searchImage = "imageSearch";
  String searchText = "textSearch";
  final Permission _permission = Permission.camera;
  SearchBloc? searchBloc;
  NewProductsModel? products;
  bool isFirst = true;
  bool isLoading = false;

  @override
  void initState() {
    activateSpeechRecognizer();
    searchBloc = context.read<SearchBloc>();
    searchBloc?.add(FetchCategoryPageEvent(GlobalData.rootCategoryId));
    super.initState();
  }

  void activateSpeechRecognizer() async {
    _controller = AnimationController(
      lowerBound: 0.5,
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
    await _speechToText.initialize();
    setState(() {});
  }

  void onRecognitionResult(SpeechRecognitionResult result) {
    setState(() {
      transcription = result.recognizedWords;
      _searchText.text = transcription;
      if (transcription.length > 2) {
        searchBloc?.add(CircularBarEvent(isReqToShowLoader: true));
        searchBloc?.add(SearchBarTextEvent(searchText: transcription));
        searchBloc?.add(FetchSearchEvent([
          {"key": '\"name\"', "value": '\"$transcription\"'}
        ]));
      }
      stop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: GlobalData.contentDirection(),
      child: BlocConsumer<SearchBloc, SearchBaseState>(
          listener: (BuildContext context, SearchBaseState current) {},
          builder: (BuildContext context, SearchBaseState state) {
            _searchText.text = (state is AppBarSearchTextState
                ? state.searchText
                : ((state is ClearSearchBarTextState)
                    ? ""
                    : _searchText.text))!;
            _searchText.value = _searchText.value.copyWith(
              text: _searchText.text,
              selection: TextSelection.fromPosition(
                TextPosition(offset: _searchText.text.length),
              ),
            );
            if (state is CircularBarState) {
              isLoading = state.isReqToShowLoader!;
            }
            if (state is FetchCategoriesPageDataState) {
              if (state.status == Status.success) {
                data = state.getCategoriesData?.data;
              }
              if (state.status == Status.fail) {}
            }
            if (state is FetchSearchDataState) {
              searchBloc?.add(CircularBarEvent(isReqToShowLoader: false));
              if (state.status == Status.success) {
                products = state.products!;
              }
              if (state.status == Status.fail) {
                return (state.products?.data ?? []).isEmpty
                    ? const EmptyDataView(
                        assetPath: AssetConstants.emptyCatalog,
                        message: "EmptyPageGenericLabel",
                      )
                    : const SizedBox();
              }
            }
            return Scaffold(
                appBar: _setAppBarView(context),
                body: SingleChildScrollView(
                  child: Column(children: [
                    Visibility(
                      visible: isLoading,
                      child: LinearProgressIndicator(
                        backgroundColor: Theme.of(context).iconTheme.color,
                        valueColor: const AlwaysStoppedAnimation(Colors.white),
                      ),
                    ),
                    ((data ?? []).isNotEmpty)
                        ? CategoriesView(data: data)
                        : SkeletonLoader(
                            highlightColor: Theme.of(context).highlightColor,
                            baseColor:
                                Theme.of(context).appBarTheme.backgroundColor ??
                                    MobikulTheme.primaryColor,
                            builder: const SizedBox(
                              height: 100,
                              child: Card(
                                color: Colors.red,
                              ),
                            )),
                    ((products?.data ?? []).isNotEmpty)
                        ? _getSearchData(products)
                        : _searchText.text.isNotEmpty
                            ? (products?.data ?? []).isEmpty
                                ? const EmptyDataView(
                                    assetPath: AssetConstants.emptyCatalog,
                                    message: StringConstants.emptyPageGenericLabel,
                                  )
                                : const SizedBox()
                            : const SizedBox(),
                  ]),
                ));
          }),
    );
  }

  /// App Bar View
  _setAppBarView(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(60.0),
      child: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: TextField(
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                onChanged: (value) async {
                  if (value.length > 2) {
                    searchBloc?.add(SearchBarTextEvent(searchText: value));
                    searchBloc?.add(CircularBarEvent(isReqToShowLoader: true));
                    searchBloc?.add(FetchSearchEvent([
                      {"key": '\"name\"', "value": '\"$value\"'}
                    ]));
                  }
                },
                readOnly: _isListening,
                controller: _searchText,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: StringConstants.searchScreenTitle.localized(),
                    hintStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary)),
              ),
            ),
          ],
        ),
        actions: [
          _searchText.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    Icons.close,
                  ),
                  onPressed: () {
                    searchBloc?.add(SearchBarTextEvent(searchText: ""));
                  },
                )
              : Container(),
          _isListening
              ? const Center(
                  child: Text(
                    "Listening...",
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.w400),
                  ),
                )
              : Container(),
          _buildVoiceInput(
            onPressed: _speechToText.isNotListening ? start : stop,
          )
        ],
      ),
    );
  }

  ///it will show the searched product
  _getSearchData(NewProductsModel? model) {
    var productList = model?.data;
    return (productList != null && productList.isNotEmpty)
        ? ProductList(model: model!)
        : Container();
  }

  ///voice search
  Widget _buildVoiceInput({VoidCallback? onPressed}) => GestureDetector(
      onTap: onPressed,
      child: SizedBox(
        width: 40,
        child: AnimatedBuilder(
          animation: CurvedAnimation(
              parent: _controller!, curve: Curves.fastOutSlowIn),
          builder: (context, child) {
            return Stack(
              alignment: Alignment.center,
              children: <Widget>[
                _buildContainer(10 * (_isListening ? _controller!.value : 0)),
                _buildContainer(20 * (_isListening ? _controller!.value : 0)),
                _buildContainer(30 * (_isListening ? _controller!.value : 0)),
                _buildContainer(40 * (_isListening ? _controller!.value : 0)),
                Align(
                  child: Icon(
                    _speechRecognitionAvailable && !_isListening
                        ? Icons.mic_off
                        : Icons.mic,
                    size: AppSizes.spacingWide,
                  ),
                ),
              ],
            );
          },
        ),
      ));

  void stop() async {
    await _speechToText.stop();
    _isListening = false;
    setState(() {});
  }

  void start() async {
    await _speechToText.listen(
      onResult: onRecognitionResult,
    );
    _isListening = true;
    setState(() {});
  }

  Widget _buildContainer(double radius) {
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey.shade400.withOpacity(1 - _controller!.value),
      ),
    );
  }

  ///Camera search

  Future<void> _checkPermission(Permission permission, String type) async {
    final status = await permission.request();
    if (status == PermissionStatus.granted) {
      try {
        const platform = MethodChannel(defaultChannelName);
        var value = await platform.invokeMethod(type);
        _searchText.text = value;
        onImageSearch(value);
        return value;
      } on PlatformException catch (e) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ShowMessage.showNotification(StringConstants.warning.localized(),
              e.message, Colors.yellow, const Icon(Icons.warning_amber));
        });
      }
    } else if (status == PermissionStatus.denied) {
      _checkPermission(_permission, type);
    } else if (status == PermissionStatus.permanentlyDenied) {
      openAppSettings();
    }
  }

  Future<void> onImageSearch(data) async {
    dynamic connected = await connectedToNetwork();
    if (connected == true) {
      searchBloc?.add(CircularBarEvent(isReqToShowLoader: true));
      searchBloc?.add(SearchBarTextEvent(searchText: data));
      searchBloc?.add(FetchSearchEvent([
        {"key": '\"name\"', "value": '\"$data\"'}
      ]));
      return data;
    } else {
      // ignore: use_build_context_synchronously
      DialogHelper.networkErrorDialog(context, onConfirm: () {
        onImageSearch(data);
      });
    }
  }

  static Future<bool> connectedToNetwork() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.mobile) {
      return true;
    } else if (result == ConnectivityResult.wifi) {
      return true;
    } else if (result == ConnectivityResult.ethernet) {
      return true;
    } else if (result == ConnectivityResult.bluetooth) {
      return true;
    } else {
      return false;
    }
  }
}
