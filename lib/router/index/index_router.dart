import 'package:flutter/material.dart';
import 'package:nowser/main.dart';
import 'package:nowser/provider/web_provider.dart';
import 'package:nowser/router/index/index_web_component.dart';
import 'package:provider/provider.dart';

import '../../component/webview/webview_component.dart';
import '../../provider/android_signer_mixin.dart';
import '../../provider/permission_check_mixin.dart';

class IndexRouter extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _IndexRouter();
  }
}

class _IndexRouter extends State<IndexRouter>
    with PermissionCheckMixin, AndroidSignerMixin {
  Map<String, WebViewComponent> webViewComponentMap = {};

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      handleInitialIntent(context);
    });

    webProvider.checkBlank();

    var main = Selector<WebProvider, WebNumInfo>(
        builder: (context, webNumInfo, child) {
      List<Widget> list = [];
      for (var i = 0; i < webNumInfo.length; i++) {
        list.add(IndexWebComponent(i));
      }
      return IndexedStack(
        index: webNumInfo.index,
        children: list,
      );
    }, selector: (context, provider) {
      return provider.getWebNumInfo();
    });

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        var webInfo = webProvider.currentWebInfo();
        if (webInfo != null) {
          webProvider.goBack(webInfo);
        }
      },
      child: Scaffold(
        body: main,
      ),
    );
  }
}
