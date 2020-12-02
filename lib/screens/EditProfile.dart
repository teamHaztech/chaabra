
import 'package:chaabra/providers/LogProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:provider/provider.dart';
import 'constants.dart';
import 'package:webview_flutter/webview_flutter.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  WebViewController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<LogProvider>(context, listen: false)
          .setUserDetailsInUpdateFields();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bodyHeight = screenHeight(context) - 85;
    final log = Provider.of<LogProvider>(context);
    return WillPopScope(
      onWillPop: () {
        Future.value(true);
        Provider.of<LogProvider>(context, listen: false).clearUpdateState();
        navPop(context);
        return;
      },
      child: Scaffold(
        endDrawer: cartDrawer(context),
        key: _scaffoldKey,
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 53),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: bodyHeight,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Container(
                                  height: 10,
                                  color: Color(0xff0d50d0),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: input(
                                                hint: "First name",
                                                label: "First name",
                                                controller: log.firstNameUpdate,
                                                onChanged: (e) {
                                                  log.checkIfAllFieldsAreChanged();
                                                }),
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Expanded(
                                            child: input(
                                                hint: "Last name",
                                                label: "Last name",
                                                controller: log.lastNameUpdate,
                                                onChanged: (e) {
                                                  log.checkIfAllFieldsAreChanged();
                                                }),
                                          ),
                                        ],
                                      ),
                                      input(
                                          hint: "Email ID",
                                          label: "Email ID",
                                          controller: log.emailUpdate,
                                          onChanged: (e) {
                                            log.checkIfAllFieldsAreChanged();
                                          }),
                                      input(
                                          hint: "Phone",
                                          label: "Phone",
                                          controller: log.phoneUpdate,
                                          onChanged: (e) {
                                            log.checkIfAllFieldsAreChanged();
                                          }),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: fullWidthButton(
                                context,
                                title: "Update",
                                enableButton: log.isUpdateButtonEnabled,
                                onTap: (){
                                  log.checkUpdateType(context);
                                }
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              header(context, key: _scaffoldKey, title: "", popButton: true),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class HtmlViewer extends StatefulWidget {
  String content;
  HtmlViewer({this.content});
  @override
  _HtmlViewerState createState() => _HtmlViewerState();
}

class _HtmlViewerState extends State<HtmlViewer> {
  var HtmlCode = '<h1> h1 Heading Tag</h1>' +
      '<h2> h2 Heading Tag </h2>' +
      '<p> Sample Paragraph Tag </p>' +
      '<img src="https://flutter-examples.com/wp-content/uploads/2019/04/install_thumb.png" alt="Image" width="250" height="150" border="3">';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebviewScaffold(
        url: new Uri.dataFromString(widget.content, mimeType: 'text/html')
            .toString(),
      ),
    );
  }
}
