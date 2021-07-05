import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wealth_management/Push%20Notification/pushNotification.dart';

class WebExampleTwo extends StatefulWidget {
  final String url;

  WebExampleTwo({Key? key, required this.url}) : super(key: key);

  @override
  _WebExampleTwoState createState() => _WebExampleTwoState();
}

class _WebExampleTwoState extends State<WebExampleTwo> {
  FirebaseNotifcation? firebase;

  handleAsync() async {
    await firebase!.initialize();
    String? token = await firebase!.getToken();
    print("Firebase token : $token");
  }

  @override
  void initState() {
    super.initState();
    firebase = FirebaseNotifcation();
    handleAsync();

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(color: Colors.yellow[800]),
      onRefresh: () async {
        if (Platform.isAndroid) {
          _webViewController?.reload();
        } else if (Platform.isIOS) {
          _webViewController?.loadUrl(
              urlRequest: URLRequest(url: await _webViewController?.getUrl()));
        }
      },
    );
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text(
                  'No',
                  style: TextStyle(color: Colors.green[800]),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text(
                  'Yes',
                  style: TextStyle(color: Colors.red[800]),
                ),
              ),
            ],
          ),
        )) ??
        false;
  }

  InAppWebViewController? _webViewController;
  double progress = 0;
  String url = '';

  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        javaScriptEnabled: true,
        useShouldOverrideUrlLoading: true,
        useOnDownloadStart: true,
      ),
      android: AndroidInAppWebViewOptions(
        initialScale: 100,
        useShouldInterceptRequest: true,
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  late PullToRefreshController pullToRefreshController;
  final urlController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(1, 60, 88, 1),
          title: Shimmer.fromColors(
            baseColor: Colors.white,
            highlightColor: Color.fromRGBO(251, 182, 77, 1),
            child: Column(
              children: [
                Text(
                  'CARRY FORWARD',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22.0,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                _webViewController?.goBack();
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.yellow[800],
              ),
            ),
            IconButton(
              onPressed: () {
                _webViewController?.goForward();
              },
              icon: Icon(
                Icons.arrow_forward_ios,
                color: Colors.yellow[800],
              ),
            ),
            SizedBox(width: 10),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _webViewController?.reload();
          },
          child: Icon(
            Icons.refresh,
          ),
          backgroundColor: Colors.yellow[800],
        ),
        body: SafeArea(
          child: Container(
            child: Column(
              children: [
                progress < 1.0
                    ? LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.white,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.yellow[800]!),
                      )
                    : Center(),
                Expanded(
                  child: InAppWebView(
                    key: webViewKey,
                    initialUrlRequest: URLRequest(
                      url: Uri.parse(widget.url),
                      headers: {},
                    ),
                    initialOptions: options,
                    pullToRefreshController: pullToRefreshController,
                    onWebViewCreated: (controller) {
                      _webViewController = controller;
                    },
                    onLoadStart: (controller, url) {
                      setState(() {
                        this.url = url.toString();
                        urlController.text = this.url;
                      });
                    },
                    androidOnPermissionRequest:
                        (controller, origin, resources) async {
                      return PermissionRequestResponse(
                          resources: resources,
                          action: PermissionRequestResponseAction.GRANT);
                    },
                    onLoadStop: (controller, url) async {
                      pullToRefreshController.endRefreshing();
                      setState(() {
                        this.url = url.toString();
                        urlController.text = this.url;
                      });
                    },
                    onLoadError: (controller, url, code, message) {
                      pullToRefreshController.endRefreshing();
                    },
                    onProgressChanged: (controller, progress) {
                      if (progress == 100) {
                        pullToRefreshController.endRefreshing();
                      }
                      setState(() {
                        this.progress = progress / 100;
                        urlController.text = this.url;
                      });
                    },
                    onUpdateVisitedHistory: (controller, url, androidIsReload) {
                      setState(() {
                        this.url = url.toString();
                        urlController.text = this.url;
                      });
                    },
                    onConsoleMessage: (controller, consoleMessage) {
                      print(consoleMessage);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
