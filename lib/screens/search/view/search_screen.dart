/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// ignore_for_file: file_names, must_be_immutable

import 'package:bagisto_app_demo/common_widget/loader.dart';
import 'package:bagisto_app_demo/helper/application_localization.dart';
import 'package:bagisto_app_demo/screens/search/bloc/search_bloc.dart';
import 'package:bagisto_app_demo/screens/search/event/circular_bar_event.dart';
import 'package:bagisto_app_demo/screens/search/event/fetch_search_event.dart';
import 'package:bagisto_app_demo/screens/search/event/search_text_bar_event.dart';
import 'package:bagisto_app_demo/screens/search/state/fetch_search_data_state.dart';
import 'package:bagisto_app_demo/screens/search/state/search_base_state.dart';
import 'package:bagisto_app_demo/screens/search/state/search_initial_state.dart';
import 'package:bagisto_app_demo/screens/search/view/product_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../../../common_widget/common_widgets.dart';
import '../../../common_widget/show_message.dart';
import '../../../configuration/app_global_data.dart';
import '../../../configuration/app_sizes.dart';
import '../../../configuration/server_configuration.dart';
import '../../../helper/dialog_helper.dart';
import '../../../models/categories_data_model/categories_product_model.dart';
import '../../../models/homepage_model/get_categories_drawer_data_model.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../state/appbar_search_text_state.dart';
import '../state/circular_bar_state.dart';
import '../state/clear_search_text_state.dart';
import 'categories_view.dart';
import 'empty_search_screen.dart';

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
  CategoriesProductModel ?  products;
  bool isFirst = true;
  bool isLoading = false;
  @override
  void initState() {
    activateSpeechRecognizer();
    searchBloc = context.read<SearchBloc>();
    searchBloc?.add(FetchCategoryPageEvent());
    // TODO: implement initState
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
        searchBloc?.add(FetchSearchEvent(transcription, "", ""));
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
                : ((state is ClearSearchBarTextState) ? "" : _searchText.text))!;

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
              if (state.status == Status.fail) {
                return CommonWidgets().getTextFieldHeight(0);
              }
            }
            if (state is FetchSearchDataState) {
              searchBloc?.add(CircularBarEvent(isReqToShowLoader: false));
              if (state.status == Status.success) {
                products = state.products!;
              }
              if (state.status == Status.fail) {
                return EmptySearchScreen(model: state.products!);
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
                    Visibility(
                        visible: (products?.data ?? []).isNotEmpty,
                        child: _getSearchData(products)),
                    ((data ?? []).isNotEmpty)
                        ? CategoriesView(data: data)
                        : Loader()
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
                    searchBloc?.add(FetchSearchEvent(value, "", ""));
                  }
                },
                readOnly: _isListening,
                controller: _searchText,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "SearchScreenTitle".localized(),
                    hintStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary)),
              ),
            ),
            _isListening
                ? const Text(
                    "Listening...",
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.w400),
                  )
                : Container(),
            _buildVoiceInput(
              onPressed: _speechToText.isNotListening ? start : stop,
            ),
            InkWell(
              child: Icon(
                Icons.camera_alt_outlined,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              onTap: () async {
                DialogHelper.searchDialog(context, () {
                  Navigator.of(context).pop();
                  _checkPermission(_permission, searchImage);
                }, () {
                  Navigator.of(context).pop();
                  _checkPermission(_permission, searchText);
                });
              },
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
        ],
      ),
    );
  }

  ///it will show the searched product
  _getSearchData(CategoriesProductModel? model) {
    var productList = model?.data;
    return (productList != null && productList.isNotEmpty)
        ? ProductList(model: model!)
        : EmptySearchScreen(model: products);
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
                    size: AppSizes.size22,
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
          ShowMessage.showNotification(
              e.message, "", Colors.yellow, const Icon(Icons.warning_amber));
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
      searchBloc?.add(FetchSearchEvent(data, "", ""));
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
