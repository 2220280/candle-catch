import 'package:flutter/material.dart';

class Candle extends StatefulWidget {
  const Candle({super.key});

  @override
  State<Candle> createState() => _CandleState();
}

class _CandleState extends State<Candle> {
  @override
  Widget build(BuildContext context) {
    //TODO: キャンドルの見た目実装
    return Container(
      width: 200,
      height: 200,

      child: Image(image: AssetImage('candle/candle.png')),
    );
  }
}
