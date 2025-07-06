import 'package:flutter/material.dart';
import 'package:google/features/home/view/widgets/custome_image_shein.dart';

// الصفحات الوهمية التي سنعرضها حسب المؤشر

// الصفحة الرئيسية مع الـ Bottom Navigation
class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 2;

  List<IconData> icons = [
    Icons.bookmark_border,
    Icons.shopping_cart_outlined,
    Icons.favorite_border,
    Icons.person_outline,
  ];

  final List<Widget> pages = [
    CustomeImageShein(),
    CustomeImageShein(),
    CustomeImageShein(),
    CustomeImageShein(),
    CustomeImageShein(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.favorite, color: Colors.white),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.notification_important_outlined,
                color: Colors.white,
              ),
            ),
            Spacer(),
            Image.asset(
              "assets/images/shein-logo.png",
              color: Colors.white,
              fit: BoxFit.contain,
              width: 110,
            ),
            Spacer(),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.shopping_cart, color: Colors.white),
            ),
          ],
        ),
      ),
      body: pages[_selectedIndex], // عرض الصفحة حسب المؤشر
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        shape: CircularNotchedRectangle(),
        padding: EdgeInsets.zero,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 400),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Color(0xff101214),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(icons.length + 1, (index) {
              if (index == 2) return SizedBox(width: 50); // مساحة للزر العائم
              int iconIndex = index > 2 ? index - 1 : index;
              int pageIndex = index > 2 ? index : index;
              return TweenAnimationBuilder<double>(
                tween: Tween<double>(
                  begin: _selectedIndex == pageIndex ? 1.0 : 0.8,
                  end: _selectedIndex == pageIndex ? 1.2 : 1.0,
                ),
                duration: Duration(milliseconds: 300),
                curve: Curves.easeOut,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: IconButton(
                      icon: Icon(
                        icons[iconIndex],
                        color:
                            _selectedIndex == pageIndex
                                ? Colors.white
                                : Colors.grey,
                      ),
                      onPressed:
                          () => setState(() => _selectedIndex = pageIndex),
                    ),
                  );
                },
              );
            }),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOutBack,
        height: _selectedIndex == 2 ? 60 : 56,
        width: _selectedIndex == 2 ? 60 : 56,
        child: FloatingActionButton(
          backgroundColor: Color(0xffDB3719),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          onPressed: () => setState(() => _selectedIndex = 2),
          child: Icon(Icons.home, color: Colors.white),
        ),
      ),
    );
  }
}
