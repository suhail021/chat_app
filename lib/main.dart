import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
          IconButton(icon: Icon(Icons.refresh), onPressed: () => webViewController.reload()),
          IconButton(icon: Icon(Icons.arrow_back), onPressed: () => webViewController.goBack()),
          IconButton(icon: Icon(Icons.arrow_forward), onPressed: () => webViewController.goForward()),
        ],
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri("https://m.shein.com/ar/")),
            onWebViewCreated: (controller) => webViewController = controller,
            onLoadStop: (controller, url) async {
              await Future.delayed(Duration(milliseconds: 500));
              final hasDetail = await controller.evaluateJavascript(source: "document.getElementById('detail-view') != null;");
              await controller.evaluateJavascript(source: """
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
              """);
              setState(() {
                isProductPage = hasDetail == true || hasDetail.toString().contains("true");
              });
            },
          ),

          if (isProductPage)
            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton.extended(
                onPressed: () async {
                  await webViewController.evaluateJavascript(source: """
                    var buyBtn = document.querySelector('.j-select-to-buy');
                    if (buyBtn) buyBtn.click();
                  """);
                  await Future.delayed(Duration(seconds: 1));

                  final name = await webViewController.evaluateJavascript(source: "document.getElementById('detail-view')?.getAttribute('data-goods_name');");
                  final price = await webViewController.evaluateJavascript(source: "document.getElementById('detail-view')?.getAttribute('data-goods_ga_price');");
                  final productId = await webViewController.evaluateJavascript(source: "document.getElementById('detail-view')?.getAttribute('data-goods_id');");

                  final selectedModel = await webViewController.evaluateJavascript(source: """
                    (function() {
                      var el = document.querySelector('.bs-color__item.active');
                      return el ? el.textContent.trim() : null;
                    })();
                  """);

                  final selectedColor = await webViewController.evaluateJavascript(source: """
                    (function() {
                      var el = document.querySelector('ul.choose-size[data-attr_id="27"] li.size-active');
                      return el ? el.getAttribute('aria-label') : null;
                    })();
                  """);

                  final selectedSize = await webViewController.evaluateJavascript(source: """
                    (function() {
                      var el = document.querySelector('ul.choose-size[data-attr_id="87"] li.size-active');
                      return el ? el.getAttribute('aria-label') : null;
                    })();
                  """);

                  final modelRequired = await webViewController.evaluateJavascript(source: "document.querySelector('.bs-color__item') != null;");
                  final colorRequired = await webViewController.evaluateJavascript(source: "document.querySelector('ul.choose-size[data-attr_id=\"27\"] li') != null;");
                  final sizeRequired = await webViewController.evaluateJavascript(source: "document.querySelector('ul.choose-size[data-attr_id=\"87\"] li') != null;");

                  if ((modelRequired == true && (selectedModel == null || selectedModel.toString().isEmpty)) ||
                      (colorRequired == true && (selectedColor == null || selectedColor.toString().isEmpty)) ||
                      (sizeRequired == true && (selectedSize == null || selectedSize.toString().isEmpty))) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("⚠️ يرجى اختيار نوع الموديل واللون والمقاس قبل الإضافة")),
                      );
                    }
                    return;
                  }

                  final imageUrl = await webViewController.evaluateJavascript(source: """
                    (function() {
                      var img = document.querySelector('.crop-image-container__img');
                      return img ? (img.getAttribute('data-src') || img.getAttribute('src')) : null;
                    })();
                  """);

                  int quantity = 1;
                  double total = double.tryParse(price.toString()) ?? 0;

                  if (context.mounted) {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(
                          builder: (context, setSheetState) {
                            return Padding(
                              padding: EdgeInsets.all(20),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (imageUrl != null && imageUrl.toString().isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 10),
                                        child: SizedBox(
                                          height: 120,
                                          width: double.infinity,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(12),
                                            child: CachedNetworkImage(
                                              imageUrl: imageUrl.toString().startsWith("http") ? imageUrl : "https:${imageUrl.toString()}",
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) => Container(color: Colors.grey[200], child: Center(child: CircularProgressIndicator())),
                                              errorWidget: (context, url, error) => Container(color: Colors.grey[300], child: Icon(Icons.error, color: Colors.red)),
                                            ),
                                          ),
                                        ),
                                      ),
                                    Text("📦 الاسم: $name", style: TextStyle(fontSize: 18)),
                                    Text("💰 السعر: \$${price}", style: TextStyle(fontSize: 16)),
                                    if (selectedModel != null) Text("🧥 الموديل: $selectedModel", style: TextStyle(fontSize: 16)),
                                    if (selectedColor != null) Text("🎨 اللون: $selectedColor", style: TextStyle(fontSize: 16)),
                                    if (selectedSize != null) Text("📏 المقاس: $selectedSize", style: TextStyle(fontSize: 16)),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Text("🔢 الكمية:"),
                                        IconButton(onPressed: () { if (quantity > 1) setSheetState(() => quantity--); }, icon: Icon(Icons.remove)),
                                        Text(quantity.toString()),
                                        IconButton(onPressed: () => setSheetState(() => quantity++), icon: Icon(Icons.add)),
                                      ],
                                    ),
                                    Text("💵 السعر الكلي: \$${(quantity * total).toStringAsFixed(2)}"),
                                    SizedBox(height: 30),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                            title: Text("✅ تم الإضافة"),
                                            content: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                if (imageUrl != null && imageUrl.toString().isNotEmpty)
                                                  Padding(
                                                    padding: const EdgeInsets.only(bottom: 10),
                                                    child: SizedBox(
                                                      height: 120,
                                                      width: double.infinity,
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(10),
                                                        child: CachedNetworkImage(
                                                          imageUrl: imageUrl.toString().startsWith("http") ? imageUrl : "https:${imageUrl.toString()}",
                                                          fit: BoxFit.cover,
                                                          placeholder: (context, url) => Container(color: Colors.grey[200], child: Center(child: CircularProgressIndicator())),
                                                          errorWidget: (context, url, error) => Container(color: Colors.grey[300], child: Icon(Icons.error, color: Colors.red)),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                Text("🆔 المعرف: $productId"),
                                                Text("📦 الاسم: $name"),
                                                Text("💰 السعر: \$${price}"),
                                                if (selectedModel != null) Text("🧥 الموديل: $selectedModel"),
                                                if (selectedColor != null) Text("🎨 اللون: $selectedColor"),
                                                if (selectedSize != null) Text("📏 المقاس: $selectedSize"),
                                                Text("🔢 الكمية: $quantity"),
                                                Text("💵 السعر الكلي: \$${(total * quantity).toStringAsFixed(2)}"),
                                              ],
                                            ),
                                            actions: [TextButton(onPressed: () {}, child: Text("موافق"))],
                                          ),
                                        );
                                      },
                                      child: Text("تأكيد الإضافة"),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
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