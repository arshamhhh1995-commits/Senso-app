import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_config.dart';

class SensoUser {
  final String id;
  final String fullName;
  final String role;
  final bool isActive;

  SensoUser({
    required this.id,
    required this.fullName,
    required this.role,
    required this.isActive,
  });

  bool get isManager => role == 'manager';
  bool get isCashier => role == 'cashier';
}

class SensoAuthService {
  static SupabaseClient get client => SensoSupabase.client;

  static Future<SensoUser> signIn({
    required String email,
    required String password,
  }) async {
    final response = await client.auth.signInWithPassword(
      email: email.trim(),
      password: password,
    );

    final user = response.user;

    if (user == null) {
      throw Exception('ورود ناموفق بود.');
    }

    final profile = await client
        .from('profiles')
        .select('id, full_name, role, is_active')
        .eq('id', user.id)
        .maybeSingle();

    if (profile == null) {
      await client.auth.signOut();
      throw Exception('پروفایل کاربر پیدا نشد.');
    }

    final active = profile['is_active'] == true;
    final role = profile['role']?.toString();

    if (!active || (role != 'manager' && role != 'cashier')) {
      await client.auth.signOut();
      throw Exception('حساب کاربری غیرفعال یا فاقد دسترسی است.');
    }

    return SensoUser(
      id: user.id,
      fullName: profile['full_name']?.toString() ?? '',
      role: role!,
      isActive: active,
    );
  }

  static Future<void> signOut() async {
    await client.auth.signOut();
  }

  static User? get currentUser => client.auth.currentUser;
}
