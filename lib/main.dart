
import 'package:flutter/material.dart';
import 'dart:async';

// -----------------------------
// Product model
// -----------------------------
class Product {
  final String id;
  final String name;
  final String desc;
  final double price;
  final String assetImage;

  Product({
    required this.id,
    required this.name,
    required this.desc,
    required this.price,
    required this.assetImage,
  });
}

// -----------------------------
// Entry point
// -----------------------------
void main() {
  runApp(const ShiyakahApp());
}

// -----------------------------
// App (single source of truth for state)
// -----------------------------
class ShiyakahApp extends StatefulWidget {
  const ShiyakahApp({super.key});

  @override
  State<ShiyakahApp> createState() => _ShiyakahAppState();
}

class _ShiyakahAppState extends State<ShiyakahApp> {
  // App-wide state
  bool isDark = true;
  bool showSplash = true;
  bool loggedIn = false; // controls whether to show login or main UI

  // logos and theme accents
  final List<String> logos = [
    'images/file_000000002d606246adeaab98f3346e0e.png',
    'assets/images/logo2.png',
  ];
  int selectedLogoIndex = 0;

  final List<Color> lightAccents = [
    const Color(0xFFD6A85A),
    const Color(0xFF7A5C44),
    const Color(0xFFA7A47B),
  ];
  int lightAccentIndex = 0;

  // products and cart
  late final List<Product> products;
  final List<Product> cart = [];

  @override
  void initState() {
    super.initState();
    // sample products
    products = [
      Product(
        id: 'p1',
        name: 'ثوب كلاسيك أبيض',
        desc: 'ثوب راقٍ للمناسبات الرسمية، خامة ناعمة ولمسة فاخرة.',
        price: 249.99,
        assetImage: 'images/laundry.png',
      ),
      Product(
        id: 'p2',
        name: 'تيشرت ',
        desc: 'تيشرت بقصة كلاسيكية للظهور بمظهر انيق.',
        price: 179.50,
        assetImage: 'images/tshirt.png',
      ),
      Product(
        id: 'p3',
        name: 'قميص أزرق قطن',
        desc: 'قميص رسمي مريح مناسب للعمل والمقابلات.',
        price: 89.00,
        assetImage: 'images/cloth.png',
      ),
      Product(
        id: 'p4',
        name: 'جاكيت جلد ',
        desc: 'جاكيت كلاسيكي بلمسة عصرية ولمعان طبيعي.',
        price: 320.00,
        assetImage: 'images/man (1).png',
      ),
      Product(
        id: 'p5',
        name: 'تنورة  طويلة',
        desc: 'تنورة أنثوية ناعمة تناسب الإطلالات اليومية.',
        price: 120.00,
        assetImage: 'images/skirt.png',
      ),
    ];

    // show splash shortly then hide (handled by state)
    Timer(const Duration(milliseconds: 900), () {
      if (mounted) {
        setState(() {
          showSplash = false;
        });
      }
    });
  }

  // Cart ops
  void addToCart(Product p) {
    setState(() {
      cart.add(p);
    });
  }

  void removeFromCartAt(int idx) {
    setState(() {
      cart.removeAt(idx);
    });
  }

  void clearCart() {
    setState(() {
      cart.clear();
    });
  }

  double cartTotal() => cart.fold(0.0, (s, e) => s + e.price);

  // theme/logo setters
  void setDark(bool v) => setState(() => isDark = v);
  void toggleDark() => setState(() => isDark = !isDark);

  void setLightAccentIndex(int i) => setState(() => lightAccentIndex = i);
  void setSelectedLogoIndex(int i) => setState(() => selectedLogoIndex = i);

