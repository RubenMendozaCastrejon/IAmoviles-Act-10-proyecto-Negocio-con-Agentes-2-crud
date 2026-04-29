import 'package:flutter/material.dart';
import '../models/transaccion_model.dart';
import '../services/firestore_service.dart';

class TransaccionProvider extends ChangeNotifier {
  final FirestoreService _service = FirestoreService();
  List<TransaccionModel> _transacciones = [];
  bool _isLoading = false;

  List<TransaccionModel> get transacciones => _transacciones;
  bool get isLoading => _isLoading;

  Future<void> fetchTransacciones() async {
    _isLoading = true;
    notifyListeners();
    try {
      _transacciones = await _service.getTransacciones();
    } catch (e) {
      debugPrint('Error al obtener transacciones: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTransaccion(TransaccionModel transaccion) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _service.addTransaccion(transaccion);
      await fetchTransacciones();
    } catch (e) {
      debugPrint('Error al agregar transacción: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateTransaccion(TransaccionModel transaccion) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _service.updateTransaccion(transaccion);
      await fetchTransacciones();
    } catch (e) {
      debugPrint('Error al actualizar transacción: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteTransaccion(String id) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _service.deleteTransaccion(id);
      await fetchTransacciones();
    } catch (e) {
      debugPrint('Error al eliminar transacción: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}