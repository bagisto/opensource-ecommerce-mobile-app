import 'package:bagisto_app_demo/screens/checkout/utils/index.dart';
import 'package:bagisto_app_demo/screens/gdpr/bloc/gdpr_bloc.dart';
import 'package:bagisto_app_demo/screens/gdpr/bloc/gdpr_state.dart';
import 'package:bagisto_app_demo/screens/gdpr/view/widget/create_request.dart';
import 'package:bagisto_app_demo/screens/home_page/data_model/theme_customization.dart';
import 'package:bagisto_app_demo/screens/product_screen/view/file_download.dart';
import 'package:bagisto_app_demo/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:developer';
import '../bloc/gdpr_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GdprScreen extends StatefulWidget {
  const GdprScreen({super.key});
  @override
  State<GdprScreen> createState() => GdprScreenState();
}

class GdprScreenState extends State<GdprScreen> {
  GdprBloc? gdprBloc;
  String customerEmail = "";
  List<Map<String, dynamic>> gdprRequests = [];

  @override
  void initState() {
    // Initialize gdprBloc
    gdprBloc = context.read<GdprBloc>();
    gdprBloc?.add(FetchGdprRequestsList());
    customerEmail = appStoragePref.getCustomerEmail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('GDPR Data Requests',
              style: Theme.of(context).appBarTheme.titleTextStyle),
          // backgroundColor: Theme.of(context).colorScheme.secondary,
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          elevation: Theme.of(context).appBarTheme.elevation,
          centerTitle: false,
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: BlocConsumer<GdprBloc, GdprState>(
            listener: (BuildContext context, GdprState state) {
              if (state is FetchGdprRequestsState) {
                if (state.status == GdprStatus.success) {
                  setState(() {
                    gdprRequests = state.requests?.data
                            ?.map((e) => {
                                  'id': e.id,
                                  'status': e.status,
                                  'type': e.type,
                                  'message': e.message,
                                  'date': e.createdAt,
                                })
                            .toList() ??
                        [];
                  });
                }
              }
              if (state is GdprSearchRequestState) {
                if (state.status == GdprStatus.success) {
                  setState(() {
                    gdprRequests = state.request != null
                        ? [
                            {
                              'id': state.request?.id,
                              'status': state.request?.status,
                              'type': state.request?.type,
                              'message': state.request?.message,
                              'date': state.request?.createdAt,
                            }
                          ]
                        : [];
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            state.error ?? 'Failed to fetch search results')),
                  );
                }
              }
              if (state is CreateGdprRequestState) {
                if (state.status == CreateGdprRequestStatus.success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Request created')),
                  );
                  gdprBloc?.add(FetchGdprRequestsList());
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text(state.error ?? 'Failed to create request')),
                  );
                }
              }
              if (state is RevokeGdprRequestState) {
                if (state.status == GdprStatus.success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message ?? "")),
                  );
                  gdprBloc?.add(FetchGdprRequestsList());
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text(state.error ?? 'Failed to revoke request')),
                  );
                }
              }

              if (state is GdprPdfRequestState) {
                if (state.status == GdprStatus.success) {
                  DownloadFile().saveBase64String(state.pdfModel?.string ?? '',
                      state.pdfModel?.download?.fileName ?? '');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(state.error ?? 'Failed to export PDF')),
                  );
                }
              }
            },
            builder: (BuildContext context, GdprState state) {
              return Stack(children: [
                SingleChildScrollView(
                    child: Column(children: [
                  // Buttons Row

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _exportButton('PDF'),
                      _exportButton('HTML'),
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => CreateRequestModal(
                              gdprBloc: gdprBloc,
                              customerEmail: customerEmail,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MobiKulTheme.linkColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          padding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                        ),
                        child: Text(StringConstants.createRequest.localized(),
                            style: TextStyle(color: MobiKulTheme.primaryColor)),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Search Bar
                  TextField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: StringConstants.searchScreenTitle.localized(),
                        filled: false,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Theme.of(context).dividerColor,
                            width: 1,
                          ),
                        ),
                        // fillColor:
                        //     Theme.of(context).searchBarTheme.backgroundColor,
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Theme.of(context).dividerColor,
                            width: 1,
                          ),
                        ),
                      ),
                      onSubmitted: (value) => {
                            if (value.trim().isEmpty)
                              {gdprBloc?.add(FetchGdprRequestsList())}
                            else
                              {
                                if (!RegExp(r'^\d+$').hasMatch(value))
                                  {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Please enter a valid numeric ID')),
                                    )
                                  }
                                else
                                  {
                                    gdprBloc?.add(
                                        GdprSearchRequest(id: int.parse(value)))
                                  }
                              }
                          }),
                  SizedBox(height: 20),
                  // GDPR Request Card
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: gdprRequests.length,
                        itemBuilder: (context, index) {
                          final req = gdprRequests[index];
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            color: Theme.of(context).cardColor,
                            margin: EdgeInsets.only(bottom: 16),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _infoRow('ID', req['id'].toString()),
                                  _infoRow('Status',
                                      req['status'].toString().toUpperCase(),
                                      color: MobiKulTheme.warningColor,
                                      isLabel: true),
                                  _infoRow('Type',
                                      req['type'].toString().toUpperCase()),
                                  _infoRow('Message', req['message'] ?? ""),
                                  _infoRow('Date', req['date'] ?? ""),
                                  SizedBox(height: 10),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (req['status']
                                                .toString()
                                                .toUpperCase() ==
                                            "REVOKED") {
                                          return;
                                        }
                                        gdprBloc?.add(RevokeGdprRequest(
                                            id: int.parse(req['id'])));
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: req['status']
                                                    .toString()
                                                    .toUpperCase() ==
                                                "REVOKED"
                                            ? MobiKulTheme.greyColor
                                            : MobiKulTheme.linkColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                      child: req['status']
                                                  .toString()
                                                  .toUpperCase() ==
                                              "REVOKED"
                                          ? Text(
                                              StringConstants.revoked
                                                  .localized(),
                                              style: TextStyle(
                                                  color: MobiKulTheme
                                                      .primaryColor),
                                            )
                                          : Text(
                                              StringConstants.revoke
                                                  .localized(),
                                              style: TextStyle(
                                                  color: MobiKulTheme
                                                      .primaryColor)),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  )
                ])),
                if (state is GdprLoadingState)
                  Align(
                    alignment: Alignment.center,
                    child: Center(
                        child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.primary,
                    )),
                  )
              ]);
            },
          ),
        ));
  }

  Widget _exportButton(String label) {
    return OutlinedButton(
      onPressed: () {
        if (label == 'PDF') {
          gdprBloc?.add(GdprPdfRequest());
        } else if (label == 'HTML') {
          launchUrl(Uri.parse("$baseDomain/customer/account/gdpr/html-view"),
              mode: LaunchMode.externalApplication);
        }
      },
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: MobiKulTheme.skeletonLoaderColorLight),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      child: Text(label, style: Theme.of(context).textTheme?.bodyMedium),
    );
  }

  Widget _infoRow(String label, String value,
      {Color? color, bool isLabel = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ', style: Theme.of(context).textTheme.labelSmall),
          Expanded(
            child: Container(
              padding: isLabel
                  ? EdgeInsets.symmetric(horizontal: 8, vertical: 2)
                  : EdgeInsets.zero,
              decoration: isLabel
                  ? BoxDecoration(
                      color: color?.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    )
                  : null,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  color: isLabel
                      ? color
                      : Theme.of(context).textTheme.bodyMedium?.color,
                  fontWeight: isLabel ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
