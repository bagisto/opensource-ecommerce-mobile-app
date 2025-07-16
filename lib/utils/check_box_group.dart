/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'dart:async';

import 'package:bagisto_app_demo/screens/account/utils/index.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../screens/home_page/data_model/new_product_data.dart';
import '../screens/product_screen/bloc/product_page_bloc.dart';
import '../screens/product_screen/bloc/product_page_event.dart';

class CheckboxGroup extends StatefulWidget {
  final List<String>? labels;
  final List<String>? checked;
  final void Function(bool isChecked, String label, int index, Key? key)?
      onChange;
  final void Function(List<String> selected)? onSelected;
  final TextStyle? labelStyle;
  final Color? activeColor;
  final Color checkColor;
  final bool triState;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final List<DownloadableLinks>? data;
  final bool showText;
  final GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey;

  CheckboxGroup(
      {Key? key,
      required this.labels,
      this.checked,
      this.onChange,
      this.onSelected,
      this.labelStyle = const TextStyle(),
      this.activeColor, //defaults to toggleableActiveColor,
      this.checkColor = const Color(0xFFFFFFFF),
      this.triState = false,
      this.padding = const EdgeInsets.all(0.0),
      this.margin = const EdgeInsets.all(0.0),
      this.data,
      this.showText = false,
      this.scaffoldMessengerKey})
      : super(key: key);

  @override
  State<CheckboxGroup> createState() => _CheckboxGroupState();
}

class _CheckboxGroupState extends State<CheckboxGroup> {
  List<String> _selected = [];
  var loadData = 0.0;
  ProductScreenBLoc? productScreenBLoc;
  final StreamController<double> _downloadProgressController =
      StreamController<double>.broadcast();
  bool showLoader = false;

  @override
  void initState() {
    super.initState();
    productScreenBLoc = context.read<ProductScreenBLoc>();
    _selected = widget.checked ?? [];
  }

  @override
  Widget build(BuildContext context) {
    // if (widget.checked != null) {
    //   _selected = [];
    //   _selected.addAll(widget.checked!); //use add all to prevent a shallow copy
    // }

    List<Widget> content = [];

    for (int label = 0; label < (widget.labels?.length ?? 0); label++) {
      Checkbox checkBox = Checkbox(
        value: _selected.contains(widget.labels?.elementAt(label)),
        onChanged: (bool? isChecked) => onChanged(isChecked ?? false, label),
        checkColor: Theme.of(context).colorScheme.background,
        activeColor: Theme.of(context).colorScheme.onBackground,
        tristate: widget.triState,
      );

      Text textWidget =
          Text(widget.labels?.elementAt(label) ?? '', style: widget.labelStyle);
      content.add(Row(children: [
        checkBox,
        Expanded(
          flex: 1,
          child: textWidget,
        ),
        if (widget.showText &&
            (widget.data?[label].sampleFileUrl ?? "").isNotEmpty)
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: () {
                // DownloadFile().downloadPersonalData(
                //     widget.data?[label].type == "file" ? (widget.data?[label].sampleFileUrl ?? "")
                //         : widget.data?[label].sampleUrl ?? "",
                //     widget.data?[label].sampleFileName ?? "sampleLink$label.jpg",
                //     widget.data?[label].type ?? "",
                //     context, GlobalKey());

                // downloadFile(
                //     widget.data?[label].type == "file" ? (widget.data?[label].sampleFileUrl ?? "")
                //         : widget.data?[label].sampleUrl ?? "",
                //     widget.data?[label].sampleFileName ?? "sampleLink$label.jpg");

                productScreenBLoc?.add(DownloadProductSampleEvent(
                    "link",
                    widget.data?[label].id,
                    widget.data?[label].sampleFileName));
              },
              child: Text(
                StringConstants.sample.localized(),
                style: const TextStyle(color: Colors.blue),
              ),
            ),
          )
      ]));
    }

    return Container(
      padding: widget.padding,
      margin: widget.margin,
      child: Column(children: content),
    );
  }

  void onChanged(bool isChecked, int index) {
    bool isAlreadyContained =
        _selected.contains(widget.labels?.elementAt(index));
    if (mounted) {
      setState(() {
        if (!isChecked && isAlreadyContained) {
          _selected.remove(widget.labels?.elementAt(index));
        } else if (isChecked && !isAlreadyContained) {
          _selected.add(widget.labels?.elementAt(index) ?? '');
        }
        if (widget.onChange != null) {
          widget.onChange!(isChecked, widget.labels?.elementAt(index) ?? '',
              index, widget.key);
          if (widget.onSelected != null) widget.onSelected!(_selected);
        }
      });
    }
  }

  Future<void> downloadFile(String url, [String? filename]) async {
    if (url.isEmpty) {
      debugPrint("Mobikul Download error: URL is empty");
      return;
    }

    try {
      final plugin = DeviceInfoPlugin();
      var hasStoragePermission = true;
      if (Platform.isAndroid) {
        final android = await plugin.androidInfo;
        hasStoragePermission = android.version.sdkInt < 33
            ? await Permission.storage.isGranted
            : true;
      }

      if (Platform.isIOS) {
        hasStoragePermission = await Permission.storage.isGranted;
      }

      if (!hasStoragePermission) {
        final status = await Permission.storage.request();
        hasStoragePermission = status.isGranted;
      }
      if (hasStoragePermission) {
        try {
          final directory = Platform.isIOS
              ? await getApplicationDocumentsDirectory()
              : await getTemporaryDirectory();
          final savedDir = directory.path;

          Dio dio = Dio();
          String savePath =
              "$savedDir/${DateTime.now().microsecondsSinceEpoch.toString()}_${filename ?? 'downloaded_file'}";
          await dio.download(
            url,
            savePath,
            onReceiveProgress: (received, total) {
              if (total != -1) {
                double progress = received / total;
                _downloadProgressController.add(progress);
                setState(() {
                  loadData = progress;
                });
              }
            },
          );
          _showSnackbar(
              '${StringConstants.downloadComplete.localized()}!', savePath);
          setState(() {
            loadData = 1;
            showLoader = false;
          });
        } catch (e, stacktrace) {
          debugPrint("Mobikul Download error inner : $e");
          debugPrint("Mobikul Download stack trace inner : $stacktrace");
        }
      }
    } catch (e, stacktrace) {
      debugPrint("Mobikul Download error outer : $e");
      debugPrint("Mobikul Download stack trace outer : $stacktrace");
    }
  }

  void _showSnackbar(String message, String? filePath) {
    widget.scaffoldMessengerKey?.currentState?.hideCurrentSnackBar();
    final snackBar = SnackBar(
      content: StreamBuilder<double>(
        stream: _downloadProgressController.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            double progress = snapshot.data!;
            return Text(
                '${StringConstants.downloadProgress.localized()}: ${(progress * 100).toStringAsFixed(0)}%');
          } else {
            return Text(message);
          }
        },
      ),
      duration: const Duration(days: 1),
      action: filePath != null
          ? SnackBarAction(
              label: StringConstants.open.localized(),
              textColor: Theme.of(context).scaffoldBackgroundColor,
              onPressed: () {
                openDownloadedFile(filePath);
              },
            )
          : null,
    );

    widget.scaffoldMessengerKey?.currentState?.showSnackBar(snackBar);
  }

  void openDownloadedFile(String filePath) {
    OpenFile.open(filePath).then((result) {
      if (result.type == ResultType.error) {
        _showSnackbar('Failed to open the file.', null);
      }
    });
  }
}
