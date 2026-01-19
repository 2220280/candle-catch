import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ユーザーIDの取得
  String? get currentUid => FirebaseAuth.instance.currentUser?.uid;

  // 初期ユーザーデータ作成
  Future<void> createNewUserData({
    required String uid,
    required String email,
    required String username,
  }) async {
    return await _db.collection('users').doc(uid).set({
      'user_id': uid, // PK
      'email': email,
      'name': username,
      'created_at': FieldValue.serverTimestamp(), // 登録日時
      // その他の初期フィールドを設定
      'is_receive_encounter': true, // すれ違い祝福の受信設定
      'level_id': 1, // 現在のレベルID
    });
  }

  // 記録の作成
  Future<void> createYearlyBirthdayRecord({
    required String userId,
    required int year,
    required String photoUrl,
    required bool isPublic,
  }) async {
    // birthdaysに新しいドキュメントを作成
    await _db.collection('birthdays').add({
      'user_id': userId, // FK: user_id (userテーブルへの参照) [cite: 10]
      'year': year, // 記録の対象年
      'photo_url': photoUrl, // 本気の一枚の画像url
      'candle_count': 0, // その年に祝われたキャンドルの数 (初期値0)
      'is_public': isPublic, // 公開/非公開設定
      'created_at': FieldValue.serverTimestamp(), // 登録日時
    });
  }

  // 特定ユーザーの全誕生日記録を取得
  Stream<List<Map<String, dynamic>>> streamUserBirthdays(String userId) {
    return _db
        .collection('birthdays')
        .where('user_id', isEqualTo: userId) // FK
        .orderBy('year', descending: true) // 新しい年が上
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => {...doc.data(), 'document_id': doc.id})
              .toList(),
        );
  }

  // 祝いイベントの作成（キャンドルを贈る処理）
  Future<void> createCelebration({
    required String receiverId,
    required String yearlyRecordId,
    required bool isEncounter,
    required Map<String, dynamic> candleData,
    required Map<String, dynamic> giftData,
    required Map<String, dynamic> messageData,
  }) async {
    final senderId = currentUid;
    if (senderId == null) {
      throw Exception("ログインユーザーが見つかりません。");
    }

    await _db.collection('celebrations').add({
      'receiver_id': receiverId, // FK
      'sender_id': senderId, // FK
      'yearly_record_id': yearlyRecordId,
      'is_encounter': isEncounter,
      'celebration_date': FieldValue.serverTimestamp(),
      'candle': candleData,
      'gift': giftData,
      'message': messageData,
    });
  }

  // ユーザーが受け取った祝いイベントのリストを取得（受信トレイ）
  Stream<List<Map<String, dynamic>>> streamReceivedCelebrations(String userId) {
    return _db
        .collection('celebrations')
        .where('receiver_id', isEqualTo: userId)
        .orderBy('celebration_date', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => {...doc.data(), 'celebration_id': doc.id})
              .toList(),
        );
  }
}
