import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyAppHomePage extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}



const String flutterUrl = "https://carryforward.bizzware.net/";

class _MyAppState extends State<MyAppHomePage> {

  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit an App'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: new Text('Yes'),
          ),
        ],
      ),
    )) ?? false;
  }



  WebViewController? _controller;

  _back() async {
    if (await _controller!.canGoBack()) {
      await _controller!.goBack();
    }
  }

  _forward() async {
    if (await _controller!.canGoForward()) {
      await _controller!.goForward();
    }
  }

  _loadPage() async {
    var url = await _controller!.currentUrl();
    _controller!.loadUrl(
      url == "https://carryforward.bizzware.net/"
          ? 'https://carryforward.bizzware.net/'
          : "https://carryforward.bizzware.net/",
    );

    print(url);
  }


  @override
  void initState() {
    super.initState();

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
            highlightColor: Colors.black54,
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
              onPressed: _back,
              icon: Icon(Icons.arrow_back_ios,color: Colors.blue,),
            ),
            IconButton(
              onPressed: _forward,
              icon: Icon(Icons.arrow_forward_ios,color: Colors.blue,),
            ),
            SizedBox(width: 10),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _loadPage,
          child: Icon(Icons.refresh),
        ),
        body: SafeArea(
          child: WebView(
            key: Key("webview"),
            initialUrl: flutterUrl,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller = webViewController;
            },
          ),
        ),
      ),
    );
  }
}


