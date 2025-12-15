import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import './view/page/navibar.dart';
import './constants/colors.dart';
import 'firebase_options.dart';
// import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase 初期化 (必要ならコメント外す)
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  // 日本語ロケールの初期化
  await initializeDateFormatting('ja_JP');

  // アプリ起動
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: AppColors.background,
      title: 'Candle Catch',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const Navibar(), // TODO: 初期画面に
    );
  }
}
