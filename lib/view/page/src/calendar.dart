import 'package:flutter/material.dart';
import 'dart:async';
import '../../../constants/colors.dart';
import '../../components/button.dart';

import '../../../data/birthday_data.dart'; //仮データ
import '../../../model/birthday_model.dart'; //データモデル

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int? _selectedDay;
  DateTime _focusedMonth = DateTime.now();
  late final PageController _pageController;
  final int _initialPage = 1200;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _initialPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  DateTime _monthFromPage(int page) {
    final diff = page - _initialPage;
    return DateTime(DateTime.now().year, DateTime.now().month + diff);
  }

  bool _isToday(int day) {
    final now = DateTime.now();
    return now.year == _focusedMonth.year &&
        now.month == _focusedMonth.month &&
        now.day == day;
  }

  List<BirthdayData> _getBirthdays(int day) {
    return birthdayList
        .where(
          (b) =>
              b.birthday.month == _focusedMonth.month && b.birthday.day == day,
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 16),

                /// 月
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        ShaderMask(
                          shaderCallback: (bounds) {
                            return const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0xFFFFA56B), Color(0xFFFFD36A)],
                            ).createShader(bounds);
                          },
                          child: Text(
                            '${_focusedMonth.month}',
                            style: const TextStyle(
                              fontSize: 96,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 1,
                            ),
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                /// カレンダー
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (page) {
                      setState(() {
                        _focusedMonth = _monthFromPage(page);
                        _selectedDay = null;
                      });
                    },
                    itemBuilder: (context, pageIndex) {
                      final month = _monthFromPage(pageIndex);
                      final daysInMonth = DateUtils.getDaysInMonth(
                        month.year,
                        month.month,
                      );

                      return GridView.builder(
                        padding: const EdgeInsets.all(8),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 7,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 6,
                              childAspectRatio: 0.55,
                            ),
                        itemCount: daysInMonth,
                        itemBuilder: (context, index) {
                          final day = index + 1;

                          return DayImageCard(
                            day: day,
                            birthdays: birthdayList
                                .where(
                                  (b) =>
                                      b.birthday.month == month.month &&
                                      b.birthday.day == day,
                                )
                                .toList(),
                            isToday:
                                DateTime.now().year == month.year &&
                                DateTime.now().month == month.month &&
                                DateTime.now().day == day,
                            isSelected: _selectedDay == day,
                            onTap: () {
                              setState(() {
                                _selectedDay = day;
                              });
                            },
                            focusedMonth: month,
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            Positioned(
              top: 12,
              right: 16,
              child: Row(
                children: [
                  TopCircleButton(
                    icon: Icons.cake,
                    onTap: () {
                      print('tap');
                      //TODO: 誕生日一覧
                    },
                  ),
                  const SizedBox(width: 10),
                  TopCircleButton(
                    icon: Icons.notifications,
                    onTap: () {
                      print('tap');

                      // TODO:通知
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// セル
class DayImageCard extends StatefulWidget {
  final int day;
  final List<BirthdayData> birthdays;
  final bool isToday;
  final bool isSelected;
  final VoidCallback onTap;
  final DateTime focusedMonth;

  const DayImageCard({
    super.key,
    required this.day,
    required this.birthdays,
    required this.isToday,
    required this.isSelected,
    required this.onTap,
    required this.focusedMonth,
  });

  @override
  State<DayImageCard> createState() => _DayImageCardState();
}

class _DayImageCardState extends State<DayImageCard> {
  late final PageController _controller;
  Timer? _timer;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController();

    if (widget.birthdays.length > 1) {
      _timer = Timer.periodic(const Duration(seconds: 3), (_) {
        _index = (_index + 1) % widget.birthdays.length;
        _controller.animateToPage(
          _index,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _showBirthdaySheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          minChildSize: 0.2,
          maxChildSize: 0.8,
          initialChildSize: 0.4,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                controller: scrollController,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  /// タイトル
                  Text(
                    '${widget.focusedMonth.month}/${widget.day}の誕生日',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  /// 誕生日データがない場合
                  if (widget.birthdays.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'なし',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ),
                    )
                  else
                    /// データがある場合は縦にリスト表示
                    ...widget.birthdays.map(
                      (b) => Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              b.imagePath,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            b.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '${b.birthday.month}月${b.birthday.day}日',
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasBirthday = widget.birthdays.isNotEmpty;

    return GestureDetector(
      onTap: () {
        widget.onTap();
        _showBirthdaySheet(); // ボトムシート表示
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: widget.isToday ? const Color(0xFFFFE0B2) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: widget.isSelected
              ? Border.all(color: const Color(0xFFFFE0B2), width: 2)
              : null,
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
        ),
        child: Column(
          children: [
            const SizedBox(height: 6),

            /// 日付
            Text(
              '${widget.day}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 6),

            Expanded(
              child: hasBirthday
                  ? PageView.builder(
                      controller: _controller,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.birthdays.length,
                      itemBuilder: (context, i) {
                        final b = widget.birthdays[i];
                        return Column(
                          children: [
                            Expanded(
                              child: Image.asset(
                                b.imagePath,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Text(
                                b.name,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    )
                  : const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
