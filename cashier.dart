import 'package:flutter/material.dart';
import 'theme.dart';

void main() => runApp(const SensoCashierApp());

class SensoCashierApp extends StatelessWidget {
  const SensoCashierApp({super.key});
  @override Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false, theme: sensoTheme(),
    home: const CashierHome(),
  );
}

class Product {
  final String name; final int price; final IconData icon;
  const Product(this.name, this.price, this.icon);
}

class CashierHome extends StatefulWidget {
  const CashierHome({super.key});
  @override State<CashierHome> createState() => _CashierHomeState();
}

class _CashierHomeState extends State<CashierHome> {
  final products = const [
    Product('اسپرسو', 80000, Icons.coffee),
    Product('لاته', 90000, Icons.local_cafe),
    Product('کاپوچینو', 90000, Icons.coffee_maker),
    Product('چیزکیک', 120000, Icons.cake),
    Product('شکلات داغ', 85000, Icons.local_drink),
    Product('کیک شکلاتی', 110000, Icons.bakery_dining),
  ];
  final Map<Product, int> cart = {};
  int get total => cart.entries.fold(0, (s, e) => s + e.key.price * e.value);
  String category = 'همه';

  @override Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: sensoBrand(size: 23),
      actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.menu))]),
    body: Column(children: [
      Padding(padding: const EdgeInsets.fromLTRB(14, 8, 14, 12), child: Row(children: [
        Expanded(child: _pill('میز ۳', Icons.table_restaurant)),
        const SizedBox(width: 8),
        Expanded(child: _pill('صندوق‌دار: کاربر نمونه', Icons.person)),
      ])),
      SizedBox(height: 42, child: ListView(scrollDirection: Axis.horizontal, children: [
        for (final c in ['همه','نوشیدنی','دسر','غذا','ویژه'])
          Padding(padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(label: Text(c), selected: category == c,
              selectedColor: sensoGold, onSelected: (_) => setState(() => category = c))),
      ])),
      Expanded(child: GridView.builder(
        padding: const EdgeInsets.all(12), itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, childAspectRatio: 1.28, crossAxisSpacing: 10, mainAxisSpacing: 10),
        itemBuilder: (_, i) {
          final p = products[i];
          return Card(child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () => setState(() => cart[p] = (cart[p] ?? 0) + 1),
            child: Padding(padding: const EdgeInsets.all(12), child: Column(
              mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(p.icon, color: sensoGold, size: 35),
                const SizedBox(height: 8),
                Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('${_money(p.price)} تومان', style: const TextStyle(color: sensoMuted, fontSize: 12)),
                const SizedBox(height: 5),
                const Text('افزودن به سفارش', style: TextStyle(color: sensoGold, fontSize: 11)),
              ],
            )),
          ));
        },
      )),
      Container(color: sensoPanel, padding: const EdgeInsets.fromLTRB(14, 8, 14, 14),
        child: Column(children: [
          Row(children: [
            const Text('سبد سفارش', style: TextStyle(fontWeight: FontWeight.bold)),
            const Spacer(), Text('${cart.values.fold<int>(0, (a,b) => a+b)} قلم'),
            IconButton(onPressed: () => setState(cart.clear), icon: const Icon(Icons.delete_outline, color: Colors.redAccent)),
          ]),
          if (cart.isEmpty)
            const Padding(padding: EdgeInsets.all(8), child: Text('برای شروع، یک محصول انتخاب کنید', style: TextStyle(color: sensoMuted)))
          else
            ...cart.entries.map((e) => Row(children: [
              Expanded(child: Text(e.key.name)),
              IconButton(onPressed: () => setState(() {
                if (e.value <= 1) { cart.remove(e.key); } else { cart[e.key] = e.value - 1; }
              }), icon: const Icon(Icons.remove_circle_outline, size: 20)),
              Text('${e.value}'),
              IconButton(onPressed: () => setState(() => cart[e.key] = e.value + 1),
                icon: const Icon(Icons.add_circle_outline, size: 20, color: sensoGold)),
              const SizedBox(width: 8),
              Text(_money(e.key.price * e.value)),
            ])),
          const Divider(color: Colors.white24),
          Row(children: [
            const Text('جمع کل', style: TextStyle(fontSize: 16)),
            const Spacer(), Text('${_money(total)} تومان',
              style: const TextStyle(color: sensoGold, fontSize: 19, fontWeight: FontWeight.bold)),
          ]),
          const SizedBox(height: 10),
          SizedBox(width: double.infinity, height: 48, child: FilledButton(
            style: FilledButton.styleFrom(backgroundColor: sensoGold, foregroundColor: sensoBlack),
            onPressed: cart.isEmpty ? null : () => _checkout(),
            child: const Text('ثبت سفارش', style: TextStyle(fontWeight: FontWeight.bold)),
          )),
        ]),
      ),
    ]),
  );

  Widget _pill(String text, IconData icon) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
    decoration: BoxDecoration(color: sensoPanel, borderRadius: BorderRadius.circular(14)),
    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(icon, color: sensoGold, size: 18), const SizedBox(width: 6),
      Flexible(child: Text(text, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12))),
    ]),
  );

  void _checkout() {
    showDialog(context: context, builder: (_) => AlertDialog(
      backgroundColor: sensoPanel, title: const Text('سفارش ثبت آزمایشی شد'),
      content: Text('مبلغ ${_money(total)} تومان\nاین نسخه هنوز به سرور مرکزی متصل نیست.'),
      actions: [TextButton(onPressed: () {
        Navigator.pop(context); setState(cart.clear);
      }, child: const Text('متوجه شدم', style: TextStyle(color: sensoGold)))],
    ));
  }
  String _money(int n) => n.toString().replaceAllMapped(
    RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
}
