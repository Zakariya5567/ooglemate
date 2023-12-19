import 'dart:async';
import 'dart:io';

import 'package:caroogle/helper/routes_helper.dart';
import 'package:caroogle/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../providers/subscription_provider.dart';
import '../../../utils/app_constant.dart';
import '../../widgets/custom_button.dart';

class AddCardScreen extends StatefulWidget {
  AddCardScreen({Key? key}) : super(key: key);

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SubscriptionProvider>(context, listen: false);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: whiteStatusBar(),
      child: SafeArea(
        bottom: Platform.isAndroid ? true : false,
        top: Platform.isAndroid ? true : false,
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: primaryWhite,
            appBar: AppBar(
              toolbarHeight: Platform.isAndroid ? 0 : double.maxFinite,
              backgroundColor: primaryWhite,
              elevation: 0,
              automaticallyImplyLeading: false,
              leading: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: primaryBlack,
                  size: 23,
                ),
              ),
            ),
            body: WebView(
              javascriptMode: JavascriptMode.unrestricted,
              initialUrl: provider.checkoutModel.data!.url,
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
              },
              onProgress: (int progress) {
                debugPrint('WebView is loading (progress : $progress%)');
              },
              javascriptChannels: <JavascriptChannel>{
                _toasterJavascriptChannel(context),
              },
              navigationDelegate: (NavigationRequest request) async {
                SharedPreferences sharedPreferences =
                    await SharedPreferences.getInstance();

                if (request.url.startsWith('https://www.google.com/success')) {
                  debugPrint('blocking navigation to $request}');
                  sharedPreferences.setString(
                      AppConstant.subscription, "subscribed");
                  Future.delayed(Duration.zero, () {
                    Navigator.pushReplacementNamed(
                        context, RouterHelper.thankYouScreen);
                  });

                  return NavigationDecision.prevent;
                } else if (request.url
                    .startsWith('https://www.google.com/failure')) {
                  Future.delayed(Duration.zero, () {
                    Navigator.pushReplacementNamed(
                        context, RouterHelper.choosePlanScreen);
                  });
                }
                debugPrint('allowing navigation to $request');
                return NavigationDecision.navigate;
              },
              onPageStarted: (String url) {
                debugPrint('Page started loading: $url');
              },
              onPageFinished: (String url) {
                debugPrint('Page finished loading: $url');
              },
              gestureNavigationEnabled: true,
              backgroundColor: const Color(0x00000000),
            )),
      ),
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }
}
