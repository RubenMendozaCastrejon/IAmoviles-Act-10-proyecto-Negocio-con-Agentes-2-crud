import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/activo_model.dart';
import '../models/transaccion_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ── ACTIVOS ──────────────────────────────────────────────

  Future<List<ActivoModel>> getActivos() async {
    final snapshot = await _db.collection('activos').get();
    return snapshot.docs
        .map((doc) => ActivoModel.fromJson(doc.data(), id: doc.id))
        .toList();
  }

  Future<void> addActivo(ActivoModel activo) async {
    await _db.collection('activos').add(activo.toJson());
  }

  Future<void> updateActivo(ActivoModel activo) async {
    if (activo.id == null) return;
    await _db.collection('activos').doc(activo.id).update(activo.toJson());
  }

  Future<void> deleteActivo(String id) async {
    await _db.collection('activos').doc(id).delete();
  }

  // ── TRANSACCIONES ────────────────────────────────────────

  Future<List<TransaccionModel>> getTransacciones() async {
    final snapshot = await _db.collection('transacciones').get();
    return snapshot.docs
        .map((doc) => TransaccionModel.fromJson(doc.data(), id: doc.id))
        .toList();
  }

  Future<void> addTransaccion(TransaccionModel transaccion) async {
    await _db.collection('transacciones').add(transaccion.toJson());
  }

  Future<void> updateTransaccion(TransaccionModel transaccion) async {
    if (transaccion.id == null) return;
    await _db
        .collection('transacciones')
        .doc(transaccion.id)
        .update(transaccion.toJson());
  }

  Future<void> deleteTransaccion(String id) async {
    await _db.collection('transacciones').doc(id).delete();
  }
}