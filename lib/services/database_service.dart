// lib/services/database_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String? get currentUid => FirebaseAuth.instance.currentUser?.uid;

  // 新規登録時にAuthServiceから呼ばれる初期データ作成メソッド
  Future<void> createNewUserData({
    required String uid,
    required String username,
    required String displayId,
    required String email,
  }) async {
    try {
      await _db.collection('users').doc(uid).set({
        'uid': uid,
        'name': username,
        'display_id': displayId,
        'email': email,
        'created_at': FieldValue.serverTimestamp(),
        'updated_at': FieldValue.serverTimestamp(),
        'candle_total': 0, // 総キャンドル数などの初期値
      });
    } catch (e) {
      rethrow;
    }
  }

  // 祝いイベントの作成とキャンドル数の更新を保証するトランザクション処理
  Future<void> createCelebration(
    String receiverId,
    String yearlyRecordId,
    bool isEncounter,
    Map<String, dynamic> candleData,
    Map<String, dynamic> giftData,
    Map<String, dynamic> messageData,
  ) async {
    final senderId = currentUid;
    if (senderId == null) {
      throw Exception("ログインユーザーが見つかりません。");
    }

    final birthdayRef = _db.collection('birthdays').doc(yearlyRecordId);
    final celebrationRef = _db.collection('celebrations');

    // トランザクションの実行
    await _db.runTransaction((transaction) async {
      // 1. birthdaysのドキュメントを読み取り (ロックと最新値の取得)
      final birthdaySnapshot = await transaction.get(birthdayRef);
      if (!birthdaySnapshot.exists) {
        throw Exception("対象の誕生日記録が見つかりません。yearlyRecordIdが無効です。");
      }

      // 2. celebrationsに新しい記録を作成
      transaction.set(celebrationRef.doc(), {
        'receiver_id': receiverId,
        'sender_id': senderId,
        'yearly_record_id': yearlyRecordId,
        'is_encounter': isEncounter,
        'celeberation_date': FieldValue.serverTimestamp(),
        'candle': candleData,
        'gift': giftData,
        'message': messageData,
      });

      // 3. candle_countをインクリメントして更新
      final currentCount = birthdaySnapshot.data()!['candle_count'] as num;
      transaction.update(birthdayRef, {'candle_count': currentCount + 1});
    });
  }

  // 図鑑エントリの作成（ユーザーを図鑑に登録）
  Future<void> createCollectionEntry({
    required String ownerId,
    required String targetId,
    required bool isFavorite,
  }) async {
    await _db.collection('collections').add({
      'owner_id': ownerId,
      'target_id': targetId,
      'is_favorite': isFavorite,
      'times_celebrated': 1,
    });
  }

  // 特定ユーザーの図鑑リストを取得
  Stream<List<Map<String, dynamic>>> streamUserCollection(String ownerId) {
    return _db
        .collection('collections')
        .where('owner_id', isEqualTo: ownerId) // 所有者IDでフィルタ
        .orderBy('is_favorite', descending: true) // お気に入り優先でソート
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  // 通知の作成
  Future<void> createNotification({
    required String userId, // 通知を受け取るユーザー
    required String title,
    required String body,
    required String type, // Celebration, Birthdayなど
    String? targetUserId, // 通知の対象ユーザーID
    String? targetRecordId, // 通知のトリガーとなったレコードID
  }) async {
    await _db.collection('notifications').add({
      'user_id': userId, // FK: 通知を受け取るユーザー
      'title': title,
      'body': body,
      'type': type,
      'target_user_id': targetUserId,
      'target_record_id': targetRecordId,
      'is_read': false, // 初期値は未読
      'sent_at': FieldValue.serverTimestamp(), // 送信日時
    });
  }

  // 特定ユーザーの通知リストを取得（未読フィルタリング機能付き）
  Stream<List<Map<String, dynamic>>> streamUserNotifications(String userId) {
    return _db
        .collection('notifications')
        .where('user_id', isEqualTo: userId) // 受信者IDでフィルタ
        .orderBy('sent_at', descending: true) // 新しいものが上
        // .where('is_read', isEqualTo: false) // 未読フィルタが必要な場合は、別途インデックスが必要です
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }
}
