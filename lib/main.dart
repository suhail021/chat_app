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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("SHEIN")),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri("https://m.shein.com/ar/")),
        onWebViewCreated: (controller) {
          webViewController = controller;
        },
        onLoadStop: (controller, url) async {
          // تحقق إن الصفحة تحتوي على detail-view
          final hasDetail = await controller.evaluateJavascript(
            source: """
    document.getElementById('detail-view') != null;
  """,
          );

          if (hasDetail == true || hasDetail.toString().contains("true")) {
            // استخراج بيانات المنتج
            final name = await controller.evaluateJavascript(
              source: """
      document.getElementById('detail-view')?.getAttribute('data-goods_name');
    """,
            );

            final price = await controller.evaluateJavascript(
              source: """
      document.getElementById('detail-view')?.getAttribute('data-goods_ga_price');
    """,
            );

            final productId = await controller.evaluateJavascript(
              source: """
      document.getElementById('detail-view')?.getAttribute('data-goods_id');
    """,
            );

            print("✅ الاسم: \$name");
            print("💰 السعر: \$price");
            print("🆔 المعرف: \$productId");

            // الآن يمكنك عرض زر "إضافة إلى السلة"
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return Container(
                  padding: EdgeInsets.all(20),
                  height: 150,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('المنتج: $name', style: TextStyle(fontSize: 18)),
                      Text('السعر: \$${price}', style: TextStyle(fontSize: 16)),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("🆔 المعرف: $productId"),
                                    Text("📦 الاسم: $name"),
                                    Text("💰 السعر: \$${price}"),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed:
                                        () => Navigator.of(context).pop(),
                                    child: Text('تم'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Text('إضافة إلى السلة'),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
