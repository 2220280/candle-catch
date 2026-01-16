//新規登録画面
import 'package:flutter/material.dart';
import 'package:candlecatch/constants/colors.dart';
import 'package:candlecatch/view/components/form.dart';
import 'package:candlecatch/view/components/button.dart';
import 'package:candlecatch/services/auth_service.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  SignUpState createState() => SignUpState();
}

class SignUpState extends State<SignUp> {
  // 各入力を管理するコントローラ
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _idController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        // キーボード表示によるエラー防止
        child: SingleChildScrollView(
          child: Column(
            children: [
              _Header(),
              SizedBox(height: height * 0.05),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: [
                    CustomTextField(
                      controller: _emailController,
                      labelText: 'メールアドレス',
                      hintText: 'メールアドレス',
                      obscureText: false,
                    ),
                    SizedBox(height: height * 0.03),
                    CustomTextField(
                      controller: _nameController,
                      labelText: '名前',
                      hintText: '名前',
                      obscureText: false,
                    ),
                    SizedBox(height: height * 0.03),
                    CustomTextField(
                      controller: _idController,
                      labelText: 'ID',
                      hintText: 'ID',
                      obscureText: false,
                    ),
                    SizedBox(height: height * 0.03),
                    CustomTextField(
                      controller: _passwordController,
                      labelText: 'パスワード',
                      hintText: 'パスワード',
                      obscureText: true,
                    ),
                    SizedBox(height: height * 0.08),

                    // 登録ボタン
                    _isLoading
                        ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.textBlack,
                            ),
                          )
                        : BrandGradientButton(
                            text: '新規登録',
                            onPressed: () async {
                              // 空チェック
                              if (_emailController.text.isEmpty ||
                                  _passwordController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('必須項目を入力してください'),
                                  ),
                                );
                                return;
                              }

                              setState(() => _isLoading = true);

                              // AuthServiceの呼び出し
                              String? result = await AuthService().signUp(
                                _emailController.text.trim(),
                                _passwordController.text.trim(),
                                _nameController.text.trim(),
                              );

                              if (!context.mounted) return;
                              setState(() => _isLoading = false);

                              if (result == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('アカウントを作成しました')),
                                );
                                // ログイン状態になるのでメイン画面へ
                                Navigator.pop(context); // ログイン画面にもどる
                              } else {
                                ScaffoldMessenger.of(
                                  context,
                                ).showSnackBar(SnackBar(content: Text(result)));
                              }
                            },
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ヘッダー
class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height; // 844
    return Container(
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: height * 0.1),
              child: _HeaderTitle(),
            ),
          ),
          Positioned(top: height * 0.02, left: 0, child: AppBackButton()),
        ],
      ),
    );
  }
}

class _HeaderTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '新規登録',
          style: TextStyle(
            fontFamily: "Corporate Logo Rounded Bold",
            fontSize: 32, // TODO:フォントサイズレスポンシブ対応
          ),
        ),
      ],
    );
  }
}

// グラデーションぼたん (仮)
class _HeaderBackButtonEx extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height; // 844
    final width = MediaQuery.of(context).size.width; // 390
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        width: width * 0.11,
        height: height * 0.05,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: AppColors.kBrandGradient, // ←背景をグラデーションに！
        ),
        child: const Icon(
          Icons.chevron_left,
          color: AppColors.textWhite, // 白い矢印の方が映える！
          size: 28, // TODO: レスポンシブ対応
        ),
      ),
    );
  }
}
