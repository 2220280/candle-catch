/***
**
*このpage新しくdevalopからpullするたびに自分のファイルにかきなおしてねーー
 */

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import './view/page/navibar.dart';
import './constants/colors.dart';
import './view/page/addFriends/my_qr_screen.dart';

Future<void> main() async {
  // Flutter エンジンの初期化
  WidgetsFlutterBinding.ensureInitialized();

  // Firebaseの初期化
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 日付フォーマットの初期化
  await initializeDateFormatting('ja_JP');
  // アプリの起動
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Candle Catch',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: AppColors.background,
      ),
      home: const MyQrScreen(),
      //home: NotificationScreen(),
      //home: Navibar(),
    );
  }
}
