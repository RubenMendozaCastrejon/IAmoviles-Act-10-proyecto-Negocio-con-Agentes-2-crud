import 'package:flutter/material.dart';
import '../models/activo_model.dart';
import '../services/firestore_service.dart';

class ActivoProvider extends ChangeNotifier {
  final FirestoreService _service = FirestoreService();
  List<ActivoModel> _activos = [];
  bool _isLoading = false;

  List<ActivoModel> get activos => _activos;
  bool get isLoading => _isLoading;

  Future<void> fetchActivos() async {
    _isLoading = true;
    notifyListeners();
    try {
      _activos = await _service.getActivos();
    } catch (e) {
      debugPrint('Error al obtener activos: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addActivo(ActivoModel activo) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _service.addActivo(activo);
      await fetchActivos();
    } catch (e) {
      debugPrint('Error al agregar activo: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateActivo(ActivoModel activo) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _service.updateActivo(activo);
      await fetchActivos();
    } catch (e) {
      debugPrint('Error al actualizar activo: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteActivo(String id) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _service.deleteActivo(id);
      await fetchActivos();
    } catch (e) {
      debugPrint('Error al eliminar activo: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}