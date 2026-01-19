// 誕生日の仮データ

import '../model/birthday_model.dart';
import 'dart:math';

final Random _random = Random();

final List<String> _names = [
  'はな',
  'そうた',
  'ゆい',
  'たろう',
  'りん',
  'けん',
  'あや',
  'しん',
  'みお',
  'ゆうた',
  'さくら',
  'こうた',
  'えり',
  'たけし',
  'まい',
];

final List<String> _images = [
  'images/sample.jpg',
  'images/sample.jpg',
  'images/sample.jpg',
];

final List<BirthdayData> birthdayList = [
  BirthdayData(
    name: 'はな',
    birthday: DateTime(2000, 1, 1),
    imagePath: 'images/sample.jpg',
  ),
  BirthdayData(
    name: 'そうた',
    birthday: DateTime(2000, 1, 5),
    imagePath: 'images/sample.jpg',
  ),
  BirthdayData(
    name: 'ゆい',
    birthday: DateTime(2000, 1, 5),
    imagePath: 'images/sample.jpg',
  ),
  BirthdayData(
    name: 'たろう',
    birthday: DateTime(2000, 2, 10),
    imagePath: 'images/sample.jpg',
  ),

  ...List.generate(96, (index) {
    final name = _names[_random.nextInt(_names.length)];
    final month = _random.nextInt(12) + 1;
    final day = _random.nextInt(28) + 1;
    final image = _images[_random.nextInt(_images.length)];
    return BirthdayData(
      name: name,
      birthday: DateTime(2000, month, day),
      imagePath: image,
    );
  }),
];