  // login/logout
  void doLogin() => setState(() => loggedIn = true);
  void doLogout() {
    setState(() {
      loggedIn = false;
      cart.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color gold = const Color(0xFFE4B86F);
    final Color navy = const Color(0xFF0A1A2F);
    final Color beige = const Color(0xFFF3E8D7);
    final Color accent = isDark ? gold : lightAccents[lightAccentIndex];

    final ThemeData theme = ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
      scaffoldBackgroundColor: isDark ? navy : beige,
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? navy : accent,
        foregroundColor: isDark ? gold : Colors.white,
      ),
      colorScheme: (isDark
              ? ColorScheme.dark(primary: accent, secondary: accent)
              : ColorScheme.light(primary: accent, secondary: accent))
          .copyWith(secondary: accent),
      textTheme: TextTheme(
        titleLarge: TextStyle(color: isDark ? gold : Colors.black87, fontWeight: FontWeight.bold, fontSize: 20),
        bodyLarge: TextStyle(color: isDark ? gold : Colors.black87),
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shiyakah Fashion',
      theme: theme,
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Builder(builder: (context) {
          // Splash -> Login -> Main controlled by state (no pushReplacement issues)
          if (showSplash) {
            return SplashScreen(logoAsset: logos[selectedLogoIndex], isDark: isDark);
          }
          if (!loggedIn) {
            return LoginScreen(onLoginSuccess: doLogin);
          }
          // logged in -> main scaffold, pass callbacks and current state
          return MainScaffold(
            products: products,
            addToCart: addToCart,
            removeFromCartAt: removeFromCartAt,
            cart: cart,
            cartTotalFunc: cartTotal,
            clearCart: clearCart,
            isDark: isDark,
            setDark: setDark,
            toggleDark: toggleDark,
            logos: logos,
            selectedLogoIndex: selectedLogoIndex,
            setSelectedLogoIndex: setSelectedLogoIndex,
            lightAccentIndex: lightAccentIndex,
            setLightAccentIndex: setLightAccentIndex,
            doLogout: doLogout,
          );
        }),
      ),
    );
  }
}

// -----------------------------
// SplashScreen (simple)
// -----------------------------
class SplashScreen extends StatelessWidget {
  final String logoAsset;
  final bool isDark;
  const SplashScreen({super.key, required this.logoAsset, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Container(
        color: theme.scaffoldBackgroundColor,
        child: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            SizedBox(
              width: 140,
              height: 140,
              child: Image.asset(logoAsset, fit: BoxFit.contain, errorBuilder: (_, __, ___) => Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(shape: BoxShape.circle, color: isDark ? Colors.white : Colors.black),
                child: Text('Shiyakah', style: TextStyle(color: isDark ? Colors.black : Colors.white, fontWeight: FontWeight.bold)),
              )),
            ),
            const SizedBox(height: 12),
            Text('شياكة للأزياء الجاهزة', style: theme.textTheme.titleLarge),
            const SizedBox(height: 12),
            const CircularProgressIndicator(),
          ]),
        ),
      ),
    );
  }
}

// -----------------------------
// LoginScreen
// -----------------------------
class LoginScreen extends StatefulWidget {
  final VoidCallback onLoginSuccess;
  const LoginScreen({super.key, required this.onLoginSuccess});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController userCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();
  String error = '';

  void tryLogin() {
    if (userCtrl.text == 'student' && passCtrl.text == '1234') {
      widget.onLoginSuccess();
    } else {
      setState(() => error = 'اسم المستخدم أو كلمة المرور غير صحيحة — جرب student / 1234');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('تسجيل الدخول')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(children: [
          const SizedBox(height: 6),
          TextField(controller: userCtrl, decoration: const InputDecoration(labelText: 'اسم المستخدم')),
          const SizedBox(height: 12),
          TextField(controller: passCtrl, obscureText: true, decoration: const InputDecoration(labelText: 'كلمة المرور')),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: tryLogin, child: const Padding(padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12), child: Text('دخول'))),
          if (error.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(error, style: const TextStyle(color: Colors.red)),
          ],
          const SizedBox(height: 18),
          const Text('للاختبار السريع: student / 1234'),
        ]),
      ),
    );
  }
}

// -----------------------------
// MainScaffold (BottomNav + Drawer)
// -----------------------------
class MainScaffold extends StatefulWidget {
  final List<Product> products;
  final void Function(Product) addToCart;
  final void Function(int) removeFromCartAt;
  final List<Product> cart;
  final double Function() cartTotalFunc;
  final VoidCallback clearCart;

  final bool isDark;
  final void Function(bool) setDark;
  final void Function() toggleDark;

