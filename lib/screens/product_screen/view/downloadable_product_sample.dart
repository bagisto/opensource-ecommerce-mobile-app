/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */



import 'dart:io';
import 'package:bagisto_app_demo/screens/product_screen/utils/index.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:open_file/open_file.dart';


class DownloadProductSample extends StatefulWidget {
  final GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey;
  final  List<DownloadableSamples>? samples;

  const DownloadProductSample({Key? key, this.samples, this.scaffoldMessengerKey})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DownloadProductSampleState();
  }
}

class _DownloadProductSampleState extends State<DownloadProductSample> {
  final buttonCarouselController = CarouselController();
  ProductScreenBLoc? productScreenBLoc;
  var loadData = 0.0;
  bool showLoader = false;
  final StreamController<double> _downloadProgressController = StreamController<double>.broadcast();


  @override
  void initState() {
    super.initState();
    productScreenBLoc  = context.read<ProductScreenBLoc>();
  }

  @override
  Widget build(BuildContext context) {
    return (widget.samples?.length ?? 0) > 0
        ? Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  Text(
                    StringConstants.samples.localized(),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: (widget.samples?.length ?? 0),
                      itemBuilder: (context, i) {
                        return Padding(
                            padding: const EdgeInsets.only(top: 4, bottom: 4),
                            child: InkWell(
                              onTap: () {
                                  // DownloadFile().downloadPersonalData(
                                  //     widget.samples?[i].type == "file" ? (widget.samples?[i].fileUrl ?? "") : widget.samples?[i].url ?? "",
                                  //     widget.samples?[i].fileName ?? "sample$i.jpg",
                                  //     widget.samples?[i].type ?? "",
                                  //     context,
                                  //     widget.scaffoldMessengerKey);

                                  // downloadFile(
                                  //   widget.samples?[i].type == "file" ? (widget.samples?[i].fileUrl ?? "") : widget.samples?[i].url ?? "",
                                  //   widget.samples?[i].fileName ?? "sample$i.jpg");


                                productScreenBLoc?.add(DownloadProductSampleEvent("file", widget.samples?[i].id,widget.samples?[i].fileName ));
                              },
                              child: Text(
                                widget.samples?[i].translations
                                        ?.map((e) => e.title)
                                        .toString() ??
                                    '',
                                style: const TextStyle(color: Colors.blue),
                              ),
                            ));
                      })
                ]),
        )
        : const SizedBox();
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
          String savePath = "$savedDir/${DateTime
              .now()
              .microsecondsSinceEpoch
              .toString()}_${filename ?? 'downloaded_file'}";
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
          _showSnackbar('${StringConstants.downloadComplete.localized()}!', savePath);
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
            return Text('${StringConstants.downloadProgress.localized()}: ${(progress * 100).toStringAsFixed(0)}%');
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
