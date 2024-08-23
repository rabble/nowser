import 'package:flutter/material.dart';
import 'package:nostr_sdk/utils/string_util.dart';
import 'package:nowser/component/webview/web_info.dart';
import 'package:nowser/component/webview/webview_component.dart';
import 'package:nowser/const/base.dart';
import 'package:nowser/const/router_path.dart';
import 'package:nowser/main.dart';
import 'package:nowser/provider/web_provider.dart';
import 'package:nowser/util/router_util.dart';
import 'package:provider/provider.dart';

import '../../component/webview/web_home_component.dart';

class IndexWebComponent extends StatefulWidget {
  int index;

  IndexWebComponent(this.index);

  @override
  State<StatefulWidget> createState() {
    return _IndexWebComponent();
  }
}

class _IndexWebComponent extends State<IndexWebComponent> {
  static const double BOTTOM_BTN_PADDING = 10;

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var padding = mediaQuery.padding;
    var maxWidth = mediaQuery.size.width;
    var titleWidth = maxWidth / 2;

    Widget numberWidget =
        Selector<WebProvider, int>(builder: (context, length, child) {
      return Badge(
        label: Text("$length"),
        backgroundColor:
            Colors.blueAccent, // TODO here should use background color
        child: Icon(Icons.crop_din),
      );
    }, selector: (context, provider) {
      return provider.webInfos.length;
    });

    return Container(
      padding: EdgeInsets.only(
        top: padding.top,
        bottom: padding.bottom,
      ),
      child: Selector<WebProvider, WebInfo?>(
        builder: (context, webInfo, child) {
          if (webInfo == null || StringUtil.isBlank(webInfo.url)) {
            if (webInfo == null) {
              return Container();
            }

            return WebHomeComponent(webInfo);
          }

          var main = WebViewComponent(webInfo, (webInfo, controller) {
            webInfo.controller = controller;
            webProvider.updateWebInfo(webInfo);
          }, (webInfo, controller, title) {
            webInfo.title = title;
            webProvider.updateWebInfo(webInfo);
          });

          String title = "";
          if (StringUtil.isNotBlank(webInfo.title)) {
            title = webInfo.title!;
          } else if (StringUtil.isNotBlank(webInfo.url)) {
            title = webInfo.url;
          }

          return Column(
            children: [
              Expanded(child: main),
              Container(
                height: 60,
                child: Row(
                  children: [
                    wrapBottomBtn(const Icon(Icons.home_filled),
                        left: 13, right: 8, onTap: () {
                      webProvider.goHome(webInfo);
                    }),
                    wrapBottomBtn(numberWidget, left: 8, right: 8, onTap: () {
                      RouterUtil.router(context, RouterPath.WEB_TABS);
                    }),
                    Expanded(
                        child: Container(
                      margin: const EdgeInsets.only(
                        left: 8,
                        right: 8,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius:
                            BorderRadius.circular(Base.BASE_PADDING_HALF),
                      ),
                      padding: const EdgeInsets.only(
                        left: Base.BASE_PADDING,
                        right: Base.BASE_PADDING,
                        top: Base.BASE_PADDING_HALF,
                        bottom: Base.BASE_PADDING_HALF,
                      ),
                      width: titleWidth,
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )),
                    wrapBottomBtn(const Icon(Icons.space_dashboard),
                        left: 8, right: 8),
                    wrapBottomBtn(const Icon(Icons.segment),
                        left: 8, right: 13),
                  ],
                ),
              ),
            ],
          );
        },
        selector: (context, provider) {
          return provider.getWebInfo(widget.index);
        },
      ),
    );
  }

  Widget wrapBottomBtn(Widget btn,
      {double left = 10, double right = 10, Function? onTap}) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap();
        }
      },
      child: Container(
        padding: EdgeInsets.only(
          left: left,
          right: right,
        ),
        child: btn,
      ),
    );
  }
}
