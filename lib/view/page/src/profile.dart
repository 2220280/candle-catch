//PAGE:プロフィール画面 Navibar右下
import 'package:flutter/material.dart';
import 'dart:math' as math;

///const
import 'package:candlecatch/constants/colors.dart';

///components
import '../../components/button.dart';

///page
import 'package:candlecatch/view/page/birthdayMemory/candle.dart';
import './setting.dart';
import '../addFriends/my_qr_screen.dart';

// Profile 呼び出しの際に図鑑達成数取得
class Profile extends StatelessWidget {
  final int current; // 図鑑達成数

  const Profile({super.key, required this.current});
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        toolbarHeight: height * 0.1,
        elevation: 0,
        title: _buildTopBar(context),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: height * 0.05),
            Align(alignment: Alignment.center, child: _buildUserInfo()),
            SizedBox(height: height * 0.05),
            _AchievementBar(progress: current / 366, current: current),
            _StackedCarouselPage(),
          ],
        ),
      ),
    );
  }

  //topbar
  Widget _buildTopBar(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        const Text(
          'sota_sota',
          style: TextStyle(
            fontSize: 30,
            fontFamily: "Corporate Logo Rounded Bold",
            color: AppColors.textBlack,
          ),
        ),
        Row(
          children: <Widget>[
            TopCircleButton(
              icon: Icons.qr_code_2,
              onTap: () {
                // フレンド画面へ遷移
                print('tap');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyQrScreen()),
                );
              },
            ),
            SizedBox(width: width * 0.03),
            // _buildSettingsButton(context),
            TopCircleButton(
              icon: Icons.settings,
              onTap: () {
                // 設定画面へ遷移
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Setting()),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  //user情報
  //TODO: サイズ調整必要
  Widget _buildUserInfo() {
    final String img = "icon/icon1.png";
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(img),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [Text('SOTA'), Text('2004/10/10')],
        ),
      ],
    );
  }
}

class _AchievementBar extends StatefulWidget {
  final double progress; // 進捗パーセント
  final int current; // 図鑑達成数

  const _AchievementBar({
    super.key,
    required this.progress,
    required this.current,
  }); //TODO: 図鑑達成率を渡す

  @override
  State<_AchievementBar> createState() => _AchievementBarState();
}

class _AchievementBarState extends State<_AchievementBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    // グラデーション色をアニメーション
    _colorAnimation = ColorTween(
      begin: AppColors.gradientStart,
      end: AppColors.gradientEnd,
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Text(
          "図鑑達成率  ${widget.current} / 366",
          style: TextStyle(
            fontFamily: "Corporate Logo Rounded Bold",
            color: AppColors.textLightBlack,
            fontSize: 15, // TODO:フォントサイズレスポンシブ対応
          ),
        ),
        SizedBox(height: height * 0.006),
        Container(
          width: width * 0.4, // Barの全体の横幅
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return LinearProgressIndicator(
                  minHeight: height * 0.015, // Bar高さ
                  value: widget.progress, // Bar色つき横幅
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _colorAnimation.value ?? AppColors.gradientStart,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _StackedCarouselPage extends StatefulWidget {
  const _StackedCarouselPage({Key? key}) : super(key: key);

  @override
  _StackedCarouselPageState createState() => _StackedCarouselPageState();
}

class _StackedCarouselPageState extends State<_StackedCarouselPage> {
  final List<List<String>> cardImages = [
    ['images/card1.JPEG', '2022'],
    ['images/card1.JPEG', '2023'],
    ['images/card3.JPEG', '2024'],
    ['images/card4.JPG', '2025'],
  ];

  late PageController _pageController;
  double _currentPage = 0.0; // 現在のページ位置 (doubleで正確なスクロール位置を保持)

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.6, // 中央のカードの表示領域 (60%)
      initialPage: cardImages.length,
    );

    // ページ監視
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: height * 0.45, // カルーセルの高さを指定
          child: PageView.builder(
            controller: _pageController,
            itemCount: cardImages.length,
            itemBuilder: (context, index) {
              // 各カードのオフセット（中央からの距離）
              // _currentPageはdoubleなので、indexとの差が正確な位置を示す
              final double relativePosition = index - _currentPage;
              //TODO: 追加リストから画像パスと年度を取り出す
              final String imagePath = cardImages[index][0];
              final String year = cardImages[index][1];
              // 奥に行くほど小さく、不透明になるように調整
              // 完全に画面外に出たカードは極端に小さく、透明にする
              final double scale =
                  1.0 - (relativePosition.abs() * -0.3); // 0.2は調整値
              final double opacity =
                  1.0 - (relativePosition.abs() * 0.3); // 0.3は調整値

              // 奥に行くほどY軸方向に少しずらす (写真のUIに合わせる)
              final double offsetY = relativePosition.abs() * 20; // 20は調整値

              return _buildCard(
                imagePath: imagePath,
                year: year,
                scale: math.max(0.7, scale), // 最小スケールを設定 (0.7より小さくならない)
                opacity: math.max(0.0, opacity), // 最小不透明度を設定 (0.0より小さくならない)
                offsetY: offsetY,
                relativePosition: relativePosition,
                isCurrentPage:
                    (index == _currentPage.round()), // 中央のカードかどうかの簡易判定
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCard({
    required String imagePath,
    required String year,
    required double scale,
    required double opacity,
    required double offsetY,
    required double relativePosition,
    required bool isCurrentPage,
  }) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final double calculatedScale = 1.0 - (relativePosition.abs() * 0.5);

    final double finalScale = math.max(0.7, calculatedScale);

    final double calculatedOpacity = 1.0 - (relativePosition.abs() * 0.3);
    final double finalOpacity = math.max(0.0, calculatedOpacity);

    final double offsetX = relativePosition * 0;

    final double currentOffsetY = relativePosition.abs() * 0;

    Key? cardKey = isCurrentPage
        ? ValueKey('center_card_$imagePath')
        : null; // add
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Transform.translate(
          key: cardKey, // add
          // X軸の移動量を適用
          offset: Offset(
            offsetX,
            currentOffsetY * (relativePosition > 0 ? 1 : -1),
          ),
          child: Transform.scale(
            scale: finalScale, // ここに計算した finalScale を適用
            alignment: Alignment.center,
            child: Opacity(
              opacity: finalOpacity,
              child: GestureDetector(
                onTap: () {
                  if (isCurrentPage) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            candle(year: year, imagePath: imagePath),
                      ),
                    );
                  } else {
                    // 中央以外のカードがタップされたら、そのカードを中央に持ってくる
                    _pageController.animateToPage(
                      _pageController.position.pixels ~/
                              _pageController.position.viewportDimension +
                          relativePosition.round(),
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                },
                child: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 0.0,
                    vertical: height * 0.02,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1), //TODO: 色を変更
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: Hero(
                      tag: imagePath,
                      child: Image.asset(
                        imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: AppColors.textLightBlack,
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.image_not_supported,
                            size: 50,
                            color: AppColors.textLightBlack,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (isCurrentPage) ...[
          Text(
            "$year", //TODO: 名表示
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: "Corporate Logo Rounded Bold",
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textLightBlack,
              // TODO: 影いる？
              // shadows: [
              //   Shadow(
              //     blurRadius: 3,
              //     color: Colors.black.withOpacity(0.4),
              //     offset: Offset(1, 1),
              //   ),
              // ],
            ),
          ),
        ],
      ],
    );
  }
}
