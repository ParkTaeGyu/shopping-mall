import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "assets/env/app.env");

  final supabaseUrl = dotenv.env['SUPABASE_URL'] ?? 'https://zgwhwxfmyvrtmtgzrmxq.supabase.co';
  final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'] ?? 'sb_publishable_46AylNhD376NmXPLttJLmA_SoHy7NK3';

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  runApp(const ProviderScope(child: MyApp()));
}
