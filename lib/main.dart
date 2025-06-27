import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await InAppWebViewController.setWebContentsDebuggingEnabled(true);

  runApp(const MaterialApp(home: SheinWebView()));
}

class SheinWebView extends StatefulWidget {
  const SheinWebView({Key? key}) : super(key: key);

  @override
  State<SheinWebView> createState() => _SheinWebViewState();
}

class _SheinWebViewState extends State<SheinWebView> {
  late InAppWebViewController webViewController;
  bool isProductPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SHEIN"),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              webViewController.reload();
            },
          ),
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              webViewController.goBack();
            },
          ),
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () {
              webViewController.goForward();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(
              url: WebUri("https://m.shein.com/ar/"),
            ),
            onWebViewCreated: (controller) {
              webViewController = controller;
            },
            onLoadStop: (controller, url) async {
              // التحقق إذا كانت صفحة منتج
              final hasDetail = await controller.evaluateJavascript(
                source: """
                  document.getElementById('detail-view') != null;
                """,
              );

              await controller.evaluateJavascript(
                source: """
            var footer = document.querySelector('.index-footer.j-index-footer');
            if (footer) {
              footer.style.display = 'none';
            }
          """,
              );

              // إخفاء العناصر غير المرغوب بها
              await controller.evaluateJavascript(
                source: """
                const hideByClass = (className) => {
                  const el = document.querySelector('.' + className);
                  if (el) el.style.display = 'none';
                };

                hideByClass('bsc-common-header__left');
                hideByClass('bsc-common-header__right');
                hideByClass('index-footer');
                hideByClass('j-index-footer');
                hideByClass('quick-cart-tip');
                hideByClass('quick-cart-tip_');
              """,
              );

              setState(() {
                isProductPage =
                    hasDetail == true || hasDetail.toString().contains("true");
              });
            },
          ),

          // زر "إضافة إلى السلة"
          if (isProductPage)
            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton.extended(
                onPressed: () async {
                  // جلب بيانات المنتج
                  final name = await webViewController.evaluateJavascript(
                    source:
                        "document.getElementById('detail-view')?.getAttribute('data-goods_name');",
                  );

                  final price = await webViewController.evaluateJavascript(
                    source:
                        "document.getElementById('detail-view')?.getAttribute('data-goods_ga_price');",
                  );

                  final productId = await webViewController.evaluateJavascript(
                    source:
                        "document.getElementById('detail-view')?.getAttribute('data-goods_id');",
                  );

                  if (context.mounted) {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Container(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '📦 المنتج: $name',
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                '💰 السعر: \$${price}',
                                style: TextStyle(fontSize: 16),
                              ),
                              Spacer(),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context); // إغلاق BottomSheet
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text('✅ تم إضافة المنتج'),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("🆔 المعرف: $productId"),
                                            Text("📦 الاسم: $name"),
                                            Text("💰 السعر: \$${price}"),
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed:
                                                () =>
                                                    Navigator.of(context).pop(),
                                            child: Text('تم'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Text('تأكيد الإضافة'),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
                label: Text('إضافة إلى السلة'),
                icon: Icon(Icons.shopping_cart),
              ),
            ),
        ],
      ),
    );
  }
}
