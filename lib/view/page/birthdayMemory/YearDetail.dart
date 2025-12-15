//プロフィール画面　Navibar右下
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:candlecatch/constants/colors.dart';

class YearDetail extends StatelessWidget {
  final String year;
  final String imagePath;

  const YearDetail({super.key, required this.year, required this.imagePath});
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/candleBackScreen.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _BestShot(year: year, imagePath: imagePath),
              //TODO: キャンドル追加
              //TODO: ナビバー追加
            ],
          ),
        ),
      ),
    );
  }
}

class _BestShot extends StatelessWidget {
  final String year;
  final String imagePath;

  const _BestShot({super.key, required this.year, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 1. 年度表示
        Text(
          year,
          style: const TextStyle(
            fontFamily: "Corporate Logo Rounded Bold",
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: AppColors.textWhite,
          ),
        ),
        SizedBox(height: height * 0.05),

        // 2. ベストショット
        const Text(
          "ベストショット",
          style: TextStyle(
            fontFamily: "Corporate Logo Rounded Bold",
            fontSize: 20,
            color: AppColors.textWhite,
          ),
        ),
        SizedBox(height: height * 0.02),

        Hero(
          tag: "$imagePath-$year",
          child: Container(
            width: width * 0.57,
            height: height * 0.35,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.asset(imagePath, fit: BoxFit.cover),
            ),
          ),
        ),
      ],
    );
  }
}