  final List<String> logos;
  final int selectedLogoIndex;
  final void Function(int) setSelectedLogoIndex;
  final int lightAccentIndex;
  final void Function(int) setLightAccentIndex;

  final VoidCallback doLogout;

  const MainScaffold({
    super.key,
    required this.products,
    required this.addToCart,
    required this.removeFromCartAt,
    required this.cart,
    required this.cartTotalFunc,
    required this.clearCart,
    required this.isDark,
    required this.setDark,
    required this.toggleDark,
    required this.logos,
    required this.selectedLogoIndex,
    required this.setSelectedLogoIndex,
    required this.lightAccentIndex,
    required this.setLightAccentIndex,
    required this.doLogout,
  });

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}
class _MainScaffoldState extends State<MainScaffold> {
  int currentIndex = 0;

  void openCartPage() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => CartPage(
      cart: widget.cart,
      removeAt: widget.removeFromCartAt,
      clearCart: widget.clearCart,
      total: widget.cartTotalFunc(),
      accent: Theme.of(context).colorScheme.secondary,
    )));
  }

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.secondary;

    final pages = [
      HomePage(
        products: widget.products,
        onAdd: widget.addToCart,
        onOpen: (p) => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailsPage(product: p, onAddToCart: widget.addToCart, accent: accent))),
        accent: accent,
      ),
      SearchPage(
        products: widget.products,
        onOpen: (p) => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailsPage(product: p, onAddToCart: widget.addToCart, accent: accent))),
      ),
      // Cart tab shows a button to open full cart page
      Center(child: ElevatedButton(onPressed: openCartPage, style: ElevatedButton.styleFrom(backgroundColor: accent,foregroundColor: const Color.fromARGB(255, 0, 0, 0)), child: const Text('افتح السلة'))),
      SettingsPage(
        isDark: widget.isDark,
        setDark: widget.setDark,
        toggleDark: widget.toggleDark,
        lightAccentIndex: widget.lightAccentIndex,
        setLightAccentIndex: widget.setLightAccentIndex,
        logos: widget.logos,
        selectedLogoIndex: widget.selectedLogoIndex,
        setSelectedLogoIndex: widget.setSelectedLogoIndex,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(widget.logos[widget.selectedLogoIndex], height: 36, errorBuilder: (_, __, ___) => Text('Shiyakah', style: Theme.of(context).textTheme.titleLarge)),
        centerTitle: true,
        actions: [
          IconButton(onPressed: openCartPage, icon: Stack(
            children: [
              const Icon(Icons.shopping_bag_outlined),
              if (widget.cart.isNotEmpty)
                Positioned(right: 0, top: 0, child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: accent, borderRadius: BorderRadius.circular(12)),
                  child: Text('${widget.cart.length}', style: const TextStyle(color: Colors.white, fontSize: 12)),
                )),
            ],
          )),
        ],
      ),
      drawer: Drawer(
        child: Column(children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondary),
            child: Row(children: [
              SizedBox(width: 64, height: 64, child: Image.asset(widget.logos[widget.selectedLogoIndex], fit: BoxFit.contain, errorBuilder: (_, __, ___) => const Icon(Icons.store))),
              const SizedBox(width: 8),
              Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: const [
                Text('Shiyakah', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 6),
                Text('متجر الأزياء الفاخر', style: TextStyle(color: Colors.white70)),
              ]),
            ]),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('الملف الشخصي'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AccountScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.article),
            title: const Text('السيرة الذاتية (CV)'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CVPage()));
            },
          ),
          const Divider(),
          // Theme toggle in drawer: uses the setDark function passed from top-level
          SwitchListTile(
            value: widget.isDark,
            onChanged: (v) {
              widget.setDark(v);
              setState(() {}); // local refresh
            },
            title: const Text('  الوضع الليلي   '),
            secondary: const Icon(Icons.dark_mode),
          ),
          const Spacer(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('تسجيل خروج'),
            onTap: () {
              // logout centrally (top-level will show login again)
              widget.doLogout();
            },
          ),
        ]),
      ),
      body: Padding(padding: const EdgeInsets.all(12.0), child: pages[currentIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: accent,
        unselectedItemColor: Colors.grey,
        onTap: (i) => setState(() => currentIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'بحث'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'السلة'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'الإعدادات'),
        ],
      ),
    );
  }
}

