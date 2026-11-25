import 'package:flutter/material.dart';
import 'theme.dart';
import 'supabase_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SensoSupabase.initialize();
  runApp(const SensoManagerApp());
}

class SensoManagerApp extends StatelessWidget {
  const SensoManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: sensoTheme(),
      home: const ManagerHome(),
    );
  }
}

class ManagerHome extends StatefulWidget {
  const ManagerHome({super.key});

  @override
  State<ManagerHome> createState() => _ManagerHomeState();
}

class _ManagerHomeState extends State<ManagerHome> {
  int selectedIndex = 0;

  final pages = const [
    OverviewPage(),
    OrdersPage(),
    InventoryPage(),
    ReportsPage(),
  ];

  final titles = [
    'داشبورد مدیریت',
    'سفارش‌ها',
    'انبار',
    'گزارش‌ها',
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(titles[selectedIndex]),
        ),
        body: pages[selectedIndex],
        bottomNavigationBar: NavigationBar(
          backgroundColor: sensoPanel,
          selectedIndex: selectedIndex,
          onDestinationSelected: (index) {
            setState(() => selectedIndex = index);
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.dashboard),
              label: 'خانه',
            ),
            NavigationDestination(
              icon: Icon(Icons.receipt_long),
              label: 'سفارش‌ها',
            ),
            NavigationDestination(
              icon: Icon(Icons.inventory),
              label: 'انبار',
            ),
            NavigationDestination(
              icon: Icon(Icons.bar_chart),
              label: 'گزارش‌ها',
            ),
          ],
        ),
      ),
    );
  }
}

class OverviewPage extends StatelessWidget {
  const OverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Center(child: sensoBrand(size: 30)),
        const SizedBox(height: 25),
        const Text(
          'خوش آمدید به مدیریت سنسو',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.35,
          children: [
            metricCard('فروش امروز', '۲۸,۷۵۰,۰۰۰', Icons.payments),
            metricCard('تعداد سفارش', '۱۶۳', Icons.receipt_long),
            metricCard('موجودی کالا', '۲۴۸', Icons.inventory),
            metricCard('هزینه‌ها', '۴,۵۰۰,۰۰۰', Icons.money_off),
          ],
        ),
      ],
    );
  }
}

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = [
      ['#1001', 'میز ۱', '۲۵۰,۰۰۰ تومان', 'در حال آماده‌سازی'],
      ['#1002', 'میز ۳', '۱۸۰,۰۰۰ تومان', 'تکمیل شده'],
      ['#1003', 'بیرون‌بر', '۳۲۰,۰۰۰ تومان', 'در انتظار'],
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        sectionTitle('آخرین سفارش‌ها'),
        for (final order in orders)
          Card(
            child: ListTile(
              leading: const Icon(Icons.receipt, color: sensoGold),
              title: Text('سفارش ${order[0]}'),
              subtitle: Text('${order[1]} • ${order[2]}'),
              trailing: Text(
                order[3],
                style: const TextStyle(color: sensoGold, fontSize: 11),
              ),
            ),
          ),
      ],
    );
  }
}

class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      ['قهوه اسپرسو', '۵ کیلوگرم'],
      ['شیر', '۱۲ لیتر'],
      ['شکلات', '۳ کیلوگرم'],
      ['لیوان بیرون‌بر', '۱۵۰ عدد'],
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        sectionTitle('موجودی انبار'),
        for (final item in items)
          Card(
            child: ListTile(
              leading: const Icon(Icons.inventory, color: sensoGold),
              title: Text(item[0]),
              trailing: Text(item[1]),
            ),
          ),
      ],
    );
  }
}

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        sectionTitle('گزارش‌های مدیریتی'),
        metricCard('فروش ماه', '۳۸۵,۰۰۰,۰۰۰', Icons.trending_up),
        metricCard('سفارش‌های ماه', '۲,۴۸۰', Icons.receipt_long),
        metricCard('هزینه ماه', '۷۵,۰۰۰,۰۰۰', Icons.money_off),
        const Text(
          'اطلاعات این بخش در حال حاضر نمایشی هستند.',
          style: TextStyle(color: sensoMuted),
        ),
      ],
    );
  }
}
