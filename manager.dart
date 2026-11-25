import 'package:flutter/material.dart';
import 'theme.dart';

void main() => runApp(const SensoManagerApp());

class SensoManagerApp extends StatelessWidget {
  const SensoManagerApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false, theme: sensoTheme(),
    home: const ManagerHome(),
  );
}

class ManagerHome extends StatefulWidget {
  const ManagerHome({super.key});
  @override State<ManagerHome> createState() => _ManagerHomeState();
}

class _ManagerHomeState extends State<ManagerHome> {
  int tab = 0;
  final pages = const ['نمای کلی', 'سفارش‌ها', 'انبار', 'گزارش‌ها'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
        title: sensoBrand(size: 23),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none))],
      ),
      body: SafeArea(child: IndexedStack(index: tab, children: [
        _dashboard(), _orders(), _inventory(), _reports(),
      ])),
      bottomNavigationBar: NavigationBar(
        backgroundColor: sensoPanel, indicatorColor: sensoGold.withOpacity(.22),
        selectedIndex: tab,
        onDestinationSelected: (v) => setState(() => tab = v),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'خانه'),
          NavigationDestination(icon: Icon(Icons.receipt_long), label: 'سفارش‌ها'),
          NavigationDestination(icon: Icon(Icons.inventory_2_outlined), label: 'انبار'),
          NavigationDestination(icon: Icon(Icons.bar_chart), label: 'گزارش‌ها'),
        ],
      ),
    );
  }

  Widget _dashboard() => ListView(padding: const EdgeInsets.all(16), children: [
    const Text('سلام، مدیر سنسو', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
    const Text('وضعیت کافه در یک نگاه', style: TextStyle(color: sensoMuted)),
    const SizedBox(height: 18),
    GridView.count(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 1.35,
      children: [
        metricCard('فروش امروز', '۲۸,۷۵۰,۰۰۰', Icons.payments_outlined, hint: 'تومان'),
        metricCard('سفارش‌های امروز', '۱۶۳', Icons.receipt_long),
        metricCard('سفارش‌های باز', '۱۲', Icons.pending_actions),
        metricCard('موجودی کم', '۴ قلم', Icons.warning_amber_rounded),
      ]),
    sectionTitle('مدیریت کافه'),
    GridView.count(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3, crossAxisSpacing: 9, mainAxisSpacing: 9, childAspectRatio: .95,
      children: [
        _tile(Icons.point_of_sale, 'صندوق و فروش'),
        _tile(Icons.table_restaurant, 'مدیریت میزها'),
        _tile(Icons.qr_code_2, 'سفارش QR'),
        _tile(Icons.inventory, 'مدیریت انبار'),
        _tile(Icons.groups, 'مدیریت کاربران'),
        _tile(Icons.account_balance_wallet, 'امور مالی'),
        _tile(Icons.menu_book, 'مدیریت منو'),
        _tile(Icons.storefront, 'کانال‌های فروش'),
        _tile(Icons.settings, 'تنظیمات'),
      ]),
    const SizedBox(height: 12),
    Card(child: ListTile(
      leading: const Icon(Icons.security, color: sensoGold),
      title: const Text('دسترسی مدیر اصلی'),
      subtitle: const Text('مدیریت کاربران، گزارش‌ها و تنظیمات سیستم'),
      trailing: const Icon(Icons.chevron_left),
    )),
  ]);

  Widget _tile(IconData icon, String label) => Card(
    child: InkWell(
      borderRadius: BorderRadius.circular(18), onTap: () {},
      child: Padding(padding: const EdgeInsets.all(8), child: Column(
        mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, color: sensoGold, size: 29),
          const SizedBox(height: 9),
          Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      )),
    ),
  );

  Widget _orders() => ListView(padding: const EdgeInsets.all(16), children: [
    sectionTitle('سفارش‌های اخیر', trailing: 'نمایشی'),
    for (final item in [
      ['میز ۳', 'کاپوچینو، چیزکیک', 'در حال آماده‌سازی'],
      ['میز ۵', 'لاته، کیک شکلاتی', 'در انتظار تأیید'],
      ['بیرون‌بر', 'اسپرسو', 'آماده تحویل'],
    ]) Card(child: ListTile(
      leading: const CircleAvatar(backgroundColor: sensoGold, child: Icon(Icons.receipt, color: sensoBlack)),
      title: Text(item[0]), subtitle: Text(item[1]),
      trailing: Text(item[2], style: const TextStyle(color: sensoGold, fontSize: 11)),
    )),
  ]);

  Widget _inventory() => ListView(padding: const EdgeInsets.all(16), children: [
    sectionTitle('موجودی انبار', trailing: 'اطلاعات نمونه'),
    for (final row in [['دانه قهوه','۸ کیلوگرم'],['شیر','۱۲ لیتر'],['شربت وانیل','۳ بطری'],['لیوان بیرون‌بر','۲۵۰ عدد']])
      Card(child: ListTile(leading: const Icon(Icons.inventory_2, color: sensoGold),
        title: Text(row[0]), trailing: Text(row[1]))),
  ]);

  Widget _reports() => ListView(padding: const EdgeInsets.all(16), children: [
    sectionTitle('گزارش‌های مالی'),
    metricCard('فروش این ماه', '—', Icons.trending_up, hint: 'پس از اتصال پایگاه داده نمایش داده می‌شود'),
    metricCard('هزینه‌ها و سود خالص', '—', Icons.account_balance_wallet),
    const Card(child: Padding(padding: EdgeInsets.all(16),
      child: Text('گزارش‌های واقعی پس از راه‌اندازی پایگاه داده و ثبت تراکنش‌ها فعال می‌شوند.',
        style: TextStyle(color: sensoMuted)))),
  ]);
}