// -----------------------------
// HomePage (Grid + List) using SingleChildScrollView for safe layout
// -----------------------------
class HomePage extends StatelessWidget {
  final List<Product> products;
  final void Function(Product) onAdd;
  final void Function(Product) onOpen;
  final Color accent;

  const HomePage({super.key, required this.products, required this.onAdd, required this.onOpen, required this.accent});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final cross = width > 700 ? 3 : 2;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('أحدث الأزياء', style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: 8),
      SizedBox(
        height: 320,
        child: GridView.builder(
          scrollDirection: Axis.horizontal,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1, childAspectRatio: 0.9),
          itemCount: products.length,
          itemBuilder: (context, i) {
            final p = products[i];
            return GestureDetector(
              onTap: () => onOpen(p),
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  Expanded(child: ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(12)), child: Image.asset(p.assetImage, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: Colors.grey)))),
                  Padding(padding: const EdgeInsets.all(8.0), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Expanded(child: Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold))), Text('${p.price.toStringAsFixed(2)} ر.س', style: TextStyle(color: accent, fontWeight: FontWeight.bold))])),
                ]),
              ),
            );
          },
        ),
      ),
      const SizedBox(height: 12),
      Text('مقترحات لك', style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: 8),
      Expanded(child: ListView.separated(itemCount: products.length, separatorBuilder: (_, __) => const Divider(), itemBuilder: (context, i) {
        final p = products[i];
        return ListTile(
          leading: SizedBox(width: 64, child: Image.asset(p.assetImage, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.image))),
          title: Text(p.name),
          subtitle: Text(p.desc),
          trailing: ElevatedButton(onPressed: () => onAdd(p), style: ElevatedButton.styleFrom(backgroundColor: accent), child: const Text('أضف')),
          onTap: () => onOpen(p),
        );
      })),
    ]);
  }
}

// -----------------------------
// SearchPage
// -----------------------------
class SearchPage extends StatefulWidget {
  final List<Product> products;
  final void Function(Product) onOpen;
  const SearchPage({super.key, required this.products, required this.onOpen});

  @override
  State<SearchPage> createState() => _SearchPageState();
}
class _SearchPageState extends State<SearchPage> {
  String q = '';

  @override
  Widget build(BuildContext context) {
    final filtered = widget.products.where((p) => p.name.toLowerCase().contains(q.toLowerCase()) || p.desc.toLowerCase().contains(q.toLowerCase())).toList();
    return Column(children: [
      TextField(decoration: InputDecoration(prefixIcon: const Icon(Icons.search), hintText: 'ابحث عن منتج...'), onChanged: (v) => setState(() => q = v)),
      const SizedBox(height: 8),
      Expanded(child: filtered.isEmpty ? const Center(child: Text('لا توجد نتائج')) : ListView.builder(itemCount: filtered.length, itemBuilder: (context, i) {
        final p = filtered[i];
        return ListTile(
          leading: SizedBox(width: 56, child: Image.asset(p.assetImage, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.image))),
          title: Text(p.name),
          subtitle: Text('${p.price.toStringAsFixed(2)} ر.س'),
          trailing: Icon(Icons.arrow_forward_ios, color: Theme.of(context).colorScheme.secondary),
          onTap: () => widget.onOpen(p),
        );
      }))
    ]);
  }
}

// -----------------------------
// ProductDetailsPage
// -----------------------------
class ProductDetailsPage extends StatelessWidget {
  final Product product;
  final void Function(Product) onAddToCart;
  final Color accent;
  const ProductDetailsPage({super.key, required this.product, required this.onAddToCart, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(children: [
        ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.asset(product.assetImage, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(height: 200, color: Colors.grey))),
        const SizedBox(height: 12),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(product.name, style: Theme.of(context).textTheme.titleLarge),
          Text('${product.price.toStringAsFixed(2)} ر.س', style: TextStyle(color: accent, fontWeight: FontWeight.bold)),
        ]),
        const SizedBox(height: 8),
        Text(product.desc),
        const SizedBox(height: 16),
        ElevatedButton.icon(onPressed: () { onAddToCart(product); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('أضيف ${product.name} إلى السلة'))); }, icon: const Icon(Icons.add_shopping_cart), label: const Text('أضف إلى السلة'), style: ElevatedButton.styleFrom(backgroundColor: accent,foregroundColor: const Color.fromARGB(255, 0, 0, 0 ))),
      ])),
    );
  }
}

