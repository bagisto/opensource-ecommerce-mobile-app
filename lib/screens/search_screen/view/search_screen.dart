/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/screens/search_screen/utils/index.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

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
    searchBloc?.add(FetchCategoryPageEvent([
      {"key": '"status"', "value": '"1"'},
      {"key": '"locale"', "value": '"${GlobalData.locale}"'},
      {"key": '"parent_id"', "value": '"1"'}
    ]));
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
          {"key": '"name"', "value": '"$transcription"'}
        ]));
      }
      stop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SearchBloc, SearchBaseState>(
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
            if (state.status == Status.fail) {}
          }
          if (state is FetchSearchDataState) {
            searchBloc?.add(CircularBarEvent(isReqToShowLoader: false));
            if (state.status == Status.success) {
              if (state.products != null) {
                products = state.products;
              }
            }
            if (state.status == Status.fail) {
              return (state.products?.data ?? []).isEmpty
                  ? const EmptyDataView(
                      assetPath: AssetConstants.emptyCatalog,
                      message: StringConstants.emptyPageGenericLabel,
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
                    child: const LinearProgressIndicator(
                      backgroundColor: MobiKulTheme.accentColor,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  ),
                  ((data ?? []).isNotEmpty)
                      ? CategoriesView(data: data)
                      : SkeletonLoader(
                          highlightColor: Theme.of(context).highlightColor,
                          baseColor: Theme.of(context).scaffoldBackgroundColor,
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
                                  message:
                                      StringConstants.emptyPageGenericLabel,
                                )
                              : const SizedBox()
                          : const SizedBox(),
                ]),
              ));
        });
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
                onChanged: (value) async {
                  if (value.length > 2) {
                    searchBloc?.add(SearchBarTextEvent(searchText: value));
                    searchBloc?.add(CircularBarEvent(isReqToShowLoader: true));
                    searchBloc?.add(FetchSearchEvent([
                      {"key": '"name"', "value": '"$value"'}
                    ]));
                  }
                },
                readOnly: _isListening,
                controller: _searchText,
                style: Theme.of(context).textTheme.bodyMedium,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: StringConstants.searchScreenTitle.localized(),
                ),
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
              : const SizedBox(),
          _isListening
              ? const Center(
                  child: Text(
                    "Listening...",
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.w400),
                  ),
                )
              : const SizedBox(),
          _buildVoiceInput(
            onPressed: _speechToText.isNotListening ? start : stop,
          ),
          IconButton(
            icon: const Icon(
              Icons.camera_alt_outlined,
            ),
            onPressed: () async {
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
    );
  }

  ///it will show the searched product
  _getSearchData(NewProductsModel? model) {
    var productList = model?.data;
    return (productList != null && productList.isNotEmpty)
        ? ProductList(model: model!)
        : const SizedBox();
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
        {"key": '"name"', "value": '"$data"'}
      ]));
      return data;
    } else {
      DialogHelper.networkErrorDialog(context, onConfirm: () {
        onImageSearch(data);
      });
    }
  }

  static Future<bool> connectedToNetwork() async {
    bool result =
        await InternetConnectionChecker.createInstance().hasConnection;
    return result;
  }
}
