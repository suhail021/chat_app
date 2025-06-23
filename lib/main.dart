import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(home: SheinWebView()));
}

class SheinWebView extends StatefulWidget {
  @override
  _SheinWebViewState createState() => _SheinWebViewState();
}

class _SheinWebViewState extends State<SheinWebView> {
  InAppWebViewController? webViewController;

  final String sheinUrl = 'https://ar.shein.com/';
  // '[class*="icon"]',

  final String jsCode = """
    const selectorsToHide = [
    
      '.show-register-small',
      '.branch-first',
      '.header',
      '.site-nav',
      '.footer',
      '.site-footer',
      '.navbar',
      '.S-header-wrapper',
      '.cmp_c_1100',
      '.bsc-header-logo',
      '.common-header__wrap-right',
      '.quickg-inside',
      '.bsc-common-header__left',
      '.bsc-common-header__right',
      '.index-footer',
      '.j-index-footer',
      '.index-footer.j-index-footer',
      '.ft-li',
      '.j-index-tab-list',
      '.show-register',
      '.j-show-register',
      '.show-register-es',
      '.product-intro__add-cart',
      '.j-btn-add-to-bag-wrapper',
      '.NEW_BFF_COMPONENT',
      '.add-cart__animation-normal'
    ];

    function removeTargets() {
      selectorsToHide.forEach(selector => {
        document.querySelectorAll(selector).forEach(el => el.remove());
      });
    }

    removeTargets();

    const observer = new MutationObserver(mutations => {
      mutations.forEach(mutation => {
        mutation.addedNodes.forEach(node => {
          if (node.nodeType === 1) {
            selectorsToHide.forEach(selector => {
              if (node.matches(selector) || node.querySelector(selector)) {
                node.remove();
              }
            });
          }
        });
      });
    });

    observer.observe(document.body, {
      childList: true,
      subtree: true
    });

    var searchBar = document.querySelector('input[type="search"]');
    if (searchBar) {
      searchBar.style.marginTop = "50px";
      searchBar.style.width = "90%";
      searchBar.style.display = "block";
      searchBar.style.marginLeft = "auto";
      searchBar.style.marginRight = "auto";
    }
  """;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shein (معدل)"),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CartScreen()),
              );
            },
          ),
        ],
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri(sheinUrl)),
        initialSettings: InAppWebViewSettings(javaScriptEnabled: true),
        onWebViewCreated: (controller) {
          webViewController = controller;
        },
        onLoadStop: (controller, url) async {
          await controller.evaluateJavascript(source: jsCode);
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              tooltip: 'رجوع',
              onPressed: () async {
                if (await webViewController?.canGoBack() ?? false) {
                  webViewController?.goBack();
                }
              },
            ),
            IconButton(
              icon: Icon(Icons.refresh),
              tooltip: 'إعادة تحميل',
              onPressed: () {
                webViewController?.reload();
              },
            ),
            IconButton(
              icon: Icon(Icons.home),
              tooltip: 'الرئيسية',
              onPressed: () {
                webViewController?.loadUrl(
                  urlRequest: URLRequest(url: WebUri(sheinUrl)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Map<String, dynamic>> cartItems = [];

  @override
  void initState() {
    super.initState();
    loadCartItems();
  }

  Future<void> loadCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final items = prefs.getStringList('cart') ?? [];

    setState(() {
      cartItems =
          items.map((e) => Map<String, dynamic>.from(jsonDecode(e))).toList();
    });
  }

  Future<void> removeItem(int index) async {
    final prefs = await SharedPreferences.getInstance();
    cartItems.removeAt(index);
    final updated = cartItems.map((e) => jsonEncode(e)).toList();
    await prefs.setStringList('cart', updated);
    setState(() {});
  }

  double getTotalPrice() {
    double total = 0.0;
    for (var item in cartItems) {
      final priceString = item['price'].toString().replaceAll(
        RegExp(r'[^\d.]'),
        '',
      );
      final quantityString = item['quantity'].toString();
      final price = double.tryParse(priceString) ?? 0.0;
      final quantity = int.tryParse(quantityString) ?? 1;
      total += price * quantity;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('🛍 سلة المشتريات')),
      body:
          cartItems.isEmpty
              ? Center(child: Text('السلة فارغة'))
              : ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: ListTile(
                      title: Text(item['name'] ?? ''),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('السعر: ${item['price']}'),
                          Text('اللون: ${item['color']}'),
                          Text('المقاس: ${item['size']}'),
                          Text('الكمية: ${item['quantity']}'),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => removeItem(index),
                      ),
                    ),
                  );
                },
              ),
      bottomNavigationBar:
          cartItems.isEmpty
              ? null
              : BottomAppBar(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'السعر الإجمالي: \$${getTotalPrice().toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
    );
  }
}
