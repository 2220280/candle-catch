//

import 'package:flutter/material.dart';

import 'package:flutter_3d_carousel/flutter_3d_carousel.dart';

import 'package:cached_network_image/cached_network_image.dart';

class Candlelist extends StatefulWidget {
  final String year;
  final String candles;


  const Candlelist({
    super.key,
    required this.year,
    required this.candles

  });

  @override
  State<Candlelist> createState() => _HomeState();
}

class _HomeState extends State<Candlelist> {

  String? selectedCandle;

  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height * 0.10),
        child: AppBar(
          backgroundColor: Color(0xFF330867),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 28),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF330867),
              Color(0xFF764BA2),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsetsGeometry.only(left: width * 0.08, right: width * 0.08 ),
              child: Center(
                child: Text(
                  widget.year,
                  style: TextStyle(fontSize: width * 0.10, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              )
            ),

            Padding(
              padding: EdgeInsetsGeometry.only(top: height * 0.01, left: width * 0.08, right: width * 0.08 ),
              child: Center(
                child: Text(
                  "ベストショット",
                  style: TextStyle(fontSize: width * 0.06, color: Colors.white),
                ),
              )
            ),

            Padding(
              padding: EdgeInsetsGeometry.only(top: height * 0.01, left: width * 0.08, right: width * 0.08 ),
              child: Center(
                child: AspectRatio(
                  aspectRatio: 3 / 4,
                  child: Image.network(
                    "https://picsum.photos/200/350/",
                  ),
                )
              )
            ),

            Expanded(
              child: CarouselWidget3D(
                radius: width / 2,
                childScale: 0.7,
                dragEndBehavior: DragEndBehavior.snapToNearest,
                backgroundTapBehavior:
                    BackgroundTapBehavior.startAndSnapToNearest,
                childTapBehavior: ChildTapBehavior.stopAndSnapToChild,
                isDragInteractive: true,
                onlyRenderForeground: false,
                clockwise: false,
                backgroundBlur: 3,
                spinWhileRotating: false,
                shouldRotate: true,
                timeForFullRevolution: 12000,
                snapTimeInMillis: 100,
                perspectiveStrength: 0.001,
                dragSensitivity: 1.5,
                onValueChanged: (newValue) {
                },
                children: List.generate(candles.length, (index) {
                  return CarouselChild(
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: candles[index],
                        fit: BoxFit.cover,
                        width: width / 3,
                        height: width / 3,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        selectedCandle = candles[index];
                      });
                    },
                  );
                }),
              ),
            ),
          ],
        )
      ),
    );
  }
}

//キャンドル画像仮データ　TODO:画像だけの用意なので、送ってくれた人やギフトなどを確認する処理
List<String> candles = [
  "https://picsum.photos/200/200/",
  "https://picsum.photos/210/210/",
  "https://picsum.photos/220/220/",
  "https://picsum.photos/230/230/",
  "https://picsum.photos/240/240/",
  "https://picsum.photos/250/250/",
  "https://picsum.photos/260/260/",
  "https://picsum.photos/270/270/",
];
