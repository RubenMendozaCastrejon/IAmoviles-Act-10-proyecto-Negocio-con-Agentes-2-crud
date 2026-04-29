import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/activo_model.dart';
import '../../providers/activo_provider.dart';

class ActivoEditScreen extends StatefulWidget {
  final ActivoModel activo;
  const ActivoEditScreen({super.key, required this.activo});

  @override
  State<ActivoEditScreen> createState() => _ActivoEditScreenState();
}

class _ActivoEditScreenState extends State<ActivoEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nombreController;
  late final TextEditingController _tipoController;
  late final TextEditingController _valorController;
  late final TextEditingController _descripcionController;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.activo.nombre);
    _tipoController = TextEditingController(text: widget.activo.tipo);
    _valorController =
        TextEditingController(text: widget.activo.valor.toString());
    _descripcionController =
        TextEditingController(text: widget.activo.descripcion);
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _tipoController.dispose();
    _valorController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  void _guardar() async {
    if (_formKey.currentState!.validate()) {
      final activoActualizado = ActivoModel(
        id: widget.activo.id,
        nombre: _nombreController.text.trim(),
        tipo: _tipoController.text.trim(),
        valor: double.tryParse(_valorController.text.trim()) ?? 0,
        descripcion: _descripcionController.text.trim(),
      );

      await context.read<ActivoProvider>().updateActivo(activoActualizado);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Activo actualizado correctamente')),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<ActivoProvider>().isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Activo'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nombreController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre del activo',
                    prefixIcon: Icon(Icons.label),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _tipoController,
                  decoration: const InputDecoration(
                    labelText: 'Tipo',
                    prefixIcon: Icon(Icons.category),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _valorController,
                  decoration: const InputDecoration(
                    labelText: 'Valor (\$)',
                    prefixIcon: Icon(Icons.attach_money),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Campo requerido';
                    if (double.tryParse(v) == null) return 'Número inválido';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descripcionController,
                  decoration: const InputDecoration(
                    labelText: 'Descripción',
                    prefixIcon: Icon(Icons.notes),
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Actualizar Activo'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: isLoading ? null : _guardar,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}