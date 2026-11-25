import 'package:supabase_flutter/supabase_flutter.dart';

class SensoSupabase {
  static const String url =
      'https://poibfekddojodxerdlbn.supabase.co';

  static const String publishableKey =
      'sb_publishable_-ukzI9YkxmWvymZUuKgmPQ_bbZtSFvz';

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: url,
      publishableKey: publishableKey,
    );
  }

  static SupabaseClient get client =>
      Supabase.instance.client;
}
