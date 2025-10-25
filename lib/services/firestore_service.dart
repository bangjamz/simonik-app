import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/indicator_model.dart';
import '../models/monev_model.dart';
import '../models/settings_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ============ USER MANAGEMENT ============
  Future<List<UserModel>> getAllUsers() async {
    final snapshot = await _db.collection('users').get();
    return snapshot.docs
        .map((doc) => UserModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _db.collection('users').doc(uid).update(data);
  }

  Future<void> deleteUser(String uid) async {
    await _db.collection('users').doc(uid).delete();
  }

  // ============ INDICATOR CATEGORY MANAGEMENT ============
  Future<List<IndicatorCategory>> getCategories() async {
    final snapshot =
        await _db.collection('indicator_categories').orderBy('order').get();
    return snapshot.docs
        .map((doc) => IndicatorCategory.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<List<IndicatorCategory>> getSubCategories(String parentId) async {
    final snapshot = await _db
        .collection('indicator_categories')
        .where('parent_id', isEqualTo: parentId)
        .orderBy('order')
        .get();
    return snapshot.docs
        .map((doc) => IndicatorCategory.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<String> addCategory(IndicatorCategory category) async {
    final doc = await _db.collection('indicator_categories').add(category.toMap());
    return doc.id;
  }

  Future<void> updateCategory(String id, Map<String, dynamic> data) async {
    await _db.collection('indicator_categories').doc(id).update(data);
  }

  Future<void> deleteCategory(String id) async {
    await _db.collection('indicator_categories').doc(id).delete();
  }

  // ============ INDICATOR MANAGEMENT ============
  Future<List<Indicator>> getIndicators() async {
    final snapshot =
        await _db.collection('indicators').where('is_active', isEqualTo: true).orderBy('order').get();
    return snapshot.docs
        .map((doc) => Indicator.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<List<Indicator>> getIndicatorsByType(String type) async {
    final snapshot = await _db
        .collection('indicators')
        .where('type', isEqualTo: type)
        .where('is_active', isEqualTo: true)
        .orderBy('order')
        .get();
    return snapshot.docs
        .map((doc) => Indicator.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<List<Indicator>> getIndicatorsByCategory(String categoryId) async {
    final snapshot = await _db
        .collection('indicators')
        .where('category_id', isEqualTo: categoryId)
        .where('is_active', isEqualTo: true)
        .orderBy('order')
        .get();
    return snapshot.docs
        .map((doc) => Indicator.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<String> addIndicator(Indicator indicator) async {
    final doc = await _db.collection('indicators').add(indicator.toMap());
    return doc.id;
  }

  Future<void> updateIndicator(String id, Map<String, dynamic> data) async {
    await _db.collection('indicators').doc(id).update(data);
  }

  Future<void> deleteIndicator(String id) async {
    await _db.collection('indicators').doc(id).update({'is_active': false});
  }

  // ============ MONEV SESSION MANAGEMENT ============
  Future<List<MonevSession>> getMonevSessions() async {
    final snapshot = await _db
        .collection('monev_sessions')
        .orderBy('created_at', descending: true)
        .get();
    return snapshot.docs
        .map((doc) => MonevSession.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<MonevSession?> getMonevSessionByCode(String code) async {
    final snapshot = await _db
        .collection('monev_sessions')
        .where('session_code', isEqualTo: code)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;
    return MonevSession.fromMap(snapshot.docs.first.data(), snapshot.docs.first.id);
  }

  Future<List<MonevSession>> getMonevSessionsByAuditor(String auditorId) async {
    final snapshot = await _db
        .collection('monev_sessions')
        .where('auditor_id', isEqualTo: auditorId)
        .orderBy('created_at', descending: true)
        .get();
    return snapshot.docs
        .map((doc) => MonevSession.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<List<MonevSession>> getMonevSessionsByAuditee(String auditeeId) async {
    final snapshot = await _db
        .collection('monev_sessions')
        .where('auditee_id', isEqualTo: auditeeId)
        .orderBy('created_at', descending: true)
        .get();
    return snapshot.docs
        .map((doc) => MonevSession.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<String> createMonevSession(MonevSession session) async {
    final doc = await _db.collection('monev_sessions').add(session.toMap());
    return doc.id;
  }

  Future<void> updateMonevSession(String id, Map<String, dynamic> data) async {
    await _db.collection('monev_sessions').doc(id).update(data);
  }

  Future<void> deleteMonevSession(String id) async {
    // Delete session and all evaluations
    await _db.collection('monev_sessions').doc(id).delete();
    final evaluations = await _db
        .collection('monev_evaluations')
        .where('session_id', isEqualTo: id)
        .get();
    for (var doc in evaluations.docs) {
      await doc.reference.delete();
    }
  }

  // ============ MONEV EVALUATION MANAGEMENT ============
  Future<List<MonevEvaluation>> getEvaluationsBySession(String sessionId) async {
    final snapshot = await _db
        .collection('monev_evaluations')
        .where('session_id', isEqualTo: sessionId)
        .orderBy('evaluated_at')
        .get();
    return snapshot.docs
        .map((doc) => MonevEvaluation.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<String> addEvaluation(MonevEvaluation evaluation) async {
    final doc = await _db.collection('monev_evaluations').add(evaluation.toMap());
    return doc.id;
  }

  Future<void> updateEvaluation(String id, Map<String, dynamic> data) async {
    await _db.collection('monev_evaluations').doc(id).update(data);
  }

  Future<void> deleteEvaluation(String id) async {
    await _db.collection('monev_evaluations').doc(id).delete();
  }

  // Batch save evaluations
  Future<void> batchSaveEvaluations(
      String sessionId, List<MonevEvaluation> evaluations) async {
    final batch = _db.batch();

    // Delete existing evaluations for this session
    final existing = await _db
        .collection('monev_evaluations')
        .where('session_id', isEqualTo: sessionId)
        .get();
    for (var doc in existing.docs) {
      batch.delete(doc.reference);
    }

    // Add new evaluations
    for (var evaluation in evaluations) {
      final docRef = _db.collection('monev_evaluations').doc();
      batch.set(docRef, evaluation.toMap());
    }

    await batch.commit();
  }

  // ============ SETTINGS MANAGEMENT ============
  Future<AppSettings?> getSettings() async {
    final snapshot = await _db.collection('settings').limit(1).get();
    if (snapshot.docs.isEmpty) return null;
    return AppSettings.fromMap(snapshot.docs.first.data(), snapshot.docs.first.id);
  }

  Future<void> updateSettings(String id, Map<String, dynamic> data) async {
    await _db.collection('settings').doc(id).update(data);
  }

  Future<void> createSettings(AppSettings settings) async {
    await _db.collection('settings').doc('app_settings').set(settings.toMap());
  }

  // ============ STATISTICS ============
  Future<Map<String, int>> getStatistics() async {
    final usersCount = await _db.collection('users').get();
    final indicatorsCount = await _db
        .collection('indicators')
        .where('is_active', isEqualTo: true)
        .get();
    final monevCount = await _db.collection('monev_sessions').get();

    return {
      'users': usersCount.docs.length,
      'indicators': indicatorsCount.docs.length,
      'monev_sessions': monevCount.docs.length,
    };
  }
}