// -----------------------------
// CartPage
// -----------------------------
class CartPage extends StatelessWidget {
  final List<Product> cart;
  final void Function(int) removeAt;
  final VoidCallback clearCart;
  final double total;
  final Color accent;

  const CartPage({super.key, required this.cart, required this.removeAt, required this.clearCart, required this.total, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('السلة')),
      body: cart.isEmpty ? Center(child: Text('السلة فارغة', style: Theme.of(context).textTheme.titleMedium)) : Column(children: [
        Expanded(child: ListView.separated(itemCount: cart.length, separatorBuilder: (_, __) => const Divider(), itemBuilder: (context, i) {
          final p = cart[i];
          return ListTile(
            leading: SizedBox(width: 56, child: Image.asset(p.assetImage, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.image))),
            title: Text(p.name),
            subtitle: Text('${p.price.toStringAsFixed(2)} ر.س'),
            trailing: IconButton(icon: const Icon(Icons.delete), onPressed: () { removeAt(i); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('حُذف ${p.name}'))); }),
          );
        })),
        Padding(padding: const EdgeInsets.all(12.0), child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('المجموع', style: Theme.of(context).textTheme.titleMedium), Text('${total.toStringAsFixed(2)} ر.س', style: TextStyle(color: accent, fontWeight: FontWeight.bold))]),
          const SizedBox(height: 8),
          Row(children: [Expanded(child: ElevatedButton(onPressed: () { clearCart(); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم إتمام الطلب (محاكاة)'))); Navigator.of(context).pop(); }, style: ElevatedButton.styleFrom(backgroundColor: accent,foregroundColor: const Color.fromARGB(255, 0, 0, 0)), child: const Text('إتمام الطلب')))]),
        ]))
      ]),
    );
  }
}

// -----------------------------
// SettingsPage (fixes: uses setDark and setSelectedLogoIndex from top-level)
// -----------------------------
class SettingsPage extends StatelessWidget {
  final bool isDark;
  final void Function(bool) setDark;
  final void Function() toggleDark;
  final int lightAccentIndex;
  final void Function(int) setLightAccentIndex;
  final List<String> logos;
  final int selectedLogoIndex;
  final void Function(int) setSelectedLogoIndex;

  const SettingsPage({
    super.key,
    required this.isDark,
    required this.setDark,
    required this.toggleDark,
    required this.lightAccentIndex,
    required this.setLightAccentIndex,
    required this.logos,
    required this.selectedLogoIndex,
    required this.setSelectedLogoIndex,
  });

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.secondary;
    return SingleChildScrollView(padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SwitchListTile(value: isDark, onChanged: (v) { setDark(v); }, title: const Text('الوضع الليلي'), secondary: const Icon(Icons.dark_mode)),
      const SizedBox(height: 12),
      Text('ألوان الوضع الفاتح', style: Theme.of(context).textTheme.titleMedium),
      const SizedBox(height: 8),
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: List.generate(3, (i) {
        final colors = [const Color(0xFFD6A85A), const Color(0xFF7A5C44), const Color(0xFFA7A47B)];
        final selected = i == lightAccentIndex;
        return GestureDetector(
          onTap: () => setLightAccentIndex(i),
          child: Container(width: selected ? 66 : 52, height: selected ? 66 : 52, decoration: BoxDecoration(color: colors[i], borderRadius: BorderRadius.circular(10), border: selected ? Border.all(color: Colors.black, width: 2) : null)),
        );
      })),
      const SizedBox(height: 14),
      const Text('اختيار الشعار', style: TextStyle(fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: List.generate(logos.length, (i) {
        final selected = i == selectedLogoIndex;
        return GestureDetector(
          onTap: () => setSelectedLogoIndex(i),
          child: Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(border: Border.all(color: selected ? accent : Colors.transparent, width: 2), borderRadius: BorderRadius.circular(8)), child: SizedBox(width: 80, height: 80, child: Image.asset(logos[i], fit: BoxFit.contain, errorBuilder: (_, __, ___) => const Icon(Icons.image)))),
        );
      })),
      const SizedBox(height: 16),
      ListTile(leading: const Icon(Icons.info_outline), title: const Text('عن التطبيق'), subtitle: const Text('Shiyakah Fashion - مشروع تدريبي متكامل')),
    ]));
  }
}

