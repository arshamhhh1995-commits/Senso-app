import 'package:flutter/material.dart';
import 'theme.dart';

void main() => runApp(const SensoCashierApp());

class SensoCashierApp extends StatelessWidget {
  const SensoCashierApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: sensoTheme(),
      home: const CashierHome(),
    );
  }
}

class Product {
  final String name;
  final int price;
  final IconData icon;

  const Product(this.name, this.price, this.icon);
}

class CashierHome extends StatefulWidget {
  const CashierHome({super.key});

  @override
  State<CashierHome> createState() => _CashierHomeState();
}

class _CashierHomeState extends State<CashierHome> {
  final products = const [
    Product('اسپرسو', 65000, Icons.coffee),
    Product('لاته', 95000, Icons.local_cafe),
    Product('کاپوچینو', 85000, Icons.coffee_maker),
    Product('چیزکیک', 120000, Icons.cake),
    Product('شکلات داغ', 90000, Icons.local_drink),
    Product('کیک شکلاتی', 110000, Icons.bakery_dining),
  ];

  final Map<Product, int> cart = {};

  int get total {
    int sum = 0;
    cart.forEach((product, count) {
      sum += product.price * count;
    });
    return sum;
  }

  String money(int value) {
    return value.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => ',',
    );
  }

  void add(Product product) {
    setState(() {
      cart[product] = (cart[product] ?? 0) + 1;
    });
  }

  void remove(Product product) {
    setState(() {
      if (!cart.containsKey(product)) return;

      if (cart[product] == 1) {
        cart.remove(product);
      } else {
        cart[product] = cart[product]! - 1;
      }
    });
  }

  void checkout() {
    if (cart.isEmpty) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: sensoPanel,
        title: const Text('ثبت سفارش'),
        content: Text(
          'مبلغ سفارش: ${money(total)} تومان\n\n'
          'این نسخه هنوز به سرور مرکزی متصل نیست؛ '
          'ثبت سفارش واقعی انجام نمی‌شود.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('بازگشت'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => cart.clear());
            },
            child: const Text('متوجه شدم'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('صندوق‌داری سنسو'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            const SizedBox(height: 12),
            sensoBrand(size: 25),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'انتخاب محصولات',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: products.length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.25,
                ),
                itemBuilder: (context, index) {
                  final product = products[index];
                  final count = cart[product] ?? 0;

                  return Card(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () => add(product),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              product.icon,
                              color: sensoGold,
                              size: 32,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              product.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              '${money(product.price)} تومان',
                              style: const TextStyle(
                                color: sensoGold,
                                fontSize: 12,
                              ),
                            ),
                            if (count > 0)
                              Text('تعداد: $count'),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: sensoPanel,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(22),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('مبلغ کل'),
                      Text(
                        '${money(total)} تومان',
                        style: const TextStyle(
                          color: sensoGold,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (cart.isNotEmpty)
                    ...cart.entries.map(
                      (entry) => Row(
                        children: [
                          Expanded(child: Text(entry.key.name)),
                          IconButton(
                            onPressed: () => remove(entry.key),
                            icon: const Icon(Icons.remove_circle_outline),
                          ),
                          Text('${entry.value}'),
                          IconButton(
                            onPressed: () => add(entry.key),
                            icon: const Icon(Icons.add_circle_outline),
                          ),
                        ],
                      ),
                    ),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: cart.isEmpty ? null : checkout,
                      icon: const Icon(Icons.receipt_long),
                      label: const Text('ثبت سفارش'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
