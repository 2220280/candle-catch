//プロフィール画面 Navibar右下
import 'dart:convert';

import 'package:candlecatch/view/page/birthdayMemory/candle.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:candlecatch/constants/colors.dart';
import 'package:candlecatch/view/page/birthdayMemory/YearDetail.dart';

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
      body: SafeArea(
        child: Column(
          children: [
            _ProfileHeader(),
            SizedBox(height: height * 0.05),
            _AchievementBar(progress: current / 366, current: current),
            _StackedCarouselPage(),
            //TODO: ナビバー追加
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // 1. ユーザー名とフレンド追加、設定アイコン
          _buildTopBar(context),
          SizedBox(height: height * 0.03),
          // 2. プロフィール画像、名前、生年月日
          _buildUserInfo(context),
        ],
      ),
    );
  }

  // ユーザー名とフレンド追加、設定アイコン
  Widget _buildTopBar(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        const Text(
          'sota_sota',
          style: TextStyle(
            fontSize: 32,
            fontFamily: "Corporate Logo Rounded Bold",
            color: AppColors.textBlack,
          ),
        ),
        Row(
          children: <Widget>[
            _buildFriendButton(context),
            SizedBox(width: width * 0.03),
            _buildSettingsButton(context),
          ],
        ),
      ],
    );
  }

  // フレンドアイコン（画像）のボタン
  Widget _buildFriendButton(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return InkWell(
      onTap: () {
        // フレンド画面へ遷移
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Profile(current: 20) /*FriendsScreen()*/,
          ),
        );
      },
      child: SizedBox(
        width: width * 0.07, // アイコンサイズに合わせて幅を設定
        height: height * 0.03, // アイコンサイズに合わせて高さを設定
        child: Image.asset('images/addFriend.png', fit: BoxFit.contain),
      ),
    );
  }

  // 設定アイコンのボタン
  Widget _buildSettingsButton(BuildContext context) {
    // IconButtonは標準でタップ可能で、マテリアルデザインのリップルエフェクトを持つ
    return IconButton(
      icon: const Icon(Icons.settings, color: AppColors.textBlack, size: 28),
      padding: EdgeInsets.zero, // IconButtonのデフォルトのパディングを削除したい場合
      constraints: const BoxConstraints(), // サイズをIconウィジェットに合わせたい場合
      onPressed: () {
        // 設定画面へ遷移
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Profile(current: 20) /*SettingsScreen()*/,
          ),
        );
      },
    );
  }

  // プロフィール画像とテキスト情報
  Widget _buildUserInfo(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const CircleAvatar(
          radius: 40,
          backgroundImage: AssetImage('images/card1.JPEG'), //TODO: プロフィール画像
          backgroundColor: AppColors.textLightBlack, // 画像がない場合
        ),

        SizedBox(width: width * 0.05),

        // 名前と生年月日
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Sota', //TODO: 名前
              style: TextStyle(fontSize: 22, color: AppColors.textBlack),
            ),
            SizedBox(height: height * 0.005),
            Text(
              '2004/01/21', //TODO: 誕生日
              style: TextStyle(
                fontSize: 32,
                fontFamily: "Corporate Logo Rounded Bold",
                color: AppColors.textBlack,
              ),
            ),
          ],
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
    final height = MediaQuery.of(context).size.height; // 844
    final width = MediaQuery.of(context).size.width; // 390

    // ------------------------------------
    // スケール (大きさ) の計算を再調整
    // ------------------------------------
    // relativePosition.abs() が 0 (中央) から離れるほど、 scale の値が小さくなります
    // 0.2 は調整係数です。この値を大きくすると、奥のカードがより急激に小さくなります。
    // 小さくすると、奥のカードの大きさが中央に近くなります。
    final double calculatedScale =
        1.0 - (relativePosition.abs() * 0.5); // 例: 0.25 に変更

    // 最小スケールを設定 (カードが極端に小さくなりすぎないように)
    // 写真のUIのように奥のカードを小さく見せるには、この最小値を低く設定します。
    // 例: 0.7 から 0.6 や 0.5 に変更
    final double finalScale = math.max(0.7, calculatedScale);

    // 不透明度も奥に行くほど下げる
    // 0.3 も調整係数です。大きくすると、奥のカードがより早く透明に近づきます。
    final double calculatedOpacity = 1.0 - (relativePosition.abs() * 0.3);
    final double finalOpacity = math.max(
      0.0,
      calculatedOpacity,
    ); // 最小不透明度 0.0 を維持

    // X軸の移動量 (offsetX)
    // 100.0 は調整値です。この値を変更して重なり具合を調整してください。
    final double offsetX = relativePosition * 0;

    // Y軸の移動量 (offsetY)
    // 20.0 は調整値です。
    final double currentOffsetY = relativePosition.abs() * 0;

    // ------------------------------------
    // Transform の適用 (finalScale を使用)
    // ------------------------------------
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



// TODO: カードタップ後遷移処理