// -----------------------------
// AccountScreen (CV-like + TextField demo) - fixed to have Scaffold when navigated
// -----------------------------
class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}
class _AccountScreenState extends State<AccountScreen> {
  final TextEditingController nameCtrl = TextEditingController(text: 'أحمد سعد ');
  final TextEditingController emailCtrl = TextEditingController(text: 'email@shiyakah.com');
  final TextEditingController phoneCtrl = TextEditingController(text: '+966 5xxxxxxx');
  final TextEditingController t1 = TextEditingController();
  final TextEditingController t2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('الملف الشخصي')),
      body: SingleChildScrollView(padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const SizedBox(height: 8),
        const CircleAvatar(radius: 56, child: Icon(Icons.person, size: 56)),
        const SizedBox(height: 12),
        TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'الاسم')),
        const SizedBox(height: 8),
        TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'البريد')),
        const SizedBox(height: 8),
        TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: 'الهاتف')),
        const SizedBox(height: 12),
        ElevatedButton.icon(onPressed: () { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم حفظ البيانات (محاكاة)'))); }, icon: const Icon(Icons.save), label: const Text('حفظ')),
        const SizedBox(height: 18),
        const Divider(),
        const SizedBox(height: 8),
        Text(' TextField ', style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        TextField(controller: t1, decoration: const InputDecoration(labelText: 'اكتب هنا')),
        const SizedBox(height: 8),
        TextField(controller: t2, readOnly: true, decoration: const InputDecoration(labelText: 'الحقل الثاني (قراءة)')),
        const SizedBox(height: 10),
        Row(children: [
          Expanded(child: ElevatedButton(onPressed: () { setState(() { t2.text = t1.text; }); }, child: const Text('نسخ إلى الحقل الثاني'))),
          const SizedBox(width: 8),
          Expanded(child: ElevatedButton(onPressed: () { Navigator.push(context, MaterialPageRoute(builder: (_) => TextPassPage(text: t1.text))); }, child: const Text('اذهب بالمتغير'))),
        ]),
      ])),
    );
  }
}

// -----------------------------
// TextPassPage
// -----------------------------
class TextPassPage extends StatelessWidget {
  final String text;
  const TextPassPage({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('صفحة استقبال المتغير')), body: Center(child: Text(text.isEmpty ? 'لم يتم تمرير نص' : 'النص: $text', style: const TextStyle(fontSize: 20))));
  }
}

// -----------------------------
// CVPage (Scaffold included) - fixed
// -----------------------------
class CVPage extends StatelessWidget {
  const CVPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('السيرة الذاتية')),
      body: SingleChildScrollView(padding: const EdgeInsets.all(14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Center(child: Column(children: [const CircleAvatar(radius: 56, child: Icon(Icons.person, size: 56)), const SizedBox(height: 8), Text('الاسم: أحمد سعد', style: theme.textTheme.titleLarge), const SizedBox(height: 6), Text('مصمم أزياء', style: theme.textTheme.bodyLarge)])),
        const SizedBox(height: 14),
        const Divider(),
        const SizedBox(height: 10),
        const Text('نبذة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        const Text('مصمم أزياء متخصص في الملابس الجاهزة، يملك خبرة في تصميم تشكيلات عصرية ومتابعة خطوط الموضة.'),
        const SizedBox(height: 12),
        const Text('المهارات', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Wrap(spacing: 8, children: const [Chip(label: Text('elegance')), Chip(label: Text('Design')), Chip(label: Text('Tailoring'))]),
      ])),
    );
  }
